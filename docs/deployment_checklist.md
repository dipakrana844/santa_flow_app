# Deployment Checklist

## Pre-Deployment

### Code Quality
- [ ] All tests passing
- [ ] Code coverage ≥ 80%
- [ ] No lint warnings
- [ ] Code reviewed
- [ ] Performance optimized

### Build Configuration
- [ ] Android build.gradle.kts configured
- [ ] iOS Info.plist configured
- [ ] Version numbers updated
- [ ] Bundle ID/Application ID set
- [ ] Signing keys configured (for release)

### Assets
- [ ] App icons generated for all sizes
- [ ] Splash screen configured
- [ ] Screenshots created
- [ ] App descriptions written
- [ ] Privacy policy created

## Android Deployment

### Build Configuration
- [ ] `minSdk` set to 21 or higher
- [ ] `targetSdk` set to latest
- [ ] ProGuard rules configured
- [ ] Signing config set up
- [ ] Version code incremented

### Permissions
- [ ] Camera permission declared
- [ ] Permission descriptions added
- [ ] Runtime permissions handled

### Testing
- [ ] Tested on Android 5.0+
- [ ] Tested on various screen sizes
- [ ] QR scanning works
- [ ] All features functional
- [ ] Performance acceptable

### Build
- [ ] Release build created
- [ ] AAB file generated
- [ ] Build signed with release key
- [ ] Build tested on device

### Play Store
- [ ] Developer account created
- [ ] App listing created
- [ ] Screenshots uploaded
- [ ] Description added
- [ ] Privacy policy linked
- [ ] Content rating completed
- [ ] App submitted for review

## iOS Deployment

### Build Configuration
- [ ] Bundle identifier set
- [ ] Minimum iOS version set (13.0+)
- [ ] Version numbers updated
- [ ] Code signing configured
- [ ] Provisioning profiles set up

### Permissions
- [ ] Camera usage description added
- [ ] Photo library usage description added
- [ ] Privacy descriptions in Info.plist

### Testing
- [ ] Tested on iOS 13.0+
- [ ] Tested on iPhone and iPad
- [ ] QR scanning works
- [ ] All features functional
- [ ] Performance acceptable

### Build
- [ ] Archive created in Xcode
- [ ] Build signed
- [ ] Build tested on device
- [ ] IPA exported

### App Store
- [ ] Developer account created
- [ ] App listing created
- [ ] Screenshots uploaded
- [ ] Description added
- [ ] Privacy policy linked
- [ ] App submitted for review

## Post-Deployment

### Monitoring
- [ ] Set up crash reporting (optional)
- [ ] Monitor app reviews
- [ ] Track download statistics
- [ ] Monitor performance metrics

### Updates
- [ ] Plan for future updates
- [ ] Document known issues
- [ ] Prepare update roadmap

## Common Issues

### Android
- **Issue**: Build fails with signing error
  - **Solution**: Check key.properties and signing config

- **Issue**: App crashes on older devices
  - **Solution**: Check minSdk and test on target devices

- **Issue**: QR scanner doesn't work
  - **Solution**: Verify camera permission in manifest

### iOS
- **Issue**: Build fails with code signing error
  - **Solution**: Check provisioning profiles and certificates

- **Issue**: App rejected for missing privacy descriptions
  - **Solution**: Add NSCameraUsageDescription to Info.plist

- **Issue**: App crashes on launch
  - **Solution**: Check minimum iOS version and dependencies

## Resources

- [Flutter Deployment Guide](https://docs.flutter.dev/deployment)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Android Release Checklist](https://developer.android.com/studio/publish/preparing)
- [iOS Release Checklist](https://developer.apple.com/app-store/review/)

