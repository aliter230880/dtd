import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AdminsRecord extends FirestoreRecord {
  AdminsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "is_blocked" field.
  bool? _isBlocked;
  bool get isBlocked => _isBlocked ?? false;
  bool hasIsBlocked() => _isBlocked != null;

  // "status" field.
  AdminStatus? _status;
  AdminStatus? get status => _status;
  bool hasStatus() => _status != null;

  // "access" field.
  List<AdminAccess>? _access;
  List<AdminAccess> get access => _access ?? const [];
  bool hasAccess() => _access != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "photo_url" field.
  String? _photoUrl;
  String? get photoUrl => _photoUrl;
  bool hasPhotoUrl() => _photoUrl != null;

  // "role" field.
  Role? _role;
  Role? get role => _role;
  bool hasRole() => _role != null;

  // "last_name" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  bool hasLastName() => _lastName != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _uid = snapshotData['uid'] as String?;
    _isBlocked = snapshotData['is_blocked'] as bool?;
    _status = deserializeEnum<AdminStatus>(snapshotData['status']);
    _access = getEnumList<AdminAccess>(snapshotData['access']);
    _phoneNumber = snapshotData['phone_number'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _role = deserializeEnum<Role>(snapshotData['role']);
    _lastName = snapshotData['last_name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('admins');

  static Stream<AdminsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AdminsRecord.fromSnapshot(s));

  static Future<AdminsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AdminsRecord.fromSnapshot(s));

  static AdminsRecord fromSnapshot(DocumentSnapshot snapshot) => AdminsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AdminsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AdminsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AdminsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AdminsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAdminsRecordData({
  String? email,
  String? displayName,
  DateTime? createdTime,
  String? uid,
  bool? isBlocked,
  AdminStatus? status,
  String? phoneNumber,
  String? photoUrl,
  Role? role,
  String? lastName,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'created_time': createdTime,
      'uid': uid,
      'is_blocked': isBlocked,
      'status': status,
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'role': role,
      'last_name': lastName,
    }.withoutNulls,
  );

  return firestoreData;
}

class AdminsRecordDocumentEquality implements Equality<AdminsRecord> {
  const AdminsRecordDocumentEquality();

  @override
  bool equals(AdminsRecord? e1, AdminsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.createdTime == e2?.createdTime &&
        e1?.uid == e2?.uid &&
        e1?.isBlocked == e2?.isBlocked &&
        e1?.status == e2?.status &&
        listEquality.equals(e1?.access, e2?.access) &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.role == e2?.role &&
        e1?.lastName == e2?.lastName;
  }

  @override
  int hash(AdminsRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.createdTime,
        e?.uid,
        e?.isBlocked,
        e?.status,
        e?.access,
        e?.phoneNumber,
        e?.photoUrl,
        e?.role,
        e?.lastName
      ]);

  @override
  bool isValidKey(Object? o) => o is AdminsRecord;
}
