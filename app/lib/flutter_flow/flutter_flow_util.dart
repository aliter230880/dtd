// ignore_for_file: type_literal_in_constant_pattern

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:from_css_color/from_css_color.dart';
import 'dart:math' show asin, cos, pi, pow, sin, sqrt;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:json_path/json_path.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

import '../auth/firebase_auth/auth_util.dart';
import '../backend/firebase_storage/storage.dart';
import '../main.dart';

import 'internationalization.dart';
import 'lat_lng.dart';
import 'upload_data.dart';

export 'lat_lng.dart';
export 'place.dart';
export 'uploaded_file.dart';
export '../app_state.dart';
export 'flutter_flow_model.dart';
export 'dart:math' show min, max;
export 'dart:typed_data' show Uint8List;
export 'dart:convert' show jsonEncode, jsonDecode;
export 'package:intl/intl.dart';
export 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference, FirebaseFirestore;
export 'package:page_transition/page_transition.dart';
export 'internationalization.dart' show FFLocalizations;
export '/backend/firebase_analytics/analytics.dart';
export 'nav/nav.dart';

T valueOrDefault<T>(T? value, T defaultValue) =>
    (value is String && value.isEmpty) || value == null ? defaultValue : value;

void _setTimeagoLocales() {
  timeago.setLocaleMessages('ru', timeago.RuMessages());
  timeago.setLocaleMessages('ru_short', timeago.RuShortMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
}

String dateTimeFormat(String format, DateTime? dateTime, {String? locale}) {
  if (dateTime == null) {
    return '';
  }
  if (format == 'relative') {
    _setTimeagoLocales();
    return timeago.format(dateTime, locale: locale, allowFromNow: true);
  }
  return DateFormat(format, locale).format(dateTime);
}

Theme wrapInMaterialDatePickerTheme(
  BuildContext context,
  Widget child, {
  required Color headerBackgroundColor,
  required Color headerForegroundColor,
  required TextStyle headerTextStyle,
  required Color pickerBackgroundColor,
  required Color pickerForegroundColor,
  required Color selectedDateTimeBackgroundColor,
  required Color selectedDateTimeForegroundColor,
  required Color actionButtonForegroundColor,
  required double iconSize,
}) {
  final baseTheme = Theme.of(context);
  final dateTimeMaterialStateForegroundColor = MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.disabled)) {
      return pickerForegroundColor.withOpacity(0.60);
    }
    if (states.contains(MaterialState.selected)) {
      return selectedDateTimeForegroundColor;
    }
    if (states.isEmpty) {
      return pickerForegroundColor;
    }
    return null;
  });

  final dateTimeMaterialStateBackgroundColor = MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.selected)) {
      return selectedDateTimeBackgroundColor;
    }
    return null;
  });

  return Theme(
    data: baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        onSurface: pickerForegroundColor,
      ),
      disabledColor: pickerForegroundColor.withOpacity(0.3),
      textTheme: baseTheme.textTheme.copyWith(
        headlineSmall: headerTextStyle,
        headlineMedium: headerTextStyle,
      ),
      iconTheme: baseTheme.iconTheme.copyWith(
        size: iconSize,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(
              actionButtonForegroundColor,
            ),
            overlayColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.hovered)) {
                return actionButtonForegroundColor.withOpacity(0.04);
              }
              if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
                return actionButtonForegroundColor.withOpacity(0.12);
              }
              return null;
            })),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: pickerBackgroundColor,
        headerBackgroundColor: headerBackgroundColor,
        headerForegroundColor: headerForegroundColor,
        weekdayStyle: baseTheme.textTheme.labelMedium!.copyWith(
          color: pickerForegroundColor,
        ),
        dayBackgroundColor: dateTimeMaterialStateBackgroundColor,
        todayBackgroundColor: dateTimeMaterialStateBackgroundColor,
        yearBackgroundColor: dateTimeMaterialStateBackgroundColor,
        dayForegroundColor: dateTimeMaterialStateForegroundColor,
        todayForegroundColor: dateTimeMaterialStateForegroundColor,
        yearForegroundColor: dateTimeMaterialStateForegroundColor,
      ),
    ),
    child: child,
  );
}

