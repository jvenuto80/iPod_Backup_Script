# iPod Music Backup Script

This script copies and organizes music files from an iPod (mounted in disk mode) to your Mac, preserving metadata and folder structure. Tested with iPod Video.

## Features
- Copies MP3, M4A, M4P, and AAC files from your iPod.
- Organizes files by Artist and Album using metadata.
- Renames files to include track number and title.
- Handles duplicate filenames automatically.

## Prerequisites
- **macOS**
- **Homebrew** (for installing exiftool)
- **exiftool**
  - Install via Terminal: `brew install exiftool`
- **iPod in disk mode and mounted**
  - Connect your iPod and enable disk mode (see Apple’s instructions for your model).
  - Ensure it appears in Finder under `/Volumes/IPOD`.

## Usage
1. **Download or save the script** as `rip_ipod.sh`.
2. **Make the script executable**:
   ```sh
   chmod +x rip_ipod.sh
   ```
3. **Run the script**:
   - With default locations:
     ```sh
     ./rip_ipod.sh
     ```
   - Or specify iPod mount and backup destination:
     ```sh
     ./rip_ipod.sh /Volumes/IPOD /Users/yourname/Desktop/iPod_Backup
     ```

## Output
- Music files will be copied to `~/Desktop/iPod_Backup` (or your specified folder), organized by Artist and Album.
- The script prints progress and a summary when done.

## Troubleshooting
- If you see `exiftool missing`, install it with Homebrew.
- If you see `No iPod music dir`, make sure your iPod is in disk mode and mounted.

## License
MIT
