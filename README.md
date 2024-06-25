<div align = "center">
   
# GreenTech House Mobile Application

</div>

<div align="center">
  <img src="https://drive.google.com/uc?export=view&id=1oHkSDhuq2BMVmJmC2M38jebAsDMNKzY0" alt="GreenTech House Logo / Mufli-Mohideen" style="width:300px; height:auto">
</div>

Welcome to the GreenTech House mobile application repository. This advanced application is developed using Flutter and integrates various sensors to monitor and control environmental conditions, ensuring optimal plant growth and sustainability. Firebase is used for data storage and management.

## Features

- **Sensor Integration**: Real-time monitoring of moisture, temperature, light intensity, and CO2 levels.
- **Automated Control**: Dynamic adjustments for watering, lighting, and temperature based on sensor feedback.
- **Real-Time Data**: Immediate data access and remote control capabilities for effective greenhouse management.
- **Sustainability Focus**: Utilizes eco-friendly technologies to minimize environmental impact.

## Getting Started

Follow these instructions to set up and run the GreenTech House application on your local machine.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install): Ensure you have Flutter installed.
- [Firebase Account](https://firebase.google.com/): Create a Firebase project.
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) with Flutter and Dart plugins.

### Installation

1. **Clone the Repository**
   ```sh
   git clone https://github.com/Mufli-Mohideen/Green-Tech-House-Mobile-Application.git
   cd Green-Tech-House-Mobile-Application

2. **Set Up Firebase**

   #### Create a Firebase Project

   - Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
   
   #### Add Firebase to Your App

   - After creating your Firebase project, add an Android and/or iOS app to your Firebase project:
     - For Android:
       - Download the `google-services.json` file.
       - Place the `google-services.json` file in the `android/app` directory of your Flutter project.
       
     - For iOS:
       - Download the `GoogleService-Info.plist` file.
       - Place the `GoogleService-Info.plist` file in the `ios/Runner` directory of your Flutter project.

   #### Configure Firebase in Flutter

   - Ensure your `pubspec.yaml` file includes the necessary Firebase dependencies:

     ```yaml
     dependencies:
       flutter:
         sdk: flutter
       firebase_core: latest_version
       firebase_auth: latest_version
       cloud_firestore: latest_version
     ```

     Replace `latest_version` with the current version number of each Firebase plugin you are using.

3. **Run the Application**

   - Connect your device/emulator and run the following command:

     ```sh
     flutter run
     ```

### Testing and Debugging

- Use Flutter's built-in debugging and hot reload feature to test and debug your application:

  ```sh
  flutter run

### Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Community](https://flutter.dev/community)
- [Firebase Community](https://firebase.google.com/community)

## Contributing

If you want to contribute to this project, please fork the repository and create a pull request with your changes.

## License

This project is licensed under the MIT License.

---

<div align="center">

## Developed by Mufli-Mohideen

</div>

