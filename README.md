# BikeKollectiveCCL | CS467 - Online Capstone Project

## Pre-reqs
1. Install flutter, and set up Android emulator. See [here](https://flutter.dev/docs/get-started/install). Use relatively newer version (~2.0.0 >) of Flutter
2. (Optional) Install VSCode. See [here](https://code.visualstudio.com/)


## Setting up local environment
1. Fork main [BikeKollectiveCCL](github.com/BikeKollectiveCCL/BikeKollectiveCCL) repo by clicking the fork button in the upper right hand corner of a repo page
2. Go into your desired local working folder (ex. ~, C:\Users\username), open terminal and run the following commands:
    ```
    git clone <forked_github_url>
    cd BikeKollectiveCCL
    flutter pub get
    ```
3. Append MAPS_API_KEY to android/local.properties
    ```
    MAPS_API_KEY=<key_goes_here>
    ```

## Debugging in VS Code
1. Start device of choice (ex. Pixel 3a x86)
2. If it does not exist, add following config to ./.vscode/launch.json
    ```
    {
        "version": "0.2.0",
        "configurations": [
            {
                "name": "BikeKollectiveCCL",
                "request": "launch",
                "type": "dart",
                "program": "lib/main.dart"
            }
        ]
    }
    ```
3. Launch BikeKollectiveCCL (alternatively, call "flutter run" from terminal)
4. For app login credentials, sign up with a email account and verify email

## VS Code workspace settings
1. Optional VScode workspace setting
    ```
    {
        "folders": [
            {
                "name": "root",
                "path": "."
            },
            {
                "name": "lib",
                "path": "./lib"
            }
        ],
        "settings": {
            "java.configuration.updateBuildConfiguration": "interactive",
            "editor.formatOnSave": true,
            "editor.formatOnSaveMode": "modifications",
        },
        "extensions": {
            "recommendations": ["Dart-Code.dart-code", "Dart-Code.flutter", "Nash.awesome-flutter-snippets"]
        }
    }
    ```


## Important links
1. See authenticated users [here](https://console.firebase.google.com/project/bikekollective-e87b3/authentication/users)
2. Enable Maps API [here](https://console.cloud.google.com/google/maps-apis/overview?authuser=0&folder=&organizationId=&project=bikekollective-e87b3) and get MAPS_API_KEY if needed
3. Helpful [Firebase Authentication](https://firebase.flutter.dev/docs/auth/usage/) and [Cloud Firestore](https://firebase.flutter.dev/docs/firestore/usage/) links


## Tips
1. If notifications are not showing up, clean Flutter project and wipe data in emulator via Android AVD and relaunch app