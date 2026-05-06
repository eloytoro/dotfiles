# pup

Recursively list files up to the git root or working directory.

## Installation

Clone the repo and build with Cargo:

```sh
cargo install --path .
```

## Usage

Pass a directory to list its files, then walk up toward the git root:

```sh
pup <directory>
```

`pup` collects all files under `<directory>` recursively, then climbs each parent in turn. It stops at whichever comes first: the current working directory or a directory containing `.git`. All paths are printed relative to the current working directory.

### Example

```sh
# from ~/projects/myapp
pup src/controllers/users
```

Output:

```
src/controllers/users/index.rs
src/controllers/users/show.rs
src/controllers/mod.rs
src/main.rs
Cargo.toml
```

## Details

- Prints files incrementally as each directory level is processed.
- Tracks canonicalized paths to avoid loops from symlinks.
- Prints absolute paths for files outside the working directory.

## Contributing

Everyone is welcome to contribute. Open an issue or pull request on GitHub.

## License

MIT
