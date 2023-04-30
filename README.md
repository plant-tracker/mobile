# mobile

## Build container
This application uses [Docker](https://www.docker.com/) for development.

To create a container for development, run in the root folder:
```shell
docker-compose build
docker-compose up -d
```

## Connecting to the Android device on Windows
### 1. Install SDK Platform Tools
Download SDK Platform Tools from [here](https://developer.android.com/tools/releases/platform-tools#downloads) and unzip it to the desired location.

Add the unzipped folder to system `path` for quick access.

### 2. Initialize the connection
First, enable [Developer Options](https://developer.android.com/studio/debug/dev-options) on your Android Device. You need to enable Debug Mode.

Connect the device to the system through USB.

Verify that the host machine detects your device:
```shell
adb devices
```

Make sure your Android Device is connected to the same network as the host machine.

Get IP address of your mobile device in `WiFi Settings -> Advanced`.

Connect to the device wirelessly:
```shell
adb tcpip 5555
adb connect your_android_phone_ip:5555
adb devices
```

You might have to confirm connection on your Android Device.

It should now be listed on your device list alongside the USB connection.

### 3. Connect device to the container
Detach the device from USB and see if `adb devices` returns only wireless connection.

Connect to the device from within container:
```shell
docker-compose exec dev adb connect your_android_phone_ip:5555
```

### 4. Build and install
Now you should be able to build and install application:
```shell
docker-compose exec dev flutter run
```
To properly authorize on your Android device, please ensure that you grant the necessary permissions for any pop-up windows or modal prompts that may appear.

If you get `INSTALL_FAILED_USER_RESTRICTED`, you might have to enable additional settings like `Install via USB` and `Wireless debugging`.

If application fails in any other way, like missing dependencies, you might want to consider cleaning the build info:
```shell
docker-compose exec dev flutter clean
```

## Get SHA1 or SHA-256 fingerprint
In order for Google Auth Provider to work, you need to get an application fingerprint and add it to Firebase application.

You can get it through a shortcut script:
```shell
./signingReport.sh
```

If it's missing, for development you can generate `debug.keystore` in `/root/.android` location inside container with [these instructions.](https://coderwall.com/p/r09hoq/android-generate-release-debug-keystores)