Theme wrapInMaterialTimePickerTheme(
  BuildContext context,
  Widget child, {
  required Color headerBackgroundColor,
  required Color headerForegroundColor,
  required TextStyle headerTextStyle,
  required Color pickerBackgroundColor,
  required Color pickerForegroundColor,
  required Color selectedDateTimeBackgroundColor,
  required Color selectedDateTimeForegroundColor,
  required Color actionButtonForegroundColor,
  required double iconSize,
}) {
  final baseTheme = Theme.of(context);
  return Theme(
    data: baseTheme.copyWith(
      iconTheme: baseTheme.iconTheme.copyWith(
        size: iconSize,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(
              actionButtonForegroundColor,
            ),
            overlayColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.hovered)) {
                return actionButtonForegroundColor.withOpacity(0.04);
              }
              if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
                return actionButtonForegroundColor.withOpacity(0.12);
              }
              return null;
            })),
      ),
      timePickerTheme: baseTheme.timePickerTheme.copyWith(
        backgroundColor: pickerBackgroundColor,
        hourMinuteTextColor: pickerForegroundColor,
        dialHandColor: selectedDateTimeBackgroundColor,
        dialTextColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.selected) ? selectedDateTimeForegroundColor : pickerForegroundColor),
        dayPeriodBorderSide: BorderSide(
          color: pickerForegroundColor,
        ),
        dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.selected) ? selectedDateTimeForegroundColor : pickerForegroundColor),
        dayPeriodColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? selectedDateTimeBackgroundColor : Colors.transparent),
        entryModeIconColor: pickerForegroundColor,
      ),
    ),
    child: child,
  );
}

Future launchURL(String url) async {
  var uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    throw 'Could not launch $uri: $e';
  }
}

Color colorFromCssString(String color, {Color? defaultColor}) {
  try {
    return fromCssColor(color);
  } catch (_) {}
  return defaultColor ?? Colors.black;
}

Future launchMap({
  MapType? mapType,
  LatLng? location,
  String? address,
  required title,
}) async {
  final coords = location != null ? Coords(location.latitude, location.longitude) : Coords(0, 0);
  final extraParams = address != null ? {'q': address} : null;
  final noMap = mapType == null || !(await MapLauncher.isMapAvailable(mapType) ?? false);
  if (noMap) {
    final installedMaps = await MapLauncher.installedMaps;
    return installedMaps.first.showMarker(
      coords: coords,
      title: title,
      extraParams: extraParams,
    );
  }
  return MapLauncher.showMarker(
    mapType: mapType,
    coords: coords,
    title: title,
    extraParams: extraParams,
  );
}

enum FormatType {
  decimal,
  percent,
  scientific,
  compact,
  compactLong,
  custom,
}

enum DecimalType {
  automatic,
  periodDecimal,
  commaDecimal,
}

var currencyFormat = NumberFormat.currency(locale: "ru", symbol: "\$", decimalDigits: 0);
String formatNumber(
  num? value, {
  required FormatType formatType,
  DecimalType? decimalType,
  String? currency,
  bool toLowerCase = false,
  String? format,
  String? locale,
}) {
  if (value == null) {
    return '';
  }
  var formattedValue = '';
  switch (formatType) {
    case FormatType.decimal:
      switch (decimalType!) {
        case DecimalType.automatic:
          formattedValue = NumberFormat.decimalPattern().format(value);
          break;
        case DecimalType.periodDecimal:
          formattedValue = NumberFormat.decimalPattern('en_US').format(value);
          break;
        case DecimalType.commaDecimal:
          formattedValue = NumberFormat.decimalPattern('es_PA').format(value);
          break;
      }
      break;
    case FormatType.percent:
      formattedValue = NumberFormat.percentPattern().format(value);
      break;
    case FormatType.scientific:
      formattedValue = NumberFormat.scientificPattern().format(value);
      if (toLowerCase) {
        formattedValue = formattedValue.toLowerCase();
      }
      break;
    case FormatType.compact:
      formattedValue = NumberFormat.compact().format(value);
      break;
    case FormatType.compactLong:
      formattedValue = NumberFormat.compactLong().format(value);
      break;
    case FormatType.custom:
      final hasLocale = locale != null && locale.isNotEmpty;
      formattedValue = NumberFormat(format, hasLocale ? locale : null).format(value);
  }

  if (formattedValue.isEmpty) {
    return value.toString();
  }

  if (currency != null) {
    final currencySymbol = currency.isNotEmpty ? currency : NumberFormat.simpleCurrency().format(0.0).substring(0, 1);
    formattedValue = '$currencySymbol$formattedValue';
  }

  return formattedValue;
}

