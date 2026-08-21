import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatsRecord extends FirestoreRecord {
  ChatsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "last_edit_time" field.
  DateTime? _lastEditTime;
  DateTime? get lastEditTime => _lastEditTime;
  bool hasLastEditTime() => _lastEditTime != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "users" field.
  List<DocumentReference>? _users;
  List<DocumentReference> get users => _users ?? const [];
  bool hasUsers() => _users != null;

  // "last_message" field.
  DocumentReference? _lastMessage;
  DocumentReference? get lastMessage => _lastMessage;
  bool hasLastMessage() => _lastMessage != null;

  // "members" field.
  List<Map>? _members;
  List<Map> get members => _members ?? const [];
  bool hasMembers() => _members != null;

  // "deal_name" field.
  String? _dealName;
  String get dealName => _dealName ?? '';
  bool hasDealName() => _dealName != null;

  // "deal_ref" field.
  DocumentReference? _dealRef;
  DocumentReference? get dealRef => _dealRef;
  bool hasDealRef() => _dealRef != null;

  void _initializeFields() {
    _createdTime = snapshotData['created_time'] as DateTime?;
    _lastEditTime = snapshotData['last_edit_time'] as DateTime?;
    _type = snapshotData['type'] as String?;
    _users = getDataList(snapshotData['users']);
    _lastMessage = snapshotData['last_message'] as DocumentReference?;
    _members = getDataList(snapshotData['members']);
    _dealName = snapshotData['deal_name'] as String?;
    _dealRef = snapshotData['deal_ref'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chats');

  static Stream<ChatsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatsRecord.fromSnapshot(s));

  static Future<ChatsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatsRecord.fromSnapshot(s));

  static ChatsRecord fromSnapshot(DocumentSnapshot snapshot) => ChatsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatsRecordData({
  DateTime? createdTime,
  DateTime? lastEditTime,
  String? type,
  DocumentReference? lastMessage,
  String? dealName,
  DocumentReference? dealRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'created_time': createdTime,
      'last_edit_time': lastEditTime,
      'type': type,
      'last_message': lastMessage,
      'deal_name': dealName,
      'deal_ref': dealRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatsRecordDocumentEquality implements Equality<ChatsRecord> {
  const ChatsRecordDocumentEquality();

  @override
  bool equals(ChatsRecord? e1, ChatsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.createdTime == e2?.createdTime &&
        e1?.lastEditTime == e2?.lastEditTime &&
        e1?.type == e2?.type &&
        listEquality.equals(e1?.users, e2?.users) &&
        e1?.lastMessage == e2?.lastMessage &&
        listEquality.equals(e1?.members, e2?.members) &&
        e1?.dealName == e2?.dealName &&
        e1?.dealRef == e2?.dealRef;
  }

  @override
  int hash(ChatsRecord? e) => const ListEquality().hash([
        e?.createdTime,
        e?.lastEditTime,
        e?.type,
        e?.users,
        e?.lastMessage,
        e?.members,
        e?.dealName,
        e?.dealRef
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatsRecord;
}
