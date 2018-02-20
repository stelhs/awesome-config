#!/bin/bash

# $1 - message
# $2 - timeout
MESSAGE=$1
TIMEOUT=$2
echo $TIMEOUT
echo "local naughty = require(\"naughty\") naughty.notify({ text = \"$MESSAGE\", timeout = $TIMEOUT, fg = \"#00ff00\", font = \"Terminus 12\" })" | awesome-client
