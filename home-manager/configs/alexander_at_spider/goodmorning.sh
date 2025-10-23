#!/usr/bin/env bash

# This script checks if 'gcalcli calw' has been run today.
# If not, it runs it and records the timestamp.

# Define the path for the timestamp file
TIMESTAMP_FILE="$HOME/.config/gcalcli/gcalcli_last_run.txt"

# Get the current date in YYYY-MM-DD format
CURRENT_DATE=$(date +%F)

# Variable to store the last run date
LAST_RUN_DATE=""

# Check if the timestamp file exists and read it
if [ -f "$TIMESTAMP_FILE" ]; then
    LAST_RUN_DATE=$(cat "$TIMESTAMP_FILE")
fi

# Compare current date with last run date
if [ "$CURRENT_DATE" != "$LAST_RUN_DATE" ]; then
    # If dates are different (or file didn't exist),
    # update the timestamp file *first* to prevent race conditions
    # if you open multiple terminals at once.
    echo "$CURRENT_DATE" > "$TIMESTAMP_FILE"

    cowsay -w "Godmorgen!"
    
    # Now, run the command.
    # We check if it exists first.
    if command -v gcalcli >/dev/null 2>&1; then
        echo "Running daily 'gcalcli calw'..."
        gcalcli calw
    else
        # If gcalcli isn't found, print a message
        echo "check_gcalcli: 'gcalcli' command not found in your PATH."
    fi
fi
