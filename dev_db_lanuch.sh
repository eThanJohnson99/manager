#!/bin/bash

cat <<'EOF'
   _____                                             
  /     \ _____    ____ _____     ____   ___________ 
 /  \ /  \\__  \  /    \\__  \   / ___\_/ __ \_  __ \
/    Y    \/ __ \|   |  \/ __ \_/ /_/  >  ___/|  | \/
\____|__  (____  /___|  (____  /\___  / \___  >__|   
        \/     \/     \/     \/_____/      \/       

                  Manager - Powered by eThanJohnson99
EOF

# Database service configuration
SERVICES=("mongodb" "mysql" "postgres" "redis")
SERVICE_NAMES=("MongoDB" "MySQL" "PostgreSQL" "Redis")

# Get script base directory
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

function show_menu() {
  echo ""
  echo "1. Start Database"
  echo "2. Stop Database"
  echo "3. Restart Database"
  echo "4. Show Database Status"
  echo "5. Enter Database Shell"
  echo "6. Show Database Logs"
  echo "7. Terminate Database"
  echo "8. Exit"
  echo ""
}

function select_services() {
  echo "Select database(s) to operate (multiple allowed, space separated, leave blank for all):"
  for i in "${!SERVICE_NAMES[@]}"; do
    echo "$((i+1)). ${SERVICE_NAMES[$i]}"
  done
  read -p "> " selection
  if [[ -z "$selection" ]]; then
    SELECTED=("0" "1" "2" "3")
  else
    SELECTED=()
    for idx in $selection; do
      if [[ $idx =~ ^[1-4]$ ]]; then
        SELECTED+=("$((idx-1))")
      fi
    done
  fi
}

function compose_action() {
  local action=$1
  for idx in "${SELECTED[@]}"; do
    svc=${SERVICES[$idx]}
    echo "${SERVICE_NAMES[$idx]}: $action..."
    (cd "$BASE_DIR/$svc" && docker-compose $action)
  done
}

function enter_shell() {
  select_services
  for idx in "${SELECTED[@]}"; do
    svc=${SERVICES[$idx]}
    cname=$(cd "$BASE_DIR/$svc" && docker-compose ps -q $svc)
    if [[ -n "$cname" ]]; then
      echo "Entering ${SERVICE_NAMES[$idx]} container shell..."
      docker exec -it "$cname" bash || docker exec -it "$cname" sh
    else
      echo "${SERVICE_NAMES[$idx]} is not running."
    fi
  done
}

function show_logs() {
  select_services
  for idx in "${SELECTED[@]}"; do
    svc=${SERVICES[$idx]}
    cname=$(cd "$BASE_DIR/$svc" && docker-compose ps -q $svc)
    if [[ -n "$cname" ]]; then
      echo "Showing logs for ${SERVICE_NAMES[$idx]}... (Press Ctrl+C to exit)"
      docker logs -f "$cname"
    else
      echo "${SERVICE_NAMES[$idx]} is not running."
    fi
  done
}

function release_services() {
  select_services
  for idx in "${SELECTED[@]}"; do
    svc=${SERVICES[$idx]}
    echo "Cleaning up ${SERVICE_NAMES[$idx]} (removing containers, volumes, networks, etc.)..."
    (cd "$BASE_DIR/$svc" && docker-compose down -v --remove-orphans)
  done
  echo "Cleanup complete."
}

while true; do
  show_menu
  read -p "Select an option: " opt
  case $opt in
    1)
      select_services
      compose_action "up -d"
      ;;
    2)
      select_services
      compose_action "down"
      ;;
    3)
      select_services
      compose_action "restart"
      ;;
    4)
      select_services
      for idx in "${SELECTED[@]}"; do
        svc=${SERVICES[$idx]}
        echo "${SERVICE_NAMES[$idx]} status:"
        (cd "$BASE_DIR/$svc" && docker-compose ps)
      done
      ;;
    5)
      enter_shell
      ;;
    6)
      show_logs
      ;;
    7)
      release_services
      ;;
    8)
      echo "Exit."
      exit 0
      ;;
    *)
      echo "Invalid option, please try again."
      ;;
  esac
  echo
done 