# Local Docker-Based Git Server

This server uses a local reverse proxy so it can the the remote is drop in replaceable as it serves using `http://localhost` instead of `git://locahost`.

Initialize bare repo

```
docker exec git-server git init --bare /srv/git/<project>.git
```

Add it as your remote

```
git remote add origin http://localhost:5072/<project>.git
```

Push, pull and clone as normal.
