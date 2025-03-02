FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y git

# Create the repository directory and initialize a bare repository.
RUN mkdir -p /srv/git && \
    cd /srv/git && \
    git init --bare myproject.git && \
    touch myproject.git/git-daemon-export-ok

EXPOSE 9418
WORKDIR /srv/git

CMD ["git", "daemon", "--reuseaddr", "--base-path=/srv/git", "--export-all", "--enable=receive-pack", "--verbose"]

