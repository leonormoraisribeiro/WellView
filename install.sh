#!/bin/bash

# Detect the absolute path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
USER_DESKTOP="/home/$(whoami)/Desktop"

echo "Configuring WellView in: $DIR"

# 1. Set execution permissions
chmod +x "$DIR/wellview.py"
chmod 644 "$DIR/icon.png"

# 2. Configure magnification values
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
    sed -i "s|PATH_HERE|$DIR|g" "$FINAL_DESKTOP"
    chmod +x "$FINAL_DESKTOP"
    echo "-> Desktop shortcut created."
else
    echo "-> ERROR: WellView.desktop not found!"
    exit 1
fi

# 4. Enable Quick Exec (Improved logic)
LIBFM_CONF="/home/$(whoami)/.config/libfm/libfm.conf"
mkdir -p "$(dirname "$LIBFM_CONF")"
if [ -f "$LIBFM_CONF" ]; then
    # If the line exists, change it; if not, add it
    if grep -q "quick_exec=" "$LIBFM_CONF"; then
        sed -i 's/quick_exec=.*/quick_exec=1/' "$LIBFM_CONF"
    else
        echo "quick_exec=1" >> "$LIBFM_CONF"
    fi
else
    echo -e "[config]\nquick_exec=1" > "$LIBFM_CONF"
fi
echo "-> System settings updated."

# 5. FORCED REFRESH (The "No-Reboot" Trick)
echo "-> Force-refreshing the Desktop environment..."
# Restart the file manager and desktop process
killall pcmanfm 2>/dev/null
# Give the system a split second to breathe
sleep 1
# Restart the desktop process in the background
pcmanfm --desktop --profile LXDE-pi & 
# Disassociate the process from this terminal session
disown

echo "Installation Complete!"
