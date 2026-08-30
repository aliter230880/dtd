// ignore_for_file: unnecessary_getters_setters, avoid_init_to_null, unused_element

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '/backend/schema/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _filterByRate = prefs.containsKey('ff_filterByRate')
          ? deserializeEnum<FilterRate>(prefs.getString('ff_filterByRate'))
          : _filterByRate;
    });
    _safeInit(() {
      _filterByCostMin = prefs.getInt('ff_filterByCostMin') ?? _filterByCostMin;
    });
    _safeInit(() {
      _filterByCostMax = prefs.getInt('ff_filterByCostMax') ?? _filterByCostMax;
    });
    _safeInit(() {
      _filterByAuction = prefs.getString('ff_filterByAuction')?.ref ?? _filterByAuction;
    });
    _safeInit(() {
      _filterByGeo = latLngFromString(prefs.getString('ff_filterByGeo')) ?? _filterByGeo;
    });
    _safeInit(() {
      _filterByGeoRadius = prefs.getInt('ff_filterByGeoRadius') ?? _filterByGeoRadius;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _createDealCarName = '';
  String get createDealCarName => _createDealCarName;
  set createDealCarName(String value) {
    _createDealCarName = value;
  }

  /// VIN автомобиля в черновике сделки. Подтверждается в базе NHTSA vPIC,
  /// оттуда же подставляются марка, модель и год в название.
  String _createDealCarVin = '';
  String get createDealCarVin => _createDealCarVin;
  set createDealCarVin(String value) {
    _createDealCarVin = value;
  }

  String _editDealCarName = '';
  String get editDealCarName => _editDealCarName;
  set editDealCarName(String value) {
    _editDealCarName = value;
  }

  List<String> _createDealCarPhotos = ['', '', '', '', '', '', '', '', ''];
  List<String> get createDealCarPhotos => _createDealCarPhotos;
  set createDealCarPhotos(List<String> value) {
    _createDealCarPhotos = value;
  }

  bool get hasCarPhotoItem => _createDealCarPhotos.firstWhereOrNull((p) => p != '') != null;

  void addToCreateDealCarPhotos(String value) {
    _createDealCarPhotos.add(value);
  }

  void removeFromCreateDealCarPhotos(String value) {
    _createDealCarPhotos.remove(value);
  }

  void removeAtIndexFromCreateDealCarPhotos(int index) {
    _createDealCarPhotos.removeAt(index);
  }

  void updateCreateDealCarPhotosAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    _createDealCarPhotos[index] = updateFn(_createDealCarPhotos[index]);
  }

  void insertAtIndexInCreateDealCarPhotos(int index, String value) {
    _createDealCarPhotos.insert(index, value);
  }

  bool _createDealInsuranceRequired = false;
  bool get createDealInsuranceRequired => _createDealInsuranceRequired;
  set createDealInsuranceRequired(bool value) {
    _createDealInsuranceRequired = value;
  }

  void clearAll() {
    _createDealCarName = '';
    _createDealCarVin = '';
    _createDealCarPhotos = ['', '', '', '', '', '', '', '', ''];
    _createDealDescription = '';
    _createDealAddress = '';
    _createDealGeo = null;
    _createDealAuction = null;
    _createDealDate = null;
    _createDealPrice = '';
    _createDealPayType = 'card';
    _creatDealFiles = ['', '', '', '', ''];
    _createDealInsuranceRequired = false;
  }

  String _createDealDescription = '';
  String get createDealDescription => _createDealDescription;
  set createDealDescription(String value) {
    _createDealDescription = value;
  }

  String _createDealAddress = '';
  String get createDealAddress => _createDealAddress;
  set createDealAddress(String value) {
    _createDealAddress = value;
  }

  LatLng? _createDealGeo = null;
  LatLng? get createDealGeo => _createDealGeo;
  set createDealGeo(LatLng? value) {
    _createDealGeo = value;
  }

  DocumentReference? _createDealAuction;
  DocumentReference? get createDealAuction => _createDealAuction;
  set createDealAuction(DocumentReference? value) {
    _createDealAuction = value;
  }

  DateTime? _createDealDate = null;
  DateTime? get createDealDate => _createDealDate;
  set createDealDate(DateTime? value) {
    _createDealDate = value;
  }

  String _createDealPrice = '';
  String get createDealPrice => _createDealPrice;
  set createDealPrice(String value) {
    _createDealPrice = value;
  }

  String _createDealPayType = 'card';
  String get createDealPayType => _createDealPayType;
  set createDealPayType(String value) {
    _createDealPayType = value;
  }

  List<String> _creatDealFiles = ['', '', '', '', ''];
  List<String> get creatDealFiles => _creatDealFiles;
  set creatDealFiles(List<String> value) {
    _creatDealFiles = value;
  }

  void addToCreatDealFiles(String value) {
    _creatDealFiles.add(value);
  }

  void removeFromCreatDealFiles(String value) {
    _creatDealFiles.remove(value);
  }

  void removeAtIndexFromCreatDealFiles(int index) {
    _creatDealFiles.removeAt(index);
  }

  void updateCreatDealFilesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    _creatDealFiles[index] = updateFn(_creatDealFiles[index]);
  }

  void insertAtIndexInCreatDealFiles(int index, String value) {
    _creatDealFiles.insert(index, value);
  }

  FilterRate? _filterByRate = FilterRate.any;
  FilterRate? get filterByRate => _filterByRate;
  set filterByRate(FilterRate? value) {
    _filterByRate = value;
    value != null ? prefs.setString('ff_filterByRate', value.serialize()) : prefs.remove('ff_filterByRate');
  }

  int _filterByCostMin = 0;
  int get filterByCostMin => _filterByCostMin;
  set filterByCostMin(int value) {
    _filterByCostMin = value;
    prefs.setInt('ff_filterByCostMin', value);
  }

  int _filterByCostMax = 0;
  int get filterByCostMax => _filterByCostMax;
  set filterByCostMax(int value) {
    _filterByCostMax = value;
    prefs.setInt('ff_filterByCostMax', value);
  }

  DocumentReference? _filterByAuction;
  DocumentReference? get filterByAuction => _filterByAuction;
  set filterByAuction(DocumentReference? value) {
    _filterByAuction = value;
    value != null ? prefs.setString('ff_filterByAuction', value.path) : prefs.remove('ff_filterByAuction');
  }

  LatLng? _filterByGeo;
  LatLng? get filterByGeo => _filterByGeo;
  set filterByGeo(LatLng? value) {
    _filterByGeo = value;
    value != null ? prefs.setString('ff_filterByGeo', value.serialize()) : prefs.remove('ff_filterByGeo');
  }

  int _filterByGeoRadius = 0;
  int get filterByGeoRadius => _filterByGeoRadius;
  set filterByGeoRadius(int value) {
    _filterByGeoRadius = value;
    prefs.setInt('ff_filterByGeoRadius', value);
  }

  DocumentReference? _currentChatRef;
  DocumentReference? get currentChatRef => _currentChatRef;
  set currentChatRef(DocumentReference? value) {
    _currentChatRef = value;
  }


  bool _isAnonymEnter = false;
  bool get isAnonymEnter => _isAnonymEnter;
  set isAnonymEnter(bool value) {
    _isAnonymEnter = value;
    prefs.setBool('_isAnonymEnter', value);
  }

}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
