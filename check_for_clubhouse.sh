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

URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

add_clubhouse_label() {
	echo "Adding labels"
	LABELS=$(cat $GITHUB_EVENT_PATH | jq '.pull_request.labels[.pull_request.labels| length] |= . + { "name": "NEEDS CLUBHOUSE CARD" }' | jq '[ .pull_request.labels[].name ]')
	curl --data "{'labels': '${LABELS}'}" -X PATCH -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}/issues/${NUMBER}"
}

remove_clubhouse_labels(){
	echo "Removing labels"
	LABELS=$(cat $GITHUB_EVENT_PATH | jq '[ .pull_request.labels[].name ]')
	LABELS=${LABELS[@]/'NEEDS CLUBHOUSE CARD'}
	LABELS=${LABELS[@]/'"", '}
	LABELS=${LABELS[@]/', ""'}
	curl --data "{'labels': '${LABELS}'}" -X PATCH -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}/issues/${NUMBER}"
}

main() {
	printenv
	cat $GITHUB_EVENT_PATH

	# Get the pull request number.
	NUMBER=$(jq --raw-output .number "$GITHUB_EVENT_PATH")

	echo "running $GITHUB_ACTION for PR #${NUMBER}"

	body=$(curl -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}/pulls/${NUMBER}")
	PR_BODY=$(echo "$body" | jq --raw-output .body)
	body=$(curl -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}/pulls/${NUMBER}/commits")
	PR_COMMIT_MESSAGES=$(echo "$body" | jq -r .[].commit.message)

	# check if the branch path has a clubhouse card associated
	if [[ ${PR_COMMIT_MESSAGES} =~ (\[ch[0-9](.+)\])([^,]*) ]]
	then
		echo "Commit messages contain a clubhouse card. You may proceed...this time."
		remove_clubhouse_labels
		exit 0
	elif [[ ${GITHUB_REF} =~ (\/ch[0-9](.+)\/*)([^,]*) ]]
	then
		echo "This branch was clearly created using the clubhouse helper."
		remove_clubhouse_labels
		exit 0
	elif [[ ${PR_BODY} =~ (\[ch[0-9](.+)\])([^,]*) ]]
  then
		echo "If I said your PR body looked good, would you hold it against me?"
		remove_clubhouse_labels
		exit 0
  else
  	echo "yo dawg, where da clubhouse card at?"
		add_clubhouse_label
    exit 1
  fi
}

main
