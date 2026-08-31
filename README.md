# Smart Farmer ZW Pro v1.0

Zimbabwe-focused Android Flutter app for livestock, breeding, crops, horticulture, farm calendars and finance.

## Included
- Cattle/Mombe: Mashona, Tuli, Brahman, Hereford, Angus, Simmental, Jersey, Holstein, Ayrshire, beef/dairy crosses, indigenous
- Pigs, sheep, goats, rabbits
- Broilers, layers, roadrunners/indigenous chickens
- Turkeys, ducks, geese
- Tilapia/bream and catfish/muramba
- Dogs and horses
- Crop/horticulture catalogue
- Animal and crop records
- Breeding/feeding/vaccination/deworming/task calendar
- Local offline persistence using SharedPreferences
- Farm sales, expenses and profit
- Pro paywall UI
- Google Play Billing dependency with product ID `smart_farmer_pro` planned for the production purchase flow
- Android notification permissions in manifest
- Flutter Android embedding v2

## Important production step
The current Pro button deliberately performs a LOCAL DEMO UNLOCK so the app can be tested without a Google Play product.

Before public release, replace the demo unlock in `lib/main.dart` with a verified `in_app_purchase` flow for the non-consumable Google Play product `smart_farmer_pro`. Create that product in Play Console and test through an internal/closed test track.

## Build
Install Flutter and Android Studio/SDK, then:

    flutter pub get
    flutter analyze
    flutter build apk --release

For Play Store:

    flutter build appbundle --release

Google Play prefers AAB for store distribution.

## Install
For a connected Android phone with USB debugging:

    flutter install

Or copy the release APK to the phone and open it to install (Android may require allowing installs from that source).

## Production signing
Create your own upload keystore and keep it private. Do not commit `key.properties` or keystore files to GitHub.
