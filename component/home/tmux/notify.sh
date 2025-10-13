#!/usr/bin/env sh

SESSION_ID="$1"
WINDOW_ID="$2"
WINDOW_NAME="$3"
WINDOW_ACTIVE="$4"

if [ "$WINDOW_ACTIVE" = "0" ]; then
	command -v notify-send && notify-send -i dialog-information -a tmux "Finish Process: [${SESSION_ID}:${WINDOW_ID}] to ${WINDOW_NAME}"
fi

