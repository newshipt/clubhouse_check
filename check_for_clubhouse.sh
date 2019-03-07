#!/bin/bash
set -e
set -o pipefail

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
	echo "Set the GITHUB_REPOSITORY env variable."
	exit 1
fi

main() {
  echo ${GITHUB_PR_SOURCE_BRANCH}
  echo ${GITHUB_PR_BODY}
  if [[ ${GITHUB_PR_SOURCE_BRANCH} =~ (/ch*(.+)/*)([^,]*) ]]
  then
  	echo "Branch name is good."
  elif [[ ${GITHUB_PR_BODY} =~ (\[ch*(.+)\])([^,]*) ]]
  then
  	echo "PR body is good."
  else
  	echo "yo dawg, where da clubhouse card at?"
    exit 1
  fi
}

main
