import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AuctionsRecord extends FirestoreRecord {
  AuctionsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('auctions');

  static Stream<AuctionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AuctionsRecord.fromSnapshot(s));

  static Future<AuctionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AuctionsRecord.fromSnapshot(s));

  static AuctionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AuctionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AuctionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AuctionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AuctionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AuctionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAuctionsRecordData({
  String? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class AuctionsRecordDocumentEquality implements Equality<AuctionsRecord> {
  const AuctionsRecordDocumentEquality();

  @override
  bool equals(AuctionsRecord? e1, AuctionsRecord? e2) {
    return e1?.name == e2?.name;
  }

  @override
  int hash(AuctionsRecord? e) => const ListEquality().hash([e?.name]);

  @override
  bool isValidKey(Object? o) => o is AuctionsRecord;
}
