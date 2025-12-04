Write-Host "🚀 Flutter Boilerplate Setup Script (Windows)"

$APP_NAME = Read-Host "Enter your project name (e.g. my_cool_app)"
$CLIENT_NAME = Read-Host "Enter client name (e.g. clientname)"
$BUNDLE_ID = "com.$CLIENT_NAME.$APP_NAME"

Write-Host "🔧 Updating project name in pubspec and app.dart..."
(Get-Content pubspec.yaml) -replace "__APP_NAME__", $APP_NAME | Set-Content pubspec.yaml
(Get-Content lib\app.dart) -replace "__APP_NAME__", $APP_NAME | Set-Content lib\app.dart

Write-Host "📦 Generating Flutter project..."
flutter create .

Write-Host "🔧 Updating Android package..."
(Get-Content android\app\build.gradle) -replace "com.example.flutter_boilerplate", $BUNDLE_ID | Set-Content android\app\build.gradle
(Get-Content android\app\src\main\AndroidManifest.xml) -replace "com.example.flutter_boilerplate", $BUNDLE_ID | Set-Content android\app\src\main\AndroidManifest.xml
(Get-Content android\app\src\debug\AndroidManifest.xml) -replace "com.example.flutter_boilerplate", $BUNDLE_ID | Set-Content android\app\src\debug\AndroidManifest.xml
(Get-Content android\app\src\profile\AndroidManifest.xml) -replace "com.example.flutter_boilerplate", $BUNDLE_ID | Set-Content android\app\src\profile\AndroidManifest.xml

# Move MainActivity.kt
$OLD = "android\app\src\main\kotlin\com\example\flutter_boilerplate\MainActivity.kt"
$NEW_FOLDER = "android\app\src\main\kotlin\com\$CLIENT_NAME\$APP_NAME"
New-Item -ItemType Directory -Force -Path $NEW_FOLDER
Move-Item $OLD "$NEW_FOLDER\MainActivity.kt"
Remove-Item -Recurse -Force "android\app\src\main\kotlin\com\example"

Write-Host "🔧 Updating iOS bundle identifier..."
(Get-Content ios\Runner.xcodeproj\project.pbxproj) -replace "com.example.flutterBoilerplate", $BUNDLE_ID | Set-Content ios\Runner.xcodeproj\project.pbxproj
(Get-Content ios\Runner\Info.plist) -replace "com.example.flutterBoilerplate", $BUNDLE_ID | Set-Content ios\Runner\Info.plist

Write-Host "📦 Running flutter pub get..."
flutter pub get

Write-Host "✅ Setup complete!"
Write-Host "App name: $APP_NAME"
Write-Host "Bundle ID: $BUNDLE_ID"
Write-Host "You can now run: flutter run"
