# Quake — Flutter port — setup

This project was written by hand in a sandbox with no network access, so it
could **not** be run through `flutter create`, `flutter pub get`, or
`flutter analyze`. It has `lib/`, `pubspec.yaml`, assets and an
`analysis_options.yaml`, but no `android/` or `ios/` platform folders yet.
It arrived as `QuakeFlutter.zip` next to this file's original location —
a few steps and it's a normal runnable Flutter project.

## 0. Unzip it

```bash
cd "Quake2.0 copy"          # wherever this landed
unzip QuakeFlutter.zip
cd quake_flutter
```

## 1. Generate the platform folders

From inside this `quake_flutter` folder:

```bash
flutter create --platforms=ios,android,macos .
```

This only *adds* the missing `ios/`, `android/`, `macos/` folders — it will
not touch your existing `lib/`, `pubspec.yaml`, or `assets/` since they
already exist. (Drop `macos` if you don't need a desktop target.)

## 2. Add permission descriptions

The app requests location (map "center on me") and camera/photo-library
access (feedback screenshot attachment), so each platform needs its usual
usage-description entries.

**iOS** — add to `ios/Runner/Info.plist`, inside the outer `<dict>`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Quake uses your location to show relevant nearby earthquake data on the map.</string>
<key>NSCameraUsageDescription</key>
<string>Quake uses the camera to attach a screenshot to your feedback.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Quake uses your photo library to attach an image to your feedback.</string>
```

**Android** — add to `android/app/src/main/AndroidManifest.xml`, as a
direct child of `<manifest>` (above `<application>`):

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

`INTERNET` is included by default in Flutter's Android template.

Also bump `minSdkVersion` in `android/app/build.gradle` (or
`android/app/build.gradle.kts`) to at least **21** if the generated
default is lower — `geolocator` and `image_picker` require it.

## 3. Install packages and run

```bash
flutter pub get
flutter analyze   # worth running once, since this was never compiled
flutter run
```

## What's included

- `lib/` — the full app: data layer (USGS GeoJSON client + models),
  domain use cases, and every screen (Earthquakes list, Earthquake
  detail, Map, Settings + its five sub-screens), plus shared widgets.
- `assets/images/earthquake_map_pin.png` — carried over from the iOS
  app's asset catalog (already wired into `pubspec.yaml`).
- No API keys needed anywhere — the map uses OpenStreetMap tiles via
  `flutter_map`, not Google/Apple Maps.

See the main chat response for a fuller rundown of what was ported and
what was intentionally adapted for Flutter.