DateTime get getCurrentTimestamp => DateTime.now();
DateTime dateTimeFromSecondsSinceEpoch(int seconds) {
  return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
}

extension DateTimeConversionExtension on DateTime {
  int get secondsSinceEpoch => (millisecondsSinceEpoch / 1000).round();
}

extension DateTimeComparisonOperators on DateTime {
  bool operator <(DateTime other) => isBefore(other);
  bool operator >(DateTime other) => isAfter(other);
  bool operator <=(DateTime other) => this < other || isAtSameMomentAs(other);
  bool operator >=(DateTime other) => this > other || isAtSameMomentAs(other);
}

T? castToType<T>(dynamic value) {
  if (value == null) {
    return null;
  }
  switch (T) {
    case double:
      // Doubles may be stored as ints in some cases.
      return value.toDouble() as T;
    case int:
      // Likewise, ints may be stored as doubles. If this is the case
      // (i.e. no decimal value), return the value as an int.
      if (value is num && value.toInt() == value) {
        return value.toInt() as T;
      }
      break;
    default:
      break;
  }
  return value as T;
}

dynamic getJsonField(
  dynamic response,
  String jsonPath, [
  bool isForList = false,
]) {
  final field = JsonPath(jsonPath).read(response);
  if (field.isEmpty) {
    return null;
  }
  if (field.length > 1) {
    return field.map((f) => f.value).toList();
  }
  final value = field.first.value;
  if (isForList) {
    return value is! Iterable ? [value] : (value is List ? value : value.toList());
  }
  return value;
}

Rect? getWidgetBoundingBox(BuildContext context) {
  try {
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox!.localToGlobal(Offset.zero) & renderBox.size;
  } catch (_) {
    return null;
  }
}

bool get isAndroid => !kIsWeb && Platform.isAndroid;
bool get isiOS => !kIsWeb && Platform.isIOS;
bool get isWeb => kIsWeb;

const kBreakpointSmall = 479.0;
const kBreakpointMedium = 767.0;
const kBreakpointLarge = 991.0;
bool isMobileWidth(BuildContext context) => MediaQuery.sizeOf(context).width < kBreakpointSmall;
bool responsiveVisibility({
  required BuildContext context,
  bool phone = true,
  bool tablet = true,
  bool tabletLandscape = true,
  bool desktop = true,
}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < kBreakpointSmall) {
    return phone;
  } else if (width < kBreakpointMedium) {
    return tablet;
  } else if (width < kBreakpointLarge) {
    return tabletLandscape;
  } else {
    return desktop;
  }
}

const kTextValidatorUsernameRegex = r'^[a-zA-Z][a-zA-Z0-9_-]{2,16}$';
// https://stackoverflow.com/a/201378
const kTextValidatorEmailRegex =
    "^(?:[a-zA-Z0-9!#\$%&\'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#\$%&\'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])\$";
const kTextValidatorWebsiteRegex =
    r'(https?:\/\/)?(www\.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,10}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)|(https?:\/\/)?(www\.)?(?!ww)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,10}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)';

LatLng? cachedUserLocation;
Future<LatLng> getCurrentUserLocation({required LatLng defaultLocation, bool cached = false}) async {
  if (cached && cachedUserLocation != null) {
    return cachedUserLocation!;
  }
  return queryCurrentUserLocation().then((loc) {
    if (loc != null) {
      cachedUserLocation = loc;
    }
    return loc ?? defaultLocation;
  }).onError((error, _) {
    print("Error querying user location: $error");
    return defaultLocation;
  });
}

Future<LatLng?> queryCurrentUserLocation() async {
  // final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  // if (!serviceEnabled) {
  //   return Future.error('Location services are disabled.');
  // }
  try {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    final position = await Geolocator.getCurrentPosition();
    return position.latitude != 0 && position.longitude != 0 ? LatLng(position.latitude, position.longitude) : null;
  } catch (e) {
    print('Error on get location: $e');
    return null;
  }
}

