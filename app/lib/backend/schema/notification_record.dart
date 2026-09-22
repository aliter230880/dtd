import 'dart:async';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';


class NotificationRecord extends FirestoreRecord {
  NotificationRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  String? _title;
  String get title => _title ?? '';

  String? _text;
  String get text => _text ?? '';

  String? _initialPageName;
  String? get initialPageName => _initialPageName;

  DocumentReference? _recipient;
  DocumentReference? get recipient => _recipient;

  DocumentReference? _sender;
  DocumentReference? get sender => _sender;

  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;

  Map<String, dynamic>? _data;
  Map<String, dynamic>? get data => _data;

  bool? _isRead;
  bool get isRead => _isRead ?? false;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _text = snapshotData['text'] as String?;
    _initialPageName = snapshotData['initial_page_name'] as String?;
    _recipient = snapshotData['recipient'] as DocumentReference?;
    _sender = snapshotData['sender'] as DocumentReference?;
    _createdTime = (snapshotData['timestamp'] as DateTime?);
    _data = snapshotData['parameter_data'] as Map<String, dynamic>?;
    _isRead = snapshotData['is_read'] as bool?;
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('notifications');

  static Stream<NotificationRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationRecord.fromSnapshot(s));

  static Future<NotificationRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationRecord.fromSnapshot(s));

  static NotificationRecord fromSnapshot(DocumentSnapshot snapshot) => NotificationRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotificationRecord._(reference, mapFromFirestore(data));

  @override
  String toString() => 'TransactionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) => other is NotificationRecord && reference.path.hashCode == other.reference.path.hashCode;
}
