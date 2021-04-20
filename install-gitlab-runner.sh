#!/bin/bash

type -p realpath &>/dev/null ||
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

BASE="$(dirname $(realpath "$0"))"

ansible-playbook -i "$BASE/hosts" install-gitlab-runner.yml
