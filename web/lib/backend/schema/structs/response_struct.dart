// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ResponseStruct extends FFFirebaseStruct {
  ResponseStruct({
    DocumentReference? user,
    DateTime? time,
    int? responseCost,
    DocumentReference? dealRef,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _user = user,
        _time = time,
        _responseCost = responseCost,
        _dealRef = dealRef,
        super(firestoreUtilData);

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  set user(DocumentReference? val) => _user = val;
  bool hasUser() => _user != null;

  // "time" field.
  DateTime? _time;
  DateTime? get time => _time;
  set time(DateTime? val) => _time = val;
  bool hasTime() => _time != null;

  // "response_cost" field.
  int? _responseCost;
  int get responseCost => _responseCost ?? 0;
  set responseCost(int? val) => _responseCost = val;
  void incrementResponseCost(int amount) =>
      _responseCost = responseCost + amount;
  bool hasResponseCost() => _responseCost != null;

  // "deal_ref" field.
  DocumentReference? _dealRef;
  DocumentReference? get dealRef => _dealRef;
  set dealRef(DocumentReference? val) => _dealRef = val;
  bool hasDealRef() => _dealRef != null;

  static ResponseStruct fromMap(Map<String, dynamic> data) => ResponseStruct(
        user: data['user'] as DocumentReference?,
        time: data['time'] as DateTime?,
        responseCost: castToType<int>(data['response_cost']),
        dealRef: data['deal_ref'] as DocumentReference?,
      );

  static ResponseStruct? maybeFromMap(dynamic data) =>
      data is Map ? ResponseStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'user': _user,
        'time': _time,
        'response_cost': _responseCost,
        'deal_ref': _dealRef,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'user': serializeParam(
          _user,
          ParamType.DocumentReference,
        ),
        'time': serializeParam(
          _time,
          ParamType.DateTime,
        ),
        'response_cost': serializeParam(
          _responseCost,
          ParamType.int,
        ),
        'deal_ref': serializeParam(
          _dealRef,
          ParamType.DocumentReference,
        ),
      }.withoutNulls;

  static ResponseStruct fromSerializableMap(Map<String, dynamic> data) =>
      ResponseStruct(
        user: deserializeParam(
          data['user'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['users'],
        ),
        time: deserializeParam(
          data['time'],
          ParamType.DateTime,
          false,
        ),
        responseCost: deserializeParam(
          data['response_cost'],
          ParamType.int,
          false,
        ),
        dealRef: deserializeParam(
          data['deal_ref'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['deals'],
        ),
      );

  @override
  String toString() => 'ResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ResponseStruct &&
        user == other.user &&
        time == other.time &&
        responseCost == other.responseCost &&
        dealRef == other.dealRef;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([user, time, responseCost, dealRef]);
}

ResponseStruct createResponseStruct({
  DocumentReference? user,
  DateTime? time,
  int? responseCost,
  DocumentReference? dealRef,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ResponseStruct(
      user: user,
      time: time,
      responseCost: responseCost,
      dealRef: dealRef,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ResponseStruct? updateResponseStruct(
  ResponseStruct? response, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    response
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addResponseStructData(
  Map<String, dynamic> firestoreData,
  ResponseStruct? response,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (response == null) {
    return;
  }
  if (response.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && response.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final responseData = getResponseFirestoreData(response, forFieldValue);
  final nestedData = responseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = response.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getResponseFirestoreData(
  ResponseStruct? response, [
  bool forFieldValue = false,
]) {
  if (response == null) {
    return {};
  }
  final firestoreData = mapToFirestore(response.toMap());

  // Add any Firestore field values
  response.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getResponseListFirestoreData(
  List<ResponseStruct>? responses,
) =>
    responses?.map((e) => getResponseFirestoreData(e, true)).toList() ?? [];
