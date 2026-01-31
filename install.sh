#!/bin/bash

# Detect the absolute path where the folder is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
USER_DESKTOP="/home/$(whoami)/Desktop"

echo "Configuring WellView in: $DIR"

# 1. Set execution permissions for the script and the icon
chmod +x "$DIR/wellview.py"
chmod 644 "$DIR/icon.png"

# 2. Configure custom magnification values (Optional)
echo "Please enter the magnification values (e.g., 10x 20x 40x)."
read -p "Press Enter to keep the default: " input_mags
if [ ! -z "$input_mags" ]; then
    formatted=$(echo $input_mags | sed 's/[^ ]* /"&", /g;s/[^ ]*$/"&"/')
    sed -i "s/^MAGNIFICATION_LIST = .*/MAGNIFICATION_LIST = [$formatted]/" "$DIR/wellview.py"
    echo "-> Magnification updated."
fi

# 3. Create the Desktop shortcut
DESKTOP_FILE="$DIR/WellView.desktop"
FINAL_DESKTOP="$USER_DESKTOP/WellView.desktop"

if [ -f "$DESKTOP_FILE" ]; then
    tr -d '\r' < "$DESKTOP_FILE" > "$FINAL_DESKTOP"
    
    # Replace the PLACEHOLDER with the actual path
    sed -i "s|PATH_HERE|$DIR|g" "$FINAL_DESKTOP"
    
    # Ensure the shortcut is executable
    chmod +x "$FINAL_DESKTOP"
    echo "-> Desktop shortcut created."
else
    echo "-> ERROR: WellView.desktop not found in the current folder!"
    exit 1
fi

# 4. Enable Quick Exec in system config
LIBFM_CONF="/home/$(whoami)/.config/libfm/libfm.conf"
if [ -f "$LIBFM_CONF" ]; then
    sed -i 's/quick_exec=0/quick_exec=1/' "$LIBFM_CONF"
else
    mkdir -p "$(dirname "$LIBFM_CONF")"
    echo -e "[config]\nquick_exec=1" > "$LIBFM_CONF"
fi

# 5. Refresh the system desktop manager to apply changes
pcmanfm --reconfigure > /dev/null 2>&1
pcmanfm --desktop --reconfigure > /dev/null 2>&1
touch "$FINAL_DESKTOP"

echo "Installation Complete!"
echo "If the icon is still not visible, please reboot your Raspberry Pi."
