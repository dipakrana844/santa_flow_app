# App Icons Generation Guide

## Overview

This guide explains how to generate app icons for Secret Santa Generator for both Android and iOS platforms.

## Icon Design Requirements

### Design Guidelines

- **Theme**: Secret Santa / Christmas / Gift Exchange
- **Colors**: Red, green, gold (festive colors)
- **Style**: Modern, clean, recognizable at small sizes
- **Elements**: Gift box, Santa hat, or Christmas tree icon
- **Background**: Solid color or subtle gradient

### Recommended Tools

- **Figma** (free, web-based)
- **Adobe Illustrator** (professional)
- **Canva** (easy to use)
- **GIMP** (free, open-source)
- **Sketch** (Mac only)

## Android Icons

### Required Sizes

Android requires icons in multiple densities:

| Density | Size (px) | Folder |
|---------|-----------|--------|
| mdpi | 48x48 | `mipmap-mdpi/ic_launcher.png` |
| hdpi | 72x72 | `mipmap-hdpi/ic_launcher.png` |
| xhdpi | 96x96 | `mipmap-xhdpi/ic_launcher.png` |
| xxhdpi | 144x144 | `mipmap-xxhdpi/ic_launcher.png` |
| xxxhdpi | 192x192 | `mipmap-xxxhdpi/ic_launcher.png` |

### Adaptive Icon (Android 8.0+)

Create adaptive icons with:

- **Foreground**: 108x108dp (safe zone: 72x72dp)
- **Background**: 108x108dp
- **Legacy**: 512x512px

**Files needed:**

- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml`
- Foreground and background images for each density

### Using flutter_launcher_icons Package

1. Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"  # 1024x1024px source image
  adaptive_icon_background: "#FF0000"  # Red background
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"
```

1. Run:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## iOS Icons

### Required Sizes

iOS requires icons in AppIcon.appiconset:

| Size | Scale | Actual Size (px) | Filename |
|------|-------|------------------|----------|
| 20x20 | 2x | 40x40 | <icon-20@2x.png> |
| 20x20 | 3x | 60x60 | <icon-20@3x.png> |
| 29x29 | 2x | 58x58 | <icon-29@2x.png> |
| 29x29 | 3x | 87x87 | <icon-29@3x.png> |
| 40x40 | 2x | 80x80 | <icon-40@2x.png> |
| 40x40 | 3x | 120x120 | <icon-40@3x.png> |
| 60x60 | 2x | 120x120 | <icon-60@2x.png> |
| 60x60 | 3x | 180x180 | <icon-60@3x.png> |
| 1024x1024 | 1x | 1024x1024 | icon-1024.png |

### Location

Place icons in: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Contents.json Structure

The `Contents.json` file defines which icons are needed. Xcode can generate this automatically.

## Quick Start with flutter_launcher_icons

### Step 1: Create Source Icon

1. Design a 1024x1024px icon
2. Save as PNG with transparency
3. Place in `assets/icon/app_icon.png`

### Step 2: Configure pubspec.yaml

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/app_icon.png"
  min_sdk_android: 21
  adaptive_icon_background: "#C41E3A"  # Christmas red
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"
  remove_alpha_ios: true
```

### Step 3: Generate Icons

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## Manual Generation

### Android

1. Create 1024x1024px master icon
2. Use online tool (e.g., <https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html>)
3. Download generated icons
4. Place in respective `mipmap-*` folders

### iOS

1. Create 1024x1024px master icon
2. Use online tool (e.g., <https://www.appicon.co/>)
3. Download AppIcon.appiconset
4. Replace `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## Testing Icons

### Android

```bash
flutter run -d android
```

### iOS

```bash
flutter run -d ios
```

Check that icons appear correctly on:

- Home screen
- App switcher
- Settings screen

## Design Tips

1. **Keep it simple**: Icons should be recognizable at small sizes
2. **Use high contrast**: Ensure visibility on various backgrounds
3. **Test at small sizes**: View at 48x48px to ensure clarity
4. **Follow platform guidelines**:
   - Android: Material Design guidelines
   - iOS: Human Interface Guidelines
5. **Avoid text**: Text becomes unreadable at small sizes
6. **Use consistent branding**: Match app theme and colors

## Resources

- [Android Icon Design Guidelines](https://developer.android.com/guide/practices/ui_guidelines/icon_design)
- [iOS Human Interface Guidelines - Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Material Design Icons](https://fonts.google.com/icons)
- [Flutter Launcher Icons Package](https://pub.dev/packages/flutter_launcher_icons)

## Next Steps

After generating icons:

1. Test on physical devices
2. Verify all sizes display correctly
3. Check adaptive icons on Android 8.0+
4. Update app name in platform configs if needed
