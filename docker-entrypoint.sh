#!/bin/sh

set -e

# Output some helpful messaging when invoking `bin/start` (which itself is
# a convenience script for `docker compose up`.
#
# Adding this to work around the mild inconvenience of the `app` container's
# entrypoint generating no output.
#
cat <<-'PROMPT'
🎉 Dev Environment Initialized! 🎉

ℹ️  To use this environment, open a new terminal and run

   bin/exec bash

🕹  Use `ctrl-c` to exit.
PROMPT

# Using `sleep infinity` instead of `tail -f /dev/null`. This may be a 
# performance improvement based on the conversation on a semi-related
# StackOverflow page.
#
# @see https://stackoverflow.com/a/41655546
sleep infinity
