import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class ComplainsRecord extends FirestoreRecord {
  ComplainsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "sender" field.
  DocumentReference? _sender;
  DocumentReference? get sender => _sender;
  bool hasSender() => _sender != null;

  // "receiver" field.
  DocumentReference? _receiver;
  DocumentReference? get receiver => _receiver;
  bool hasReceiver() => _receiver != null;

  // "DealRef" field.
  DocumentReference? _dealRef;
  DocumentReference? get dealRef => _dealRef;
  bool hasdealRef() => _dealRef != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  bool hasText() => _text != null;

  // "time" field.
  DateTime? _time;
  DateTime? get time => _time;
  bool hasTime() => _time != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hastype() => _type != null;

  void _initializeFields() {
    _sender = snapshotData['sender'] as DocumentReference?;
    _receiver = snapshotData['receiver'] as DocumentReference?;
    _dealRef = snapshotData['deal_ref'] as DocumentReference?;
    _text = snapshotData['text'] as String?;
    _type = snapshotData['type'] as String?;
    _time = snapshotData['time'] as DateTime?;
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('complains');

  static Stream<ComplainsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ComplainsRecord.fromSnapshot(s));

  static Future<ComplainsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ComplainsRecord.fromSnapshot(s));

  static ComplainsRecord fromSnapshot(DocumentSnapshot snapshot) => ComplainsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ComplainsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ComplainsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() => 'ComplainsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) => other is ComplainsRecord && reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createComplainsRecordData({
  DocumentReference? sender,
  DocumentReference? receiver,
  DocumentReference? dealRef,
  String? type,
  String? text,
  DateTime? time,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'sender': sender,
      'receiver': receiver,
      'deal_ref': dealRef,
      'type': type,
      'text': text,
      'time': time,
    }.withoutNulls,
  );

  return firestoreData;
}

class ComplainsRecordDocumentEquality implements Equality<ComplainsRecord> {
  const ComplainsRecordDocumentEquality();

  @override
  bool equals(ComplainsRecord? e1, ComplainsRecord? e2) {
    return e1?.sender == e2?.sender && e1?.receiver == e2?.receiver && e1?.text == e2?.text && e1?.time == e2?.time;
  }

  @override
  int hash(ComplainsRecord? e) => const ListEquality().hash([e?.sender, e?.receiver, e?.text, e?.time]);

  @override
  bool isValidKey(Object? o) => o is ComplainsRecord;
}
