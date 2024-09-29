#!/usr/bin/env bash
set -e

scriptpath=$(realpath -e "$0")
directorypath=$(dirname "$scriptpath")

hooksdirectorypath="$HOME/.pomodoro/hooks"

ln -sf "$directorypath" "$hooksdirectorypath"

echo "script completed successfully!"
