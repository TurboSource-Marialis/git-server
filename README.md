# Docker-Based Git Server with Git Daemon

This guide explains how to set up a Docker container running a Git daemon, how to use it to clone and push repositories (including handling submodules), and some troubleshooting tips.

---

## 1. Setup

### **Dockerfile**

Create a file named `Dockerfile` with the following content:

```dockerfile
# Use a lightweight Debian-based image
FROM debian:bullseye-slim

# Install Git
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Create the repository directory and initialize a bare repository
RUN mkdir -p /srv/git && \
    cd /srv/git && \
    git init --bare myproject.git && \
    touch myproject.git/git-daemon-export-ok

# Expose the default Git daemon port
EXPOSE 9418

# Set the working directory
WORKDIR /srv/git

# Run the Git daemon with options
CMD ["git", "daemon", "--reuseaddr", "--base-path=/srv/git", "--export-all", "--enable=receive-pack", "--verbose"]
```

### **docker-compose.yml**

Create a file named `docker-compose.yml` with the following content:

```yaml
version: "3.8"

services:
  gitserver:
    build: .
    ports:
      - "9418:9418"
    restart: always
    volumes:
      - git-data:/srv/git

volumes:
  git-data:
```

---

## 2. Building and Running the Container

### **Build and Start**

Run the following command in the directory containing your `Dockerfile` and `docker-compose.yml`:

```sh
docker-compose up -d --build
```

### **Verify the Container**

Check the running container with:

```sh
docker ps
```

### **View Logs**

Check the logs to ensure Git daemon is running:

```sh
docker-compose logs -f gitserver
```

---

## 3. Using the Git Server

### **Cloning the Repository**

```sh
git clone git://localhost/myproject.git
```

If accessing from another machine:

```sh
git clone git://<host-ip>/myproject.git
```

### **Pushing to the Repository**

```sh
git remote add origin git://localhost/myproject.git
git push origin main
```

---

## 4. Working with Git Submodules

### **Pushing Submodules**

```sh
git submodule update --init --recursive
git push origin main
git submodule foreach --recursive git push origin main
```

### **Automatic Submodule Push Option**

```sh
git config --global push.recurseSubmodules on-demand
```

---

## 5. Troubleshooting

- **Git Daemon Not Found:** Ensure you're using the Debian-based image.
- **Port Not Open:** Check with `nc -zv localhost 9418`.
- **Check Logs:** `docker-compose logs -f gitserver`.

---

## Conclusion

This guide provides a complete setup and usage reference for running a Git server using Docker.

Happy coding!
