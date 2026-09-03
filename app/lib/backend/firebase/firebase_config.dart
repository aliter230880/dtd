import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBQYqnnOxzkiDIQ7QZHQX_koFm8p2QbZk0",
            authDomain: "dtdapp007.firebaseapp.com",
            projectId: "dtdapp007",
            storageBucket: "dtdapp007.firebasestorage.app",
            messagingSenderId: "406048199497",
            appId: "1:406048199497:web:482e2974419ae4f2634098"));
  } else {
    await Firebase.initializeApp();
  }
}
