#!/bin/bash
# ssh_split.sh <direction: -h or -v> <pane_pid> <pane_current_path>

direction="$1"
pane_pid="$2"
pane_current_path="$3"

# Function to recursively find the ssh child process
find_ssh_process() {
  local pid="$1"
  local children
  children=$(pgrep -P "$pid" 2>/dev/null)
  for child in $children; do
    if [ -f "/proc/$child/comm" ]; then
      local comm
      comm=$(cat "/proc/$child/comm" 2>/dev/null)
      if [ "$comm" = "ssh" ]; then
        echo "$child"
        return 0
      fi
      # Recurse in case of subshells
      local found
      found=$(find_ssh_process "$child")
      if [ -n "$found" ]; then
        echo "$found"
        return 0
      fi
    fi
  done
  return 1
}

# Check if the pane_pid itself is the ssh process, otherwise find it in children
if [ -f "/proc/$pane_pid/comm" ] && [ "$(cat "/proc/$pane_pid/comm" 2>/dev/null)" = "ssh" ]; then
  ssh_pid="$pane_pid"
else
  ssh_pid=$(find_ssh_process "$pane_pid")
fi


if [ -n "$ssh_pid" ] && [ -f "/proc/$ssh_pid/cmdline" ]; then
  # We found an active SSH process!
  args=()
  while IFS= read -r -d '' arg; do
    args+=("$arg")
  done <"/proc/$ssh_pid/cmdline"

  ssh_args=("${args[@]:1}")

  # Filter out any arguments that look like the old CWD helper command
  filtered_args=()
  for arg in "${ssh_args[@]}"; do
    if [[ "$arg" =~ ^cd\  ]] && [[ "$arg" =~ exec\  ]]; then
      continue
    fi
    filtered_args+=("$arg")
  done
  ssh_args=("${filtered_args[@]}")

  # Find the hostname in the arguments
  host=""
  for arg in "${ssh_args[@]}"; do
    if [[ ! "$arg" =~ ^- ]]; then
      host="$arg"
    fi
  done
  display_host="${host##*@}"

  # Split the window and run ssh. We capture the new pane ID using -P and -F
  new_pane_id=$(tmux split-window -P -F "#{pane_id}" "$direction" ssh "${ssh_args[@]}")

  # Set the pane-specific option on the new pane so the status bar shows the host
  if [ -n "$new_pane_id" ] && [ -n "$display_host" ]; then
    tmux set -p -t "$new_pane_id" @pane_ssh_host "$display_host"
  fi
else
  # No SSH process found, perform standard split in current working directory
  tmux split-window "$direction" -c "$pane_current_path"
fi
