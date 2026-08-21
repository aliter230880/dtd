import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAK_vSxa9gzQFHngX6s6Etn1XLspy1CRUc",
            authDomain: "dealertodealer-84957.firebaseapp.com",
            projectId: "dealertodealer-84957",
            storageBucket: "dealertodealer-84957.appspot.com",
            messagingSenderId: "380857780783",
            appId: "1:380857780783:web:18209dcd20060d274694da"));
  } else {
    await Firebase.initializeApp();
  }
}
