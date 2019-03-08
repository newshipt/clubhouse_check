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

if [[ -z "$REF_FORMAT" ]]; then
	echo "Set the GITHUB_REF_FORMAT env variable."
	exit 1
fi

URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

main() {
	printenv
	cat $GITHUB_EVENT_PATH
	# Get the pull request number.
	NUMBER=$(jq --raw-output .number "$GITHUB_EVENT_PATH")

	echo "running $GITHUB_ACTION for PR #${NUMBER}"

	body=$(curl -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}/pulls/${NUMBER}")
	PR_BODY=$(echo "$body" | jq --raw-output .body)
	echo $PR_BODY

	# check if the branch path has a clubhouse card associated
  if [[ ${PR_BODY} =~ ($BODY_FORMAT)) ]]
  then
		echo "PR body is good."
		exit 0
	elif [[ ${GITHUB_REF} =~ ($REF_FORMAT) ]]
	then
		echo "Branch name is good."
		exit 0
  else
  	echo "Pull request body and branch name are not of the expected format."
    exit 1
  fi
}

main
