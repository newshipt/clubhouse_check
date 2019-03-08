FROM alpine:latest

LABEL "com.github.actions.name"="Clubhouse Checker"
LABEL "com.github.actions.description"="Throws a check failure if the PR wasn't created with the clubhouse helper or doesn't have a clubhouse card in the description"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="yellow"

RUN apk add --no-cache \
	bash \
	ca-certificates \
	coreutils \
	curl \
	jq

COPY check_for_clubhouse.sh /usr/local/bin/check_for_clubhouse
CMD ["check_for_clubhouse"]
