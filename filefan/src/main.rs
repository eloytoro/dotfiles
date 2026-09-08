use std::collections::{HashSet, VecDeque};
use std::env;
use std::fs;
use std::path::{Path, PathBuf};

use ignore::gitignore::{Gitignore, GitignoreBuilder};

fn collect_dirs(target: &Path, origin: &Path) -> (Vec<PathBuf>, Option<PathBuf>) {
    let mut dirs = Vec::new();
    let mut git_root = None;
    let mut current = target.to_path_buf();
    loop {
        dirs.push(current.clone());
        if current.join(".git").exists() {
            git_root = Some(current.clone());
            break;
        }
        if current == origin {
            break;
        }
        match current.parent() {
            Some(parent) => current = parent.to_path_buf(),
            None => break,
        }
    }
    (dirs, git_root)
}

const SKIP_DIRS: &[&str] = &[".git", ".hg", ".svn", "node_modules", "target", ".yarn"];

fn walk_files(
    start: &Path,
    visited: &HashSet<PathBuf>,
    gitignore: &Option<(Gitignore, PathBuf)>,
    exclude: &Option<PathBuf>,
    mut on_file: impl FnMut(PathBuf),
) {
    let mut queue = VecDeque::new();
    queue.push_back(start.to_path_buf());

    while let Some(dir) = queue.pop_front() {
        let Ok(entries) = fs::read_dir(&dir) else {
            continue;
        };

        for entry in entries.flatten() {
            let path = entry.path();
            let Ok(ft) = entry.file_type() else { continue };
            let is_dir = ft.is_dir();

            if let Some((gi, root)) = gitignore
                && let Ok(rel) = path.strip_prefix(root)
                && gi.matched(rel, is_dir).is_ignore()
            {
                continue;
            }

            if is_dir {
                if let Some(t) = path.file_name().and_then(|n| n.to_str())
                    && SKIP_DIRS.contains(&t)
                {
                    continue;
                }
                let canonical = fs::canonicalize(&path).unwrap_or_else(|_| path.clone());
                if !visited.contains(&canonical) {
                    queue.push_back(path);
                }
            } else {
                if exclude.as_deref() == Some(&path) {
                    continue;
                }
                on_file(path);
            }
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let cwd = env::current_dir().expect("failed to get current directory");

    let mut origin_arg: Option<&str> = None;
    let mut target_arg: Option<&str> = None;
    let mut iter = args[1..].iter().map(String::as_str);
    while let Some(arg) = iter.next() {
        if arg == "--origin" {
            origin_arg = iter.next();
        } else {
            target_arg = Some(arg);
        }
    }

    let origin = match origin_arg {
        Some(o) => match fs::canonicalize(o) {
            Ok(p) => p,
            Err(e) => {
                eprintln!("filefan: --origin {}: {}", o, e);
                std::process::exit(1);
            }
        },
        None => cwd.clone(),
    };

    let input = target_arg.unwrap_or(".");
    let target = match fs::canonicalize(input) {
        Ok(p) => p,
        Err(e) => {
            eprintln!("filefan: {}: {}", input, e);
            std::process::exit(1);
        }
    };

    let (target, exclude) = if target.is_file() {
        let parent = match target.parent() {
            Some(p) => p.to_path_buf(),
            None => {
                eprintln!("filefan: {}: no parent directory", input);
                std::process::exit(1);
            }
        };
        (parent, Some(target))
    } else if target.is_dir() {
        (target, None)
    } else {
        eprintln!("filefan: {}: not a file or directory", input);
        std::process::exit(1);
    };

    let (dirs, git_root) = collect_dirs(&target, &origin);

    let gitignore = git_root.as_deref().and_then(|root| {
        let mut builder = GitignoreBuilder::new(root);
        builder.add(root.join(".gitignore"));
        builder.build().ok().map(|gi| (gi, root.to_path_buf()))
    });

    let mut visited: HashSet<PathBuf> = HashSet::new();

    for dir in dirs {
        visited.insert(fs::canonicalize(&dir).unwrap_or_else(|_| dir.clone()));
        walk_files(&dir, &visited, &gitignore, &exclude, |path| {
            if let Ok(rel) = path.strip_prefix(&cwd) {
                println!("{}", rel.display());
            } else {
                println!("{}", path.display());
            }
        });
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    use tempfile::TempDir;

    fn setup(structure: &[&str]) -> TempDir {
        let tmp = TempDir::new().unwrap();
        for path in structure {
            let full = tmp.path().join(path);
            if let Some(parent) = full.parent() {
                fs::create_dir_all(parent).unwrap();
            }
            fs::write(&full, "").unwrap();
        }
        tmp
    }

    fn collected_files(
        start: &Path,
        visited: &HashSet<PathBuf>,
        gitignore: &Option<(Gitignore, PathBuf)>,
        exclude: &Option<PathBuf>,
    ) -> Vec<PathBuf> {
        let mut files = Vec::new();
        walk_files(start, visited, gitignore, exclude, |p| files.push(p));
        files.sort();
        files
    }

    // collect_dirs

    #[test]
    fn collect_dirs_stops_at_git_root() {
        let tmp = setup(&[".git/.keep", "a/b/file.txt"]);
        let root = fs::canonicalize(tmp.path()).unwrap();
        let target = root.join("a/b");

        let (dirs, git_root) = collect_dirs(&target, &root);

        assert_eq!(dirs, vec![target.clone(), root.join("a"), root.clone()]);
        assert_eq!(git_root, Some(root));
    }

    #[test]
    fn collect_dirs_stops_at_origin_when_no_git_root() {
        let tmp = setup(&["a/b/file.txt"]);
        let root = fs::canonicalize(tmp.path()).unwrap();
        let target = root.join("a/b");
        let origin = root.join("a");

        let (dirs, git_root) = collect_dirs(&target, &origin);

        assert_eq!(dirs, vec![target, origin]);
        assert_eq!(git_root, None);
    }

    #[test]
    fn collect_dirs_includes_origin_when_it_is_git_root() {
        let tmp = setup(&[".git/.keep", "a/file.txt"]);
        let root = fs::canonicalize(tmp.path()).unwrap();
        let target = root.join("a");

        let (dirs, git_root) = collect_dirs(&target, &root);

        assert_eq!(dirs, vec![target, root.clone()]);
        assert_eq!(git_root, Some(root));
    }

    // walk_files

    #[test]
    fn walk_files_finds_all_files_recursively() {
        let tmp = setup(&["a.txt", "b.txt", "sub/c.txt"]);
        let root = fs::canonicalize(tmp.path()).unwrap();

        let files = collected_files(&root, &HashSet::new(), &None, &None);

        assert_eq!(
            files,
            vec![
                root.join("a.txt"),
                root.join("b.txt"),
                root.join("sub/c.txt")
            ]
        );
    }

    #[test]
    fn walk_files_direct_files_before_subdirectory_files() {
        let tmp = setup(&["a.txt", "sub/b.txt"]);
        let root = fs::canonicalize(tmp.path()).unwrap();

        let mut files = Vec::new();
        walk_files(&root, &HashSet::new(), &None, &None, |p| files.push(p));

        let direct_pos = files.iter().position(|p| p == &root.join("a.txt")).unwrap();
        let nested_pos = files
            .iter()
            .position(|p| p == &root.join("sub/b.txt"))
            .unwrap();
        assert!(direct_pos < nested_pos);
    }

    #[test]
    fn walk_files_excludes_specified_file() {
        let tmp = setup(&["a.txt", "b.txt"]);
        let root = fs::canonicalize(tmp.path()).unwrap();
        let exclude = Some(root.join("a.txt"));

        let files = collected_files(&root, &HashSet::new(), &None, &exclude);

        assert_eq!(files, vec![root.join("b.txt")]);
    }

    #[test]
    fn walk_files_skips_visited_directories() {
        let tmp = setup(&["a.txt", "sub/b.txt"]);
        let root = fs::canonicalize(tmp.path()).unwrap();
        let mut visited = HashSet::new();
        visited.insert(fs::canonicalize(root.join("sub")).unwrap());

        let files = collected_files(&root, &visited, &None, &None);

        assert_eq!(files, vec![root.join("a.txt")]);
    }

    #[test]
    fn walk_files_skips_hardcoded_dirs() {
        let tmp = setup(&["a.txt", ".git/config", "node_modules/pkg/index.js"]);
        let root = fs::canonicalize(tmp.path()).unwrap();

        let files = collected_files(&root, &HashSet::new(), &None, &None);

        assert_eq!(files, vec![root.join("a.txt")]);
    }

    #[test]
    fn walk_files_respects_gitignore() {
        let tmp = setup(&["a.txt", "debug.log", "sub/trace.log"]);
        let root = fs::canonicalize(tmp.path()).unwrap();
        fs::write(root.join(".gitignore"), "*.log\n").unwrap();

        let gitignore = {
            let mut builder = GitignoreBuilder::new(&root);
            builder.add(root.join(".gitignore"));
            builder.build().ok().map(|gi| (gi, root.clone()))
        };

        let files = collected_files(&root, &HashSet::new(), &gitignore, &None);

        assert_eq!(files, vec![root.join(".gitignore"), root.join("a.txt")]);
    }
}
