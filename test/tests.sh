#!/bin/bash

# Get the absolute path of the current directory
current_dir=$(cd "$(dirname "$0")" && pwd)
outputs=""
# Run all the tests in the test directory, excluding 'tests.rb'
for file in "$current_dir"/*.rb; do
  if [[ "$file" != "$current_dir/test/tests.rb" ]]; then
    outputs+="$(ruby "$file" --verbose | tail -n 1)\n"
  fi
done

echo -e "$outputs"
