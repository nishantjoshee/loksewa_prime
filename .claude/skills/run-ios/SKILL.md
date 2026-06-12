---
description: Run Loksewa Prime on iOS simulator. Boots the simulator if needed, launches the app with hot reload, and opens Dart DevTools. Use when asked to run the app, start the app, launch on iOS, or test on simulator.
argument-hint: "[device-id]"
---

## Run Loksewa Prime on iOS Simulator

### 1. Find an available device

!`xcrun simctl list devices available | grep -E "iPhone [0-9]+" | head -5`

### 2. Boot the simulator (if not running)

Check if Simulator is already open. If not, open it:
```
open -a Simulator
```

Wait 5 seconds for the simulator to boot. Then check boot status:
```
xcrun simctl list devices | grep Booted
```

If no device is booted, boot a specific one (use the first available iPhone from step 1):
```
xcrun simctl boot <device-udid>
```

### 3. Run the app

```
cd ${CLAUDE_PROJECT_DIR} && flutter run -d <booted-device-id>
```

### 4. Open DevTools (optional)

In a separate terminal or background:
```
dart devtools
```
Copy the URL shown and tell the user to open it in their browser.

### Notes
- If `flutter run` asks to select a device, list them and pick the booted iOS simulator
- Hot reload: tell the user to press `r` in the terminal where flutter run is active
- Hot restart: press `R`
- Quit: press `q`
- If the app fails to build, run `flutter analyze` to find errors
