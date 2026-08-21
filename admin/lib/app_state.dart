// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';

import 'backend/backend.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  DocumentReference? _currentChatRef;
  DocumentReference? get currentChatRef => _currentChatRef;
  set currentChatRef(DocumentReference? value) {
    _currentChatRef = value;
  }
}
