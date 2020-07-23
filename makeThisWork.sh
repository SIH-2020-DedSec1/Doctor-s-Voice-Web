killall -9 dart && #Kills Dart server (if Flutter startup lock failed)
npx kill-port --port 5000 && # Kills 5000 port. Useful for testing furfoses
flutter build web --release && # Release version has less bugs than debug version
firebase deploy && # Firebase deploy deploys to hosting link
firebase serve # Load local version on port 5000 for testing 

