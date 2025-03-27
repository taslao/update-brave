# Brave Browser Updater (Unofficial Bash Script)

Hey 👋

This is a humble little Bash script I wrote to update [Brave Browser](https://brave.com/) on my Linux system — specifically Arch Linux — **without using yay or the AUR**.

## What this script does

- Finds the latest Brave release version from GitHub
- Downloads the `.zip` for Linux (`amd64`)
- Unzips it into `~/apps/brave/<version>/`
- Creates or updates symlinks so you can run `brave` or `brave-browser` from anywhere

## Why?

Since I’m on Arch, and while I love pacman, I don’t always want to deal with AUR helpers like yay — especially just to install something I can fetch directly from the source. This script gives me control over how and where Brave is installed, without needing root for most of it.

## Requirements

- `curl`
- `unzip`
- `sudo` (just for the symlink step)

## How to use

```bash
chmod +x update-brave.sh
./update-brave.sh
```

It will:

1. Fetch the latest version tag
2. Download the appropriate ZIP
3. Unzip it into `~/apps/brave/<version>/`
4. Update symlinks in `/usr/local/bin` (you’ll be prompted for sudo)

## Folder structure

```text
~/apps/brave/
├── v1.63.24/
│   ├── brave
│   ├── brave-browser
│   └── ...
└── brave-browser-1.63.24-linux-amd64.zip
```

## Disclaimer

This is totally unofficial — just a script that works for me. Brave might change their release structure someday, and break this. If it helps you too, awesome!
