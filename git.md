## Only remote branch is `main` or `master`

Change `.git/config/` from

```
[remote "origin"]
    url = git@gitlab.com:organization/<team>/<repo>.git
    fetch = +ref/heads/main:refs/remotes/origin/main
```

to

```
[remote "origin"]
    url = git@gitlab.com:organization/<team>/<repo>.git
    fetch = +ref/heads/*:refs/remotes/origin/*
```