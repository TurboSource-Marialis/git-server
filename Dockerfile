FROM debian:bullseye-slim

# Install git + nginx + fcgiwrap
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git nginx fcgiwrap spawn-fcgi && \
    rm -rf /var/lib/apt/lists/*

# Create bare repo
RUN mkdir -p /srv/git && \
    cd /srv/git && \
    git init --bare myproject.git && \
    touch myproject.git/git-daemon-export-ok

# Add self-signed cerrificate
RUN apt-get update && apt-get install -y openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -newkey rsa:2048 -nodes \
        -keyout /etc/nginx/ssl/git.key \
        -x509 -days 365 \
        -out /etc/nginx/ssl/git.crt \
        -subj "/CN=localhost"

# allow git-http-backend to accept pushes
RUN git config --system http.receivepack true

# Put nginx config in place
COPY nginx.conf /etc/nginx/sites-enabled/default

# Entrypoint will start fcgiwrap + nginx
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /srv/git
EXPOSE 80
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

