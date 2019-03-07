FROM debian:9.5-slim

LABEL "com.github.actions.name"="Clubhouse Checker"
LABEL "com.github.actions.description"="Throws a check failure if the PR wasn't created with the clubhouse helper or doesn't have a clubhouse card in the description"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="yellow"

ADD check_for_clubhouse.sh /check_for_clubhouse.sh
ENTRYPOINT ["./check_for_clubhouse.sh"]
