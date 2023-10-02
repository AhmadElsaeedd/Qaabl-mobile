# Qaabl-mobile

To start developing what you need is a few things:

1. Flutter: downloaded from their website as a zip, unzip it, and set the environment variable inside the folder of the project using `export PATH="$PATH:`pwd`/flutter/bin"` inside the terminal where you need it
2. Firebase: run `curl -sL https://firebase.tools | bash` then `firebase login` then run `dart pub global activate flutterfire_cli` inside the project's root directory then run `export PATH="$PATH":"$HOME/.pub-cache/bin"`
3. Xcode: download it on the device and download its tools by running `sudo gem install xcodeproj` then `xcode-select --install`
4. Node and npm: install from Node website, run `npm install -g firebase-tools`, then `firebase login`, then `firebase init functions`
5. Flutterfire: After downloading all of the above, run `flutterfire configure --project=qaabl-mobile-dev`
6. To get the firebase emulators to start: run `brew install openjdk` in any terminal then `export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"` inside the project's terminal where you then run `firebase emulators:start`
