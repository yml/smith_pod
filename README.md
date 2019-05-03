# smith_pod

[Flutter based mobile app](https://flutter.dev) that displays the photos of the days from www.smithsonianmag.com/photocontest/

![Preview on android](preview_android.png)

## Release process

* Update the the version number in `pubspec.yaml`
* Update the icon_launcher `flutter packages pub run flutter_launcher_icons:main`
* Generate an appbundle `flutter build appbundle`
* Upload the bundle to `https://play.google.com/apps/publish/`
