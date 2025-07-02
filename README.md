   _____                                               
  /     \ _____    ____ _____     ____   ___________ 
 /  \ /  \\__  \  /    \\__  \   / ___\_/ __ \_  __ \
/    Y    \/ __ \|   |  \/ __ \_/ /_/  >  ___/|  | \/
\____|__  (____  /___|  (____  /\___  / \___  >__|   
        \/     \/     \/     \/_____/      \/       
                   Manager - Powered by eThanJohnson99
```

# Database Dev Manager

A unified, interactive shell tool for managing local development databases (MongoDB, MySQL, PostgreSQL, Redis) with Docker Compose.

## Features
- One-click start/stop/restart for any or all database containers
- Interactive menu for database selection
- Enter container shell or view logs easily
- Clean up all containers, volumes, and networks with one command
- Per-database environment variable management via `dev.env`

## Quick Start

1. **Clone this repo**

2. **Make the script executable**
   ```sh
   chmod +x dev_db_lanuch.sh
   ```

3. **Run the manager**
   ```sh
   ./dev_db_lanuch.sh
   ```

4. **Follow the interactive menu** to start, stop, restart, enter, log, or clean up your databases.

## Directory Structure
```
databases/
  mongodb/
    docker-compose.yml
    mongod.conf
  mysql/
    docker-compose.yml
    my.cnf
  postgres/
    docker-compose.yml
    postgresql.conf
  redis/
    docker-compose.yml
    redis.conf
  dev_db_lanuch.sh
  README.md
```

## Environment Variables
- All sensitive credentials are managed in each database's `dev.env` file.
- Compose files use `env_file: - dev.env` to inject variables.
- **Do not commit real secrets to version control!**

---

> Powered by eThanJohnson99 | MIT License 