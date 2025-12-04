#!/bin/bash

# Exit if any command fails
set -e

echo "🚀 Flutter Boilerplate Setup Script"

# CLI / env parsing: support non-interactive automation
# Usage examples:
#  ./setup.sh --app my_app --client clientname --yes
#  APP_NAME=my_app CLIENT_NAME=clientname ./setup.sh
AUTO_RENAME=false
NONINTERACTIVE=false
while [[ "$#" -gt 0 ]]; do
	case "$1" in
		-a|--app)
			APP_NAME="$2"; shift 2;;
		-c|--client)
			CLIENT_NAME="$2"; shift 2;;
		-y|--yes|--rename)
			AUTO_RENAME=true; shift;;
		--non-interactive)
			NONINTERACTIVE=true; shift;;
		--help|-h)
			echo "Usage: $0 [--app NAME] [--client NAME] [--yes]"; exit 0;;
		*) break;;
	esac
done

# Fallback to env vars if provided
APP_NAME="${APP_NAME:-$APP_NAME}"
CLIENT_NAME="${CLIENT_NAME:-$CLIENT_NAME}"

# Prompt if values still missing (unless non-interactive)
if [[ -z "$APP_NAME" ]]; then
	if [[ "$NONINTERACTIVE" == true ]]; then
		echo "❌ APP name missing in non-interactive mode."; exit 1
	fi
	read -p "Enter your project name (e.g. my_cool_app): " APP_NAME
fi
if [[ -z "$CLIENT_NAME" ]]; then
	if [[ "$NONINTERACTIVE" == true ]]; then
		echo "❌ CLIENT name missing in non-interactive mode."; exit 1
	fi
	read -p "Enter client name (e.g. clientname): " CLIENT_NAME
fi

# If requested, permanently rename misspelled pubsec.yaml -> pubspec.yaml
if [[ "$AUTO_RENAME" == true && -f "pubsec.yaml" && ! -f "pubspec.yaml" ]]; then
	echo "ℹ️  Renaming pubsec.yaml -> pubspec.yaml (permanent)"
	mv pubsec.yaml pubspec.yaml
fi

# Determine portable sed -i args for macOS (Darwin) vs Linux
if [[ "$(uname)" == "Darwin" ]]; then
	SED_INLINE=("-i" "")
else
	SED_INLINE=("-i")
fi

# Compose bundle id
BUNDLE_ID="com.${CLIENT_NAME}.${APP_NAME}"

# Replace placeholders in pubspec.yaml and app.dart
echo "🔧 Updating project name..."
# Support both correct and misspelled pubspec filename
PUBSPEC_FILE="pubspec.yaml"
if [[ ! -f "$PUBSPEC_FILE" && -f "pubsec.yaml" ]]; then
	PUBSPEC_FILE="pubsec.yaml"
	echo "⚠️  Warning: 'pubspec.yaml' not found, using 'pubsec.yaml' instead."
fi

sed "${SED_INLINE[@]}" "s/__APP_NAME__/$APP_NAME/g" "$PUBSPEC_FILE"
sed "${SED_INLINE[@]}" "s/__APP_NAME__/$APP_NAME/g" lib/app.dart

echo "🔧 Updating Android package name..."
# If Flutter platform folders are missing, create a Flutter project in-place
if [[ ! -d "android" || ! -d "ios" ]]; then
	echo "ℹ️  Android or iOS folders missing — creating Flutter project now..."
	flutter create --org "com.${CLIENT_NAME}" --project-name "$APP_NAME" . || {
		echo "❌ flutter create failed; aborting."
		exit 1
	}
fi

if [[ -d "android/app" ]]; then
	# Update Android (Gradle + Manifest + Kotlin MainActivity path)
	# Update Android Gradle file (support both Groovy and Kotlin DSL)
	for gradle_file in android/app/build.gradle android/app/build.gradle.kts; do
		if [[ -f "$gradle_file" ]]; then
			sed "${SED_INLINE[@]}" "s/com.example.flutter_boilerplate/$BUNDLE_ID/g" "$gradle_file"
		else
			echo "ℹ️  $gradle_file not found; skipping."
		fi
	done

	for manifest in android/app/src/main/AndroidManifest.xml android/app/src/debug/AndroidManifest.xml android/app/src/profile/AndroidManifest.xml; do
		if [[ -f "$manifest" ]]; then
			sed "${SED_INLINE[@]}" "s/com.example.flutter_boilerplate/$BUNDLE_ID/g" "$manifest"
		else
			echo "ℹ️  $manifest not found; skipping."
		fi
	done

	# Rename Kotlin package folder (MainActivity.kt path) if it exists
	OLD_PACKAGE_PATH="android/app/src/main/kotlin/com/example/flutter_boilerplate"
	NEW_PACKAGE_PATH="android/app/src/main/kotlin/com/${CLIENT_NAME}/${APP_NAME}"
	if [[ -f "$OLD_PACKAGE_PATH/MainActivity.kt" ]]; then
		mkdir -p "$NEW_PACKAGE_PATH"
		mv "$OLD_PACKAGE_PATH/MainActivity.kt" "$NEW_PACKAGE_PATH/"
		rm -rf android/app/src/main/kotlin/com/example
	else
		echo "ℹ️  Android MainActivity not found; skipping Kotlin package move."
	fi
else
	echo "⚠️  Android project files not found; skipping Android package update."
fi

if [[ -d "ios/Runner.xcodeproj" ]]; then
	echo "🔧 Updating iOS bundle identifier..."
	# Update iOS bundle identifier in Xcode project
	sed "${SED_INLINE[@]}" "s/com.example.flutterBoilerplate/$BUNDLE_ID/g" ios/Runner.xcodeproj/project.pbxproj
	sed "${SED_INLINE[@]}" "s/com.example.flutterBoilerplate/$BUNDLE_ID/g" ios/Runner/Info.plist
else
	echo "⚠️  iOS project files not found; skipping iOS bundle update."
fi

# If the real pubspec filename is misspelled, create a temporary pubspec.yaml
TEMP_PUBSPEC=false
if [[ "$PUBSPEC_FILE" != "pubspec.yaml" ]]; then
	cp "$PUBSPEC_FILE" pubspec.yaml
	TEMP_PUBSPEC=true
	echo "ℹ️  Temporarily created pubspec.yaml from $PUBSPEC_FILE for 'flutter pub get'"
fi

echo "📦 Running flutter pub get..."
flutter pub get

# Clean up temporary pubspec if we created one
if [[ "$TEMP_PUBSPEC" == true ]]; then
	rm -f pubspec.yaml
	echo "ℹ️  Removed temporary pubspec.yaml"
fi

echo "✅ Setup complete!"
echo "   App name: $APP_NAME"
echo "   Bundle ID: $BUNDLE_ID"
echo "You can now run: flutter run"
