# BikeKollectiveCCL | CS467 - Online Capstone Project

## Setting up local environment
1. Fork main [BikeKollectiveCCL](github.com/BikeKollectiveCCL/BikeKollectiveCCL) repo by clicking the fork button in the upper right hand corner of a repo page
2. Go into your desired local working folder (ex. ~, C:\Users\username), open terminal and run the following commands:
    ```
    git clone <forked_github_url>
    cd BikeKollectiveCCL
    flutter pub get
    ```
3. Append MAPS_API_KEY to android/local.properties. If local.properties
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

## VS Code settings
TBD (Linting, suggestions, extensions, workspace settings)
