#!/bin/bash

# Get the absolute path of the directory where the script is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
USER_HOME="/home/$(whoami)"

echo "Configuring WellView in: $DIR"

# 1. Make the Python script executable
chmod +x "$DIR/wellview.py"

# 2. Configure custom magnification values
echo "Please enter the magnification values (e.g., 10x 20x 40x)."
read -p "Press Enter to keep the default values: " input_mags

if [ ! -z "$input_mags" ]; then
    # Format input into a Python list: ["10x", "20x"]
    formatted=$(echo $input_mags | sed 's/[^ ]* /"&", /g;s/[^ ]*$/"&"/')
    sed -i "s/^MAGNIFICATION_LIST = .*/MAGNIFICATION_LIST = [$formatted]/" "$DIR/wellview.py"
    echo "-> Magnification list updated."
fi

# 3. Update the .desktop shortcut with correct paths
DESKTOP_FILE="$DIR/WellView.desktop"
DESKTOP_DESTINATION="$USER_HOME/Desktop/WellView.desktop"

if [ -f "$DESKTOP_FILE" ]; then
    cp "$DESKTOP_FILE" "$DESKTOP_DESTINATION"
    sed -i "s|Icon=.*|Icon=$DIR/icon.png|" "$DESKTOP_DESTINATION"
    sed -i "s|Exec=.*|Exec=lxterminal --working-directory=$DIR -e ./wellview.py|" "$DESKTOP_DESTINATION"
    chmod +x "$DESKTOP_DESTINATION"
    echo "-> Desktop shortcut created."
else
    echo "-> Warning: WellView.desktop not found in current folder."
fi

# 4. System configuration: Enable Quick Exec (bypass 'Execute/Explain' menu)
LIBFM_CONF="$USER_HOME/.config/libfm/libfm.conf"
if [ -f "$LIBFM_CONF" ]; then
    sed -i 's/quick_exec=0/quick_exec=1/' "$LIBFM_CONF"
    echo "-> System Quick Exec enabled."
else
    # Create the config folder if it doesn't exist
    mkdir -p "$(dirname "$LIBFM_CONF")"
    echo "[config]\nquick_exec=1" > "$LIBFM_CONF"
    echo "-> System Quick Exec configured (new file)."
fi

echo "Installation Complete!"
echo "You can now start the program via the Desktop icon."
