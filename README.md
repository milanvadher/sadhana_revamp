# Sadhana

Sadhana App and Attendance revamp

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## For IOS

Run
```bash
$ flutter doctor 
```
1. If build fails then
```
cd ios
pod repo update
pod install
```
and install everything that flutter doctor says

### iOS Release
1. Run
` flutter build ios --release`
2. Make sure the signing certificates and provisioning profiles are selected correctly
3. Build iOS app
4. Before final build make sure the correct server URL is configured
5. Archive and Export

Version numbers are taken from Generated.xcconfig, so ensure it has the correct version numbers.
