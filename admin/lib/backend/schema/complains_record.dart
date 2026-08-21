import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ComplainsRecord extends FirestoreRecord {
  ComplainsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "deal_ref" field.
  DocumentReference? _dealRef;
  DocumentReference? get dealRef => _dealRef;
  bool hasDealRef() => _dealRef != null;

  // "sender" field.
  DocumentReference? _sender;
  DocumentReference? get sender => _sender;
  bool hasSender() => _sender != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  bool hasText() => _text != null;

  // "time" field.
  DateTime? _time;
  DateTime? get time => _time;
  bool hasTime() => _time != null;

  // "receiver" field.
  DocumentReference? _receiver;
  DocumentReference? get receiver => _receiver;
  bool hasReceiver() => _receiver != null;

  // "type" field.
  ComplainType? _type;
  ComplainType? get type => _type;
  bool hasType() => _type != null;

  void _initializeFields() {
    _dealRef = snapshotData['deal_ref'] as DocumentReference?;
    _sender = snapshotData['sender'] as DocumentReference?;
    _text = snapshotData['text'] as String?;
    _time = snapshotData['time'] as DateTime?;
    _receiver = snapshotData['receiver'] as DocumentReference?;
    _type = deserializeEnum<ComplainType>(snapshotData['type']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('complains');

  static Stream<ComplainsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ComplainsRecord.fromSnapshot(s));

  static Future<ComplainsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ComplainsRecord.fromSnapshot(s));

  static ComplainsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ComplainsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ComplainsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ComplainsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ComplainsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ComplainsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createComplainsRecordData({
  DocumentReference? dealRef,
  DocumentReference? sender,
  String? text,
  DateTime? time,
  DocumentReference? receiver,
  ComplainType? type,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'deal_ref': dealRef,
      'sender': sender,
      'text': text,
      'time': time,
      'receiver': receiver,
      'type': type,
    }.withoutNulls,
  );

  return firestoreData;
}

class ComplainsRecordDocumentEquality implements Equality<ComplainsRecord> {
  const ComplainsRecordDocumentEquality();

  @override
  bool equals(ComplainsRecord? e1, ComplainsRecord? e2) {
    return e1?.dealRef == e2?.dealRef &&
        e1?.sender == e2?.sender &&
        e1?.text == e2?.text &&
        e1?.time == e2?.time &&
        e1?.receiver == e2?.receiver &&
        e1?.type == e2?.type;
  }

  @override
  int hash(ComplainsRecord? e) => const ListEquality()
      .hash([e?.dealRef, e?.sender, e?.text, e?.time, e?.receiver, e?.type]);

  @override
  bool isValidKey(Object? o) => o is ComplainsRecord;
}
