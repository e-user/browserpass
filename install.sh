#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
HOST_NAME=com.dannyvankooten.gopass

# Find target dir: see https://developer.chrome.com/extensions/nativeMessaging#native-messaging-host-location
if [ $(uname -s) == 'Darwin' ]; then
  if [ "$(whoami)" == "root" ]; then
    TARGET_DIR="/Library/Google/Chrome/NativeMessagingHosts"
  else
    TARGET_DIR="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
  fi
else
  if [ "$(whoami)" == "root" ]; then
    TARGET_DIR="/etc/opt/chrome/native-messaging-hosts"
  else
    TARGET_DIR="$HOME/.config/google-chrome/NativeMessagingHosts"
  fi
fi

# Create target dir
mkdir -p "$TARGET_DIR"

# Copy manifest file to target dir
cp "$DIR/$HOST_NAME.json" "$TARGET_DIR"

# Update host path in the manifest.
HOST_PATH=$DIR/gopass
ESCAPED_HOST_PATH=${HOST_PATH////\\/}
sed -i -e "s/%%replace%%/$ESCAPED_HOST_PATH/" "$TARGET_DIR/$HOST_NAME.json"

# Set permissions for the manifest so that all users can read it.
chmod o+r "$TARGET_DIR/$HOST_NAME.json"

echo Native messaging host $HOST_NAME has been installed.
