# Screenshots Guide for App Stores

## Overview
This guide explains how to create screenshots for Secret Santa Generator for both Google Play Store and Apple App Store.

## Screenshot Requirements

### Google Play Store

#### Required Sizes
- **Phone**: At least 2 screenshots (max 8)
  - Minimum: 320px height
  - Maximum: 3840px height
  - Aspect ratio: 16:9 or 9:16
- **Tablet (7-inch)**: Optional
  - Minimum: 600px height
  - Aspect ratio: 9:16 or 16:9
- **Tablet (10-inch)**: Optional
  - Minimum: 600px height
  - Aspect ratio: 9:16 or 16:9

#### Format
- PNG or JPEG
- 24-bit color
- No transparency
- No borders or frames

### Apple App Store

#### Required Sizes (iPhone)
- **6.7" Display (iPhone 14 Pro Max, etc.)**: 1290 x 2796 pixels
- **6.5" Display (iPhone 11 Pro Max, etc.)**: 1242 x 2688 pixels
- **5.5" Display (iPhone 8 Plus, etc.)**: 1242 x 2208 pixels

#### Optional Sizes
- **iPad Pro 12.9"**: 2048 x 2732 pixels
- **iPad Pro 11"**: 1668 x 2388 pixels
- **iPad**: 1536 x 2048 pixels

#### Format
- PNG or JPEG
- RGB color space
- No transparency
- No borders or frames

## Screenshots to Capture

### 1. Events Screen (Home)
- Shows list of events
- Demonstrates multiple events management
- Highlights current event selection

### 2. Participants Screen
- Shows list of participants
- Demonstrates add participant form
- Shows validation

### 3. Matching Screen
- Shows "Generate Matches" button
- Displays generated matches
- Shows re-shuffle option

### 4. QR Code Display
- Shows QR code for a participant
- Demonstrates share options
- Shows festive UI

### 5. Reveal Screen
- Shows the reveal animation
- Displays confetti effect
- Shows match result

### 6. Reveal History
- Shows list of past reveals
- Demonstrates tracking feature

### 7. Settings Screen
- Shows dark mode toggle
- Shows app information

## How to Capture Screenshots

### Using Flutter

1. **Run app in release mode:**
```bash
flutter run --release
```

2. **Use device screenshot:**
   - Android: Power + Volume Down
   - iOS: Power + Home (or Power + Volume Up on newer devices)

3. **Or use Flutter screenshot command:**
```bash
flutter screenshot
```

### Using Emulator/Simulator

#### Android Emulator
1. Open Android Studio
2. Run app on emulator
3. Use emulator's screenshot button
4. Or use: `adb shell screencap -p /sdcard/screenshot.png`

#### iOS Simulator
1. Open Xcode Simulator
2. Run app
3. Use: Device > Screenshot
4. Or use: `xcrun simctl io booted screenshot screenshot.png`

## Editing Screenshots

### Recommended Tools
- **Figma** (free, web-based)
- **Photoshop** (professional)
- **GIMP** (free, open-source)
- **Canva** (easy to use)

### Editing Tips
1. **Add device frames** (optional but recommended)
2. **Add captions** explaining features
3. **Highlight key features** with arrows or annotations
4. **Maintain consistency** in style across all screenshots
5. **Use festive colors** matching app theme

## Screenshot Best Practices

### Content
- Show real app content (not placeholders)
- Demonstrate key features clearly
- Use actual user data examples
- Show different states (loading, success, error)

### Design
- Keep text readable
- Use high contrast
- Avoid cluttered screens
- Show app's best features first

### Legal
- Use real or realistic data
- Ensure no personal information is visible
- Get permission for any user photos used
- Follow platform guidelines

## Organizing Screenshots

### Folder Structure
```
screenshots/
├── android/
│   ├── phone/
│   │   ├── 1-events-screen.png
│   │   ├── 2-participants-screen.png
│   │   ├── 3-matching-screen.png
│   │   ├── 4-qr-display.png
│   │   ├── 5-reveal-screen.png
│   │   └── 6-settings-screen.png
│   └── tablet/
│       └── (optional tablet screenshots)
└── ios/
    ├── iphone/
    │   ├── 6.7-inch/
    │   │   └── (screenshots for 6.7" display)
    │   └── 6.5-inch/
    │       └── (screenshots for 6.5" display)
    └── ipad/
        └── (optional iPad screenshots)
```

## Automation Script

### Using Flutter Screenshot Package

1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  screenshots: ^3.0.0
```

2. Create `screenshots.yaml`:
```yaml
devices:
  - iPhone 14 Pro Max
  - Pixel 7

screenshots:
  - name: events_screen
    device: iPhone 14 Pro Max
    locale: en_US
    # Navigate to events screen
```

3. Run:
```bash
flutter pub get
flutter pub run screenshots
```

## Testing Screenshots

Before submitting:
1. **Check dimensions** match requirements
2. **Verify quality** - no blur or compression artifacts
3. **Test on different devices** - ensure readability
4. **Review content** - no sensitive information
5. **Check file sizes** - optimize if too large

## Uploading to Stores

### Google Play Console
1. Go to Store presence > Main store listing
2. Upload screenshots in order
3. Add captions (optional but recommended)
4. Preview before publishing

### App Store Connect
1. Go to App Store > App Information
2. Upload screenshots for each device size
3. Add captions
4. Preview on different devices

## Resources

- [Google Play Screenshot Guidelines](https://support.google.com/googleplay/android-developer/answer/9866151)
- [Apple App Store Screenshot Guidelines](https://developer.apple.com/app-store/product-page/)
- [Flutter Screenshots Package](https://pub.dev/packages/screenshots)
- [Device Frame Generator](https://deviceframes.com/)

## Next Steps

After creating screenshots:
1. Review all screenshots for quality
2. Organize in proper folders
3. Add captions/descriptions
4. Upload to respective app stores
5. Preview in store listings

