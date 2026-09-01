import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA0DbQZnoBHzaU6NLEEVlEQrOu4rE_F_Jw",
            authDomain: "dtdapp007.firebaseapp.com",
            projectId: "dtdapp007",
            storageBucket: "dtdapp007.firebasestorage.app",
            messagingSenderId: "406048199497",
            appId: "1:406048199497:web:447902119b1ac144634098",
            measurementId: "G-DQ8514KSBG"));
  } else {
    await Firebase.initializeApp();
  }
}
