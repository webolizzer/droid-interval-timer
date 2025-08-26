# Droid Interval Timer

A persistent, configurable interval timer script for Android using Termux. It provides audible quarter-hour signals with unique voice prompts, designed to run 24/7 in the background without user intervention.

This project was developed to provide a simple, battery-efficient, and highly reliable "Pomodoro-style" timer that automatically starts on boot and survives application crashes.

## Key Features

  - **Precise Timing**: Triggers signals exactly on the quarter-hour marks (`:00`, `:15`, `:30`, `:45`).
  - **Customizable Signals**: Each quarter-hour interval has a unique and easily editable voice prompt.
  - **Configurable Active Window**: Set the start and end hours for when the timer should be active.
  - **Overnight Schedules**: Correctly handles time windows that span across midnight (e.g., 22:00 to 05:00).
  - **Reliable Background Operation**: Uses a `termux-wake-lock` to ensure the script continues running perfectly even when the screen is off.
  - **Fully Persistent**: Automatically starts when the device boots up and restarts itself if the script ever crashes.

## Prerequisites

Before you begin, you must have the following applications installed on your Android device. It is **highly recommended** to install them all from the same source (e.g., F-Droid) to ensure compatibility.

1.  **[Termux](https://f-droid.org/en/packages/com.termux/)**: The main terminal emulator environment.
2.  **[Termux:API](https://f-droid.org/en/packages/com.termux.api/)**: An add-on that exposes Android API functionality to the command line. Required for the wake lock and text-to-speech features.
3.  **[Termux:Boot](https://f-droid.org/en/packages/com.termux.boot/)**: An add-on that allows scripts to be run at boot time.
4.  **`sox` package**: A command-line sound processing tool. The `play` command is used for the beep signals.

## Installation

Follow these steps carefully inside your Termux terminal.

**1. Clone the Repository**

```bash
git clone https://github.com/webolizzer/droid-interval-timer.git
cd droid-interval-timer
```

**2. Install Required Packages**
This command will install the `sox` package needed for the beep sounds.

```bash
pkg update && pkg install sox
```

**3. Make Scripts Executable**
You need to grant permission for the scripts to be run.

```bash
chmod +x timer.sh
chmod +x start-timer.sh
```

**4. Set up Termux:Boot**
This final step copies the launcher script to a special directory where `Termux:Boot` will find and run it when your device starts.

```bash
mkdir -p ~/.termux/boot
ln -s ~/interval-timer/start-timer.sh ~/.termux/boot/start-timer.sh
```

**5. Reboot Your Device**
Reboot your Android device to complete the setup. The timer will start automatically in the background after the device turns on.

## Configuration

All configuration is done by editing the `timer.sh` script.

### Setting the Active Time Window

Open `timer.sh` and find the `CONFIGURATION` section at the top.

```bash
#================================================#
#                 CONFIGURATION                  #
#================================================#
# Set your active time window here.
START_HOUR=11  # The hour the signals should start (e.g., 11 for 11:00)
END_HOUR=3     # The hour the signals should end   (e.g., 4 for 03:59)
```

  - `START_HOUR`: The hour (0-23) you want signals to begin.
  - `END_HOUR`: The hour (0-23) you want signals to end. The script automatically handles overnight schedules where `START_HOUR` is greater than `END_HOUR`.

### Customizing Signals and Voice Prompts

You can change the voice announcement for each quarter-hour by editing the `case` statement within `timer.sh`.

```bash
    case "$MINUTE_NOW" in
      "00")
        play_beeps
        termux-tts-speak "round 1"
        ;;
      "15")
        play_beeps
        termux-tts-speak "round 2"
        ;;
      # ... and so on
```

Simply change the text inside the quotes for any `termux-tts-speak` command to whatever you'd like to hear.

## How It Works

The system uses two scripts for maximum reliability:

  - `timer.sh`: This is the main script containing all the logic. It calculates the time until the next quarter-hour, sleeps, checks if it's within the active window, and plays the appropriate signal. It also handles the wake lock.
  - `start-timer.sh`: This is a simple but powerful "watcher" script. Its only job is to run `timer.sh` in an infinite loop. If `timer.sh` ever crashes, this script waits 5 seconds and automatically restarts it.
  - `Termux:Boot`: This app ensures that the `start-timer.sh` watcher script is launched automatically every time the device reboots.

## Troubleshooting

  - **No sound when the screen is off?**
      - Make sure you have installed the **Termux:API** app. After installing it, run `termux-tts-speak "test"` once in the terminal to ensure permissions are granted.
  - **Script does not start after rebooting?**
      - Make sure you have installed the **Termux:Boot** app and correctly copied `start-timer.sh` to the `~/.termux/boot/` directory.
  - **Error: `play: command not found`?**
      - You need to install the `sox` package. Run `pkg install sox` in your terminal.

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/webolizzer/droid-interval-timer/blob/main/LICENSE) file for details.
