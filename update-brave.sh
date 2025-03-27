#!/usr/bin/env bash
#
# bash script to update Brave Browser to latest release on GitHub

set -euo pipefail

# 1. Get the latest release version (tag) from GitHub
LATEST_TAG=$(curl -sI "https://github.com/brave/brave-browser/releases/latest" | \
  grep -i "location:" | sed -E 's#.*tag/(v[0-9.]+).*#\1#')

# Where you want to download and temporarily store the Brave zip file
DOWNLOAD_DIR="$HOME/apps/brave"
INSTALL_DIR="$DOWNLOAD_DIR/$LATEST_TAG"  # Example directory where brave would be installed/unzipped

if [[ -z "$LATEST_TAG" ]]; then
  echo "[ERROR] Could not fetch the latest Brave tag from GitHub."
  exit 1
fi

# Create directories if they don’t exist
mkdir -p "$DOWNLOAD_DIR"
mkdir -p "$INSTALL_DIR"

# Remove the 'v' to get the actual version number
LATEST_VERSION="${LATEST_TAG#v}"

echo "[INFO] Latest Brave version: $LATEST_VERSION"

# 2. Construct the download URL
DOWNLOAD_URL="https://github.com/brave/brave-browser/releases/download/$LATEST_TAG/brave-browser-$LATEST_VERSION-linux-amd64.zip"
ZIP_FILE="$DOWNLOAD_DIR/brave-browser-$LATEST_VERSION-linux-amd64.zip"

echo "[INFO] Constructed download URL: $DOWNLOAD_URL"

# 3. Check if the download URL is valid (HTTP 200)
HTTP_STATUS=$(curl -sI "$DOWNLOAD_URL" | head -n 1 | awk '{print $2}')
if [[ "$HTTP_STATUS" != "200" && "$HTTP_STATUS" != 3?? ]]; then
  echo "[ERROR] Download URL returned status code $HTTP_STATUS (not 200 or 3xx). Aborting."
  exit 1
fi
unset HTTP_STATUS

# 4. Download the file if we do not already have it
if [[ -f "$ZIP_FILE" ]]; then
  echo "[INFO] File $ZIP_FILE already exists. Skipping download."
else
  echo "[INFO] Downloading Brave $LATEST_VERSION ..."
  curl -L -o "$ZIP_FILE" "$DOWNLOAD_URL"
  if [[ $? -ne 0 ]]; then
    echo "[ERROR] Failed to download $DOWNLOAD_URL"
    exit 1
  fi
fi

# 5. Unzip and install/overwrite existing
echo "[INFO] Unzipping $ZIP_FILE to $INSTALL_DIR"
unzip -o "$ZIP_FILE" -d "$INSTALL_DIR" || {
  echo "[ERROR] Failed to unzip $ZIP_FILE"
  exit 1
}

# 6. (Optional) Perform additional steps, e.g. create symlinks, set permissions, etc.
# These dirs will require super-user rights
update_brave_symlinks() {
    local install_dir="$INSTALL_DIR"

    sudo unlink /usr/local/bin/brave 2>/dev/null || true
    sudo unlink /usr/local/bin/brave-browser 2>/dev/null || true

    sudo ln -s "${install_dir}/brave" /usr/local/bin
    sudo ln -s "${install_dir}/brave-browser" /usr/local/bin
}

update_brave_symlinks
echo "[INFO] Update complete. Brave version $LATEST_VERSION installed."