extension FFTextEditingControllerExt on TextEditingController? {
  String get text => this == null ? '' : this!.text;
  set text(String newText) => this?.text = newText;
}

extension IterableExt<T> on Iterable<T> {
  List<T> sortedList<S extends Comparable>([S Function(T)? keyOf]) =>
      toList()..sort(keyOf == null ? null : ((a, b) => keyOf(a).compareTo(keyOf(b))));

  List<S> mapIndexed<S>(S Function(int, T) func) =>
      toList().asMap().map((index, value) => MapEntry(index, func(index, value))).values.toList();
}

extension StringDocRef on String {
  DocumentReference get ref => FirebaseFirestore.instance.doc(this);
}

void setAppLanguage(BuildContext context, String language) => MyApp.of(context).setLocale(language);

void setDarkModeSetting(BuildContext context, ThemeMode themeMode) => MyApp.of(context).setThemeMode(themeMode);

void showSnackbar(
  BuildContext context,
  String message, {
  bool loading = false,
  int duration = 4,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 10.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          Text(message),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}

extension FFStringExt on String {
  String maybeHandleOverflow({int? maxChars, String replacement = ''}) =>
      maxChars != null && length > maxChars ? replaceRange(maxChars, null, replacement) : this;
}

extension ListFilterExt<T> on Iterable<T?> {
  List<T> get withoutNulls => where((s) => s != null).map((e) => e!).toList();
}

extension MapListContainsExt on List<dynamic> {
  bool containsMap(dynamic map) =>
      map is Map ? any((e) => e is Map && const DeepCollectionEquality().equals(e, map)) : contains(map);
}

extension ListDivideExt<T extends Widget> on Iterable<T> {
  Iterable<MapEntry<int, Widget>> get enumerate => toList().asMap().entries;

  List<Widget> divide(Widget t, {bool Function(int)? filterFn}) => isEmpty
      ? []
      : (enumerate.map((e) => [e.value, if (filterFn == null || filterFn(e.key)) t]).expand((i) => i).toList()
        ..removeLast());

  List<Widget> around(Widget t) => addToStart(t).addToEnd(t);

  List<Widget> addToStart(Widget t) => enumerate.map((e) => e.value).toList()..insert(0, t);

  List<Widget> addToEnd(Widget t) => enumerate.map((e) => e.value).toList()..add(t);

  List<Padding> paddingTopEach(double val) =>
      map((w) => Padding(padding: EdgeInsets.only(top: val), child: w)).toList();
}

extension StatefulWidgetExtensions on State<StatefulWidget> {
  /// Check if the widget exist before safely setting state.
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }
}

// For iOS 16 and below, set the status bar color to match the app's theme.
// https://github.com/flutter/flutter/issues/41067
Brightness? _lastBrightness;
void fixStatusBarOniOS16AndBelow(BuildContext context) {
  if (!isiOS) {
    return;
  }
  final brightness = Theme.of(context).brightness;
  if (_lastBrightness != brightness) {
    _lastBrightness = brightness;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: brightness,
        systemStatusBarContrastEnforced: true,
      ),
    );
  }
}

extension ListUniqueExt<T> on Iterable<T> {
  List<T> unique(dynamic Function(T) getKey) {
    var distinctSet = <dynamic>{};
    var distinctList = <T>[];
    for (var item in this) {
      if (distinctSet.add(getKey(item))) {
        distinctList.add(item);
      }
    }
    return distinctList;
  }
}

String roundTo(double value, int decimalPoints) {
  final power = pow(10, decimalPoints);
  return ((value * power).round() / power).toString();
}

double computeGradientAlignmentX(double evaluatedAngle) {
  evaluatedAngle %= 360;
  final rads = evaluatedAngle * pi / 180;
  double x;
  if (evaluatedAngle < 45 || evaluatedAngle > 315) {
    x = sin(2 * rads);
  } else if (45 <= evaluatedAngle && evaluatedAngle <= 135) {
    x = 1;
  } else if (135 <= evaluatedAngle && evaluatedAngle <= 225) {
    x = sin(-2 * rads);
  } else {
    x = -1;
  }
  return double.parse(roundTo(x, 2));
}

