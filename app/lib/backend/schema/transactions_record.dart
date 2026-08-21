import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TransactionsRecord extends FirestoreRecord {
  TransactionsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }
  // type enum { response, publication, popup, adminReturn }
  String? _type;
  String? get type => _type;
  bool hasType() => _type != null;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  bool hasAmount() => _amount != null;

  // "amount" field.
  double? _amountPrice;
  double get amountPrice => _amountPrice ?? 0.0;
  bool hasamountPrice() => _amountPrice != null;

  // "user_ref" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  void _initializeFields() {
    _type = snapshotData['type'] as String?;
    _amount = castToType<double>(snapshotData['amount']);
    _userRef = snapshotData['user_ref'] as DocumentReference?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _amountPrice = castToType<double>(snapshotData['amount_price']);
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('transactions');

  static Stream<TransactionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TransactionsRecord.fromSnapshot(s));

  static Future<TransactionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TransactionsRecord.fromSnapshot(s));

  static TransactionsRecord fromSnapshot(DocumentSnapshot snapshot) => TransactionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TransactionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TransactionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() => 'TransactionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) => other is TransactionsRecord && reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTransactionsRecordData({
  double? amount,
  DocumentReference? userRef,
  DateTime? createdTime,
  String? type,
  double? amountPrice,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'type': type,
      'amount': amount,
      'user_ref': userRef,
      'created_time': createdTime,
      'amount_price': amountPrice,
    }.withoutNulls,
  );

  return firestoreData;
}

class TransactionsRecordDocumentEquality implements Equality<TransactionsRecord> {
  const TransactionsRecordDocumentEquality();

  @override
  bool equals(TransactionsRecord? e1, TransactionsRecord? e2) {
    return e1?.amount == e2?.amount && e1?.userRef == e2?.userRef && e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(TransactionsRecord? e) => const ListEquality().hash([e?.amount, e?.userRef, e?.createdTime]);

  @override
  bool isValidKey(Object? o) => o is TransactionsRecord;
}
