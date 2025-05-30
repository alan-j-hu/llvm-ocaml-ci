#!/bin/bash

set -e
set -x

version=${1/%.?.?/}
mode=$2
config_file="conf-llvm-${mode}.config"

if hash brew 2>/dev/null; then
    brew_llvm_config="$(brew --cellar)"/llvm*/${version}*/bin/llvm-config
fi

shopt -s nullglob
for llvm_config in llvm-config-$version llvm-config${version} llvm-config-${version}.0 llvm-config${version}0 llvm-config-mp-$version llvm-config-mp-${version}.0 llvm${version}-config llvm-config-${version}-32 llvm-config-${version}-64 llvm-config $brew_llvm_config; do
    llvm_version="`$llvm_config --version`" || true
    case $llvm_version in
    $version*)
        if ! $llvm_config --link-${mode} --libs; then
            echo "Note: '$llvm_config' matches version '$version', but does not support link mode '$mode'."
            continue
        fi
        echo "config: \"$llvm_config\"" >> $config_file
        echo "version: \"$llvm_version\"" >> $config_file
        exit 0;;
    *)
        echo "Note: '$llvm_config' doesn't match the required version. Got '$llvm_version' but required '$version'."
        continue;;
    esac
done

echo "Error: LLVM ${version} is not installed."
exit 1