double computeGradientAlignmentY(double evaluatedAngle) {
  evaluatedAngle %= 360;
  final rads = evaluatedAngle * pi / 180;
  double y;
  if (evaluatedAngle < 45 || evaluatedAngle > 315) {
    y = -1;
  } else if (45 <= evaluatedAngle && evaluatedAngle <= 135) {
    y = sin(-2 * rads);
  } else if (135 <= evaluatedAngle && evaluatedAngle <= 225) {
    y = 1;
  } else {
    y = sin(2 * rads);
  }
  return double.parse(roundTo(y, 2));
}

Future<String?> uploadToDBPath(String filePath) async {
  final pickedMedia = File(filePath);
  String fileName = filePath.split('/').last;
  final mediaBytes = await pickedMedia.readAsBytes();
  final path = getStoragePath(currentUserUid, fileName, false);
  final String? url = await uploadData(path, mediaBytes);
  return url;
}

class GeoUtil {
  static double distance(GeoPoint p1, GeoPoint p2) {
    final dlat = degreesToRadians(p2.latitude - p1.latitude);
    final dlon = degreesToRadians(p2.longitude - p1.longitude);
    final lat1 = degreesToRadians(p1.latitude);
    final lat2 = degreesToRadians(p2.latitude);

    const r = 6378.137; // WGS84 major axis
    double c = 2 * asin(sqrt(pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2)));
    return r * c;
  }

  static double degreesToRadians(double degrees) {
    return (degrees * pi) / 180;
  }

  static Future<String?> getDistance(LatLng? latLng) async {
    if (latLng == null) return null;
    final currentLocation = await queryCurrentUserLocation();
    if (currentLocation == null) return null;

    final GeoPoint p1 = GeoPoint(currentLocation.latitude, currentLocation.longitude);
    final GeoPoint p2 = GeoPoint(latLng.latitude, latLng.longitude);

    return GeoUtil.distance(p1, p2).toStringAsFixed(0);
  }
}

String getDealsCounterText(BuildContext context, int count) {
  final langCode = FFLocalizations.of(context).languageCode;
  if (langCode == 'ru') {
    if (count % 10 == 1 && count % 100 != 11) {
      return '$count заказ';
    } else if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return '$count заказа';
    } else {
      return '$count заказов';
    }
  } else {
    return '$count ${count > 1 ? 'orders' : 'order'}';
  }
}

String getReviewCounterText(BuildContext context, int count) {
  final langCode = FFLocalizations.of(context).languageCode;
  if (langCode == 'ru') {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'отзыв';
    } else if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return 'отзыва';
    } else {
      return 'отзывов';
    }
  } else {
    return count > 1 ? 'reviews' : 'review';
  }
}

String getResponseCounterText(BuildContext context, int count) {
  final langCode = FFLocalizations.of(context).languageCode;
  if (langCode == 'ru') {
    if (count % 10 == 1 && count % 100 != 11) {
      return '$count отклик';
    } else if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return '$count отклика';
    } else {
      return '$count откликов';
    }
  } else {
    return '$count ${count > 1 ? 'responses' : 'response'}';
  }
}

String getFreeDealsCounterText(BuildContext context, int count) {
  final langCode = FFLocalizations.of(context).languageCode;
  if (langCode == 'ru') {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'У вас остался $count бесплатный заказ';
    } else if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return 'У вас остались $count бесплатных заказа';
    } else {
      return 'У вас осталось $count бесплатных заказов';
    }
  } else {
    return 'You have $count free ${count > 1 ? 'orders' : 'order'} left.';
  }
}

String getFreeResponsesCounterText(BuildContext context, int count) {
  final langCode = FFLocalizations.of(context).languageCode;
  if (langCode == 'ru') {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'У вас остался $count бесплатный отклик';
    } else if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return 'У вас остались $count бесплатных отклика';
    } else {
      return 'У вас осталось $count бесплатных откликов';
    }
  } else {
    return 'You have $count free ${count > 1 ? 'orders' : 'order'} left.';
  }
}

String getFreeDealsTokensCounterText(BuildContext context, int count) {
  final langCode = FFLocalizations.of(context).languageCode;
  if (langCode == 'ru') {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'Далее каждый заказ -$count токен';
    } else if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return 'Далее каждый заказ -$count токена';
    } else {
      return 'Далее каждый заказ -$count токенов';
    }
  } else {
    return 'Each additional order costs -$count ${count > 1 ? 'tokens' : 'token'}';
  }
}


