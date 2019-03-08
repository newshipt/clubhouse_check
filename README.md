# Clubhouse Checker

This GitHub Action is used to check a pull request's body, ref, and commit messages to verify if a clubhouse card has been linked. If a clubhouse card is not found, this check throws a failure on the PR.

To add this check to your repository, just add the code below to your `main.workflow` file in your `.github` folder.

```
workflow "Check branch/comment/body format" {
  resolves = ["Clubhouse Checker"]
  on = "pull_request"
}

action "Clubhouse Checker" {
  uses = "newshipt/clubhouse_check@master"
  secrets = ["GITHUB_TOKEN"]
}
```

### Expected formats:
BRANCH REF:  */ch***/*

COMMIT MESSAGE: [ch***]

DESCRIPTION: [ch***]
