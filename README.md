# 🚐 Camp Crew App

A mobile and web app built with Flutter to browse and explore campsites.

## 🌍 Overview

This app allows users (prospective campers) to:

- View a list of campsites
- Filter by various attributes (e.g. language(en), water proximity, campfire availability)
- View detailed information for each campsite
- (Bonus) See all campsites on a map with clustering

The app supports **Android**, **iOS**, and **Web**, and follows best practices in **Flutter architecture** using **Riverpod** for state management.

---

## 📱 Features

- ✅ Fetch data from a mock REST API
- ✅ Display list of campsites ordered by name
- ✅ Filter campsites by:
    - Water proximity
    - Campfire availability
    - Host language
- ✅ Navigate to detail page for each campsite
- ✅ (Bonus) Display campsites on a map (Google Maps)
- ✅ Well-structured, feature-first folder organization
- ✅ Unit tests for core logic

---

## 🔧 Tech Stack

- **Flutter** (latest stable version)
- **Riverpod** for state management
- **Google Maps Flutter** (for map + clustering)
- **Mock API**:
  [https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites](https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites)

---

## 📂 Project Structure

Follows a **feature-first / layer-inside** architecture:

Each feature contains its own `model`, `data`, `provider`, `view`, and `widget` folders where necessary.

---

## 🔍 Data Handling Notes

- **Invalid geolocation values:**  
  As mentioned in the task description, the mock API provided invalid geolocation data. To resolve this, I generated **realistic random coordinates within Germany** for each campsite.

- **Missing campsite descriptions:**  
  Since the API lacked campsite descriptions, I **hardcoded descriptive text** to ensure the detail view remains informative and complete.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- A valid **Google Maps API Key**

> 💡 **Note:**  
> To display the campsites on a map, this project uses the `google_maps_flutter` package. You must supply your own Google Maps API key.

#### How to set it up:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Enable **Maps SDK for Android** and **Maps SDK for iOS**
3. Generate an **API key**
4. Add the API key to your project:




**For Android**  
Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_API_KEY_HERE"/>
```

**For iOS**

Edit `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

**For Web**  
Edit `web/index.html and add this inside the <head> tag:`:
```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY_HERE"></script>
```

### Run the App

```bash
# Get packages
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android/iOS
flutter run
