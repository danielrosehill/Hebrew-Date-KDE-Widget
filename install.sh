#!/bin/bash
# Installation script for Hebrew Date KDE Widget

echo "Installing Hebrew Date Widget for KDE Plasma 6..."

# Check if kpackagetool6 exists
if ! command -v kpackagetool6 &> /dev/null; then
    echo "Error: kpackagetool6 not found. Please ensure KDE Plasma 6 is installed."
    exit 1
fi

# Try to install, if already installed, upgrade instead
if kpackagetool6 --type Plasma/Applet --install package 2>&1 | grep -q "already exists"; then
    echo "Widget already installed, upgrading..."
    kpackagetool6 --type Plasma/Applet --upgrade package
else
    kpackagetool6 --type Plasma/Applet --install package
fi

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Installation successful!"
    echo ""
    echo "To use the widget:"
    echo "1. Right-click on your panel or desktop"
    echo "2. Select 'Add Widgets'"
    echo "3. Search for 'Hebrew Date Widget'"
    echo "4. Add it to your system tray or panel"
    echo ""
    echo "You may need to restart plasmashell for the widget to appear:"
    echo "  kquitapp6 plasmashell && kstart plasmashell"
    echo ""
else
    echo "✗ Installation failed"
    exit 1
fi
