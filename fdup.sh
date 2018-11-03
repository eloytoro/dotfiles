set -e
path=$1
shift 1
while true; do
  cmd="fd"
  if [ -n "$prev" ]; then
    cmd="$cmd -E ${prev//$path/}"
  fi
  cmd="$cmd --type f '' $path $@"
  eval $cmd
  if [ $path == '.' ]; then
    break;
  fi
  prev=$path
  path=$(grealpath --relative-to $PWD $path/..)
done
