#!/bin/bash
# Sync script to copy Hebrew Date Widget files to OpenCode repository

SOURCE_DIR="/home/daniel/repos/github/Hebrew-Date-KDE-Widget"
DEST_DIR="/home/daniel/repos/other-networks/opencode/hebrew-date-plasmoid"

echo "Syncing Hebrew Date Widget to OpenCode repository..."
echo "Source: $SOURCE_DIR"
echo "Destination: $DEST_DIR"
echo ""

# Use rsync to sync, excluding git directory
rsync -av --delete \
    --exclude='.git' \
    --exclude='sync-to-opencode.sh' \
    "$SOURCE_DIR/" "$DEST_DIR/"

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Sync completed successfully!"
    echo ""
    echo "Files synchronized:"
    echo "  - package/ (widget source code)"
    echo "  - screenshots/ (screenshots)"
    echo "  - README.md"
    echo "  - CLAUDE.md"
    echo "  - install.sh"
else
    echo ""
    echo "✗ Sync failed"
    exit 1
fi
