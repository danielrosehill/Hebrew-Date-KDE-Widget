#!/bin/bash

# Hebrew Date Widget Build Script
# Creates a plasmoid package from the source

set -e

echo "Building Hebrew Date Widget..."

# Create build directory
mkdir -p build

# Package the plasmoid
cd package
zip -r ../build/hebrewdate.plasmoid .
cd ..

echo "Build complete: build/hebrewdate.plasmoid"
echo ""
echo "To install/update:"
echo "  kpackagetool6 -t Plasma/Applet -u build/hebrewdate.plasmoid"
echo ""
echo "To restart plasmashell:"
echo "  plasmashell --replace &"
