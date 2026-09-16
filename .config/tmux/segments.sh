#!/usr/bin/env bash

set -o pipefail

directory() {
  local cwd="$1"

  if [ "$cwd" = "$HOME" ]; then
    echo '~'
  else
    basename "$cwd"
  fi
}

cpu() {
  local cpus_line
  local cpu_idle

  cpus_line=$(top -l 2 -s 1 -n 0 | awk '/CPU usage:/ { line = $0 } END { print line }')
  cpus_line="${cpus_line//CPU usage: /}"
  cpu_idle=$(echo "$cpus_line" | awk '{print $5}')
  cpu_idle="${cpu_idle//%/}"
  echo "$cpu_idle" | awk '{printf "%.0f%%", 100 - $1}'
}

memory() {
  local stats
  local bytes_per_page
  local free_pages
  local external_pages
  local mem_used_bytes

  stats=$(vm_stat | tr '\n' ' ')

  bytes_per_page=${stats#*page size of }
  bytes_per_page=${bytes_per_page%% *}

  free_pages=$(echo "${stats#*Pages free: }" | awk '{print $1}')
  external_pages=$(echo "${stats#*File-backed pages: }" | awk '{print $1}')

  mem_used_bytes=$(echo "( $bytes_per_page * ( $free_pages + $external_pages ) )" | bc -l)
  mem_total_bytes=$(sysctl -n hw.memsize)

  echo "( 1 - ( $mem_used_bytes / $mem_total_bytes ) ) * 100" | bc -l | awk '{printf "%.0f%%", $1}'
}

battery() {
  pmset -g batt | grep -o '[0-9]\{1,\}%' | tr -d '%' | awk '{print $1"%"}'
}

case "$1" in
directory | cpu | memory | battery)
  "$1" "$2"
  ;;
*)
  exit 1
  ;;
esac
