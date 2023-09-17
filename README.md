# Qaabl-mobile

To start developing what you need is a few things:

1. Flutter: downloaded from their website as a zip, unzip it, and set the environment variable
2. Firebase: run `curl -sL https://firebase.tools | bash` then `firebase login` then run `dart pub global activate flutterfire_cli` inside the project's root directory then run `export PATH="$PATH":"$HOME/.pub-cache/bin"`
3. Xcode: download it on the device and download its tools by running `sudo gem install xcodeproj` then `xcode-select --install`
4. Node and npm: install from Node website, run `npm install -g firebase-tools`, then `firebase login`, then `firebase init functions`
5. Flutterfire: After downloading all of the above, run `flutterfire configure --project=qaabl-mobile-dev`
