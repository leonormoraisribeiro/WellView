# Well Viewer
Python script developed in collaboration with **i3S – Instituto de Investigação e Inovação em Saúde** (Porto, Portugal; [www.i3s.up.pt](https://www.i3s.up.pt)).
Creates a Tkinter-based graphical user interface for capturing and automatically anotating images of microplate wells using a *Raspberry Pi 4B SBC* and a *Raspberry Pi High Quality (HQ) C(S)-mount camera* on a trinocular stereo microscope.


It allows users to:
- Record the image of a microplate well (with well position, timestamp and magnification) by clicking on the corresponding position on a schematic representation of the microplate.
- Log selected wells with timestamps and magnification levels.
- Maintain a history of selected wells and saved files.
- See a live preview from the Raspberry Pi camera.

The program starts from a main menu and opens a secondary window to view and interact with the microplate.

## Features
- **One-Click Launch:** Includes a desktop shortcut for easy access.
- **Automated Setup:** A dedicated installation script handles permissions, system configurations, and shortcut creation.
- **Customizable Magnification:** Magnification levels can be tailored during installation to match your specific microscope.
- Supports **96-well**, **48-well** and **24-well** plates
- Graphical selection of wells
- Selectable magnification level (10x, 20x, 30x, 40x, 50x, 63x for our Nikon SMZ800 with 10x eyepieces)
- **Multiple layouts per well:**
  - 96-well: single, 2H, 2V, 3H, 3V, 3L  
  - 48-well: single, 2H, 3H  
  - 24-well: single, 4-Clover, 4-Staggered
- **Raspberry Pi Camera integration** for image capture
- Preview mode for live camera feed before capture
- History log of selected wells and saved files

## Installation
1. **Update the System**

   Open a terminal on your Raspberry Pi and run:
    ```bash
   sudo apt update && sudo apt upgrade -y
   
2. **Install Dependencies**

   The required libraries can be installed by running:
   ```bash
   sudo apt install -y python3-tk python3-opencv python3-pil.imagetk

3. **Clone the Repository**

   If git is not installed, first install it with:
   ```bash
   sudo apt install -y git
   ```

   Then, clone this repository:
   ```bash
   git clone https://github.com/leonormoraisribeiro/WellView
   ```

   Change the directory:
   ```bash
   cd WellView
   ```

4. **Run the Automated Installer**

   The installer will set up the desktop shortcut, fix system execution permissions, and configure your microscope's magnification levels.

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

   _Note:_ During installation, you can press Enter to keep the default magnification levels (10x-63x) or type your own (e.g., 5x 10x 20x).
      
6. **Run the Script or click on the desktop icon:**
   ```bash
   python3 wellview.py

## Usage
1. Launch: Double-click the WellView icon on your Desktop.
2. Enter the *User Name* and *Microplate ID*.
3. Select the *Microplate Type* (24/48/96 wells).
4. Select the Samples per well / layout
   (automatically filtered according to the chosen plate).
5. Select the *Magnification* (can be changed on the fly in the secondary interface).

   The Microplate ID can also be edited directly in the well selection interface.
6. Click *Start* to open the well selection interface.
7. Click any well to:
   - identify its position,
   - select the sub-sample (if layout > 1),
   - annotate the microplate image,
   - capture an image from the Raspberry Pi camera.
8. Click *Start Preview* to open a live preview from the Raspberry Pi camera.
9. Click *Close Preview* to close the live preview from the Raspberry Pi camera.
10. Click *Back* to return to the primary menu (and change the *Microplate ID*).
11. Click *Finish* to exit the program.

## File Storage
Images are automatically saved under:
```
~/Pictures/{User}/{Microplate ID}/
```
Each file is saved with timestamp, well ID and magnification.

(Sub-sample identifiers such as L, R, TL, BR, etc. are included when layouts contain multiple samples.)

## Dependencies
Pre-installed with Python:
- Tkinter 
- Bisect 
- datetime
- os
- subprocess

Requires installation on Rasberry Pi:
- OpenCV (cv2)
- Pillow (PIL)

## Notes
- Ensure rpicam-still (or libcamera-still) is installed for image capture.
- The microplate grid is calibrated using pixel coordinates for precise well detection.

## License
This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

This means that:
- You are free to **use**, **modify**, and **redistribute** this software.
- Any distributed modified version must also be released under the **same GPL license**.
- The full license text is available in the [LICENSE](LICENSE) file.

For more details, see the official GNU documentation:  
https://www.gnu.org/licenses/gpl-3.0.en.html


