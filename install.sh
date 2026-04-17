#!/bin/bash
# DIR="/usr/share/wallpapers/"  # we use the global wallpaper directory for ours
DIR="$HOME/.local/share/plasma/wallpapers/particlewallpaper"
QML_PATH="./contents/ui"
mkdir -p "$DIR/contents/ui"

cp metadata.json $DIR
mkdir -p $DIR/$QML_PATH
cp InterWall2.qml $DIR/$QML_PATH/main.qml
