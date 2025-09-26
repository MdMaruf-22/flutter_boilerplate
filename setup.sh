#!/bin/bash

# Exit if any command fails
set -e

echo "🚀 Flutter Boilerplate Setup Script"

# Ask for project name
read -p "Enter your project name (e.g. my_cool_app): " APP_NAME
read -p "Enter client name (e.g. clientname): " CLIENT_NAME

# Compose bundle id
BUNDLE_ID="com.${CLIENT_NAME}.${APP_NAME}"

# Replace placeholders in pubspec.yaml and app.dart
echo "🔧 Updating project name..."
sed -i "s/__APP_NAME__/$APP_NAME/g" pubspec.yaml
sed -i "s/__APP_NAME__/$APP_NAME/g" lib/app.dart

echo "🔧 Updating Android package name..."
# Update Android (Gradle + Manifest + Kotlin MainActivity path)
sed -i "s/com.example.flutter_boilerplate/$BUNDLE_ID/g" android/app/build.gradle
sed -i "s/com.example.flutter_boilerplate/$BUNDLE_ID/g" android/app/src/main/AndroidManifest.xml
sed -i "s/com.example.flutter_boilerplate/$BUNDLE_ID/g" android/app/src/debug/AndroidManifest.xml
sed -i "s/com.example.flutter_boilerplate/$BUNDLE_ID/g" android/app/src/profile/AndroidManifest.xml

# Rename Kotlin package folder (MainActivity.kt path)
OLD_PACKAGE_PATH="android/app/src/main/kotlin/com/example/flutter_boilerplate"
NEW_PACKAGE_PATH="android/app/src/main/kotlin/com/${CLIENT_NAME}/${APP_NAME}"
mkdir -p $NEW_PACKAGE_PATH
mv $OLD_PACKAGE_PATH/MainActivity.kt $NEW_PACKAGE_PATH/
rm -rf android/app/src/main/kotlin/com/example

echo "🔧 Updating iOS bundle identifier..."
# Update iOS bundle identifier in Xcode project
sed -i "" "s/com.example.flutterBoilerplate/$BUNDLE_ID/g" ios/Runner.xcodeproj/project.pbxproj
sed -i "" "s/com.example.flutterBoilerplate/$BUNDLE_ID/g" ios/Runner/Info.plist

echo "📦 Running flutter pub get..."
flutter pub get

echo "✅ Setup complete!"
echo "   App name: $APP_NAME"
echo "   Bundle ID: $BUNDLE_ID"
echo "You can now run: flutter run"
