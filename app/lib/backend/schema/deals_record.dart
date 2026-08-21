import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DealsRecord extends FirestoreRecord {
  DealsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "car_name" field.
  String? _carName;
  String get carName => _carName ?? '';
  bool hasCarName() => _carName != null;

  // "car_name" field.
  String? _carNumber;
  String get carNumber => _carNumber ?? '';
  bool hascarNumber() => _carNumber != null;

  // "car_photos" field.
  List<String>? _carPhotos;
  List<String> get carPhotos => _carPhotos ?? const [];
  bool hasCarPhotos() => _carPhotos != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "location_address" field.
  String? _locationAddress;
  String get locationAddress => _locationAddress ?? '';
  bool hasLocationAddress() => _locationAddress != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  // "auction" field.
  DocumentReference? _auction;
  DocumentReference? get auction => _auction;
  bool hasAuction() => _auction != null;

  // "deal_date" field.
  DateTime? _dealDate;
  DateTime? get dealDate => _dealDate;
  bool hasDealDate() => _dealDate != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "price" field.
  int? _price;
  int get price => _price ?? 0;
  bool hasPrice() => _price != null;

  // "pay_type" field.
  String? _payType;
  String get payType => _payType ?? '';
  bool hasPayType() => _payType != null;

  // "files" field.
  List<String>? _files;
  List<String> get files => _files ?? const [];
  bool hasFiles() => _files != null;

  // "status" field.
  DealStatus? _status;
  DealStatus? get status => _status;
  bool hasStatus() => _status != null;

  // "owner" field.
  DocumentReference? _owner;
  DocumentReference? get owner => _owner;
  bool hasOwner() => _owner != null;

  // "carrier" field.
  DocumentReference? _carrier;
  DocumentReference? get carrier => _carrier;
  bool hasCarrier() => _carrier != null;

  // "owner_rate" field.
  double? _ownerRate;
  double get ownerRate => _ownerRate ?? 0.0;
  bool hasOwnerRate() => _ownerRate != null;

  // "responses" field.
  List<ResponseStruct>? _responses;
  List<ResponseStruct> get responses => _responses ?? const [];
  bool hasResponses() => _responses != null;

  // "carriers" field.
  List<DocumentReference>? _carriers;
  List<DocumentReference> get carriers => _carriers ?? const [];
  bool hasCarriers() => _carriers != null;

  // "completedBy" field.
  DocumentReference? _completedBy;
  DocumentReference? get completedBy => _completedBy;
  bool hasCompletedBy() => _completedBy != null;

  // "reviewByDiller" field.
  DocumentReference? _reviewByDiller;
  DocumentReference? get reviewByDiller => _reviewByDiller;
  bool hasReviewByDiller() => _reviewByDiller != null;

  // "reviewByCarrier" field.
  DocumentReference? _reviewByCarrier;
  DocumentReference? get reviewByCarrier => _reviewByCarrier;
  bool hasReviewByCarrier() => _reviewByCarrier != null;

  // "reviewByCarrier" field.
  DocumentReference? _disputCreatedBy;
  DocumentReference? get disputCreatedBy => _disputCreatedBy;
  bool hasdisputCreatedBy() => _disputCreatedBy != null;

  // "created_time" field.
  DateTime? _geoRequestDate;
  DateTime? get geoRequestDate => _geoRequestDate;
  bool hasgeoRequestDate() => _geoRequestDate != null;

  // "location" field.
  LatLng? _requestLocation;
  LatLng? get requestLocation => _requestLocation;
  bool hasrequestLocation() => _requestLocation != null;

   // "price" field.
  int? _payTokenValue;
  int get payTokenValue => _payTokenValue ?? 0;
  bool haspayTokenValue() => _payTokenValue != null;

  DocumentReference? _cancelReason;
  DocumentReference? get cancelReason => _cancelReason;
  bool hascancelReason() => _cancelReason != null;

  void _initializeFields() {
    _carName = snapshotData['car_name'] as String?;
    _carNumber = snapshotData['car_number'] as String?;
    _carPhotos = getDataList(snapshotData['car_photos']);
    _description = snapshotData['description'] as String?;
    _locationAddress = snapshotData['location_address'] as String?;
    _location = snapshotData['location'] as LatLng?;
    _auction = snapshotData['auction'] as DocumentReference?;
    _dealDate = snapshotData['deal_date'] as DateTime?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _price = castToType<int>(snapshotData['price']);
    _payType = snapshotData['pay_type'] as String?;
    _files = getDataList(snapshotData['files']);
    _status = deserializeEnum<DealStatus>(snapshotData['status']);
    _owner = snapshotData['owner'] as DocumentReference?;
    _carrier = snapshotData['carrier'] as DocumentReference?;
    _ownerRate = castToType<double>(snapshotData['owner_rate']);
    _responses = getStructList(
      snapshotData['responses'],
      ResponseStruct.fromMap,
    );
    _carriers = getDataList(snapshotData['carriers']);
    _completedBy = snapshotData['completed_by'] as DocumentReference?;
    _reviewByDiller = snapshotData['review_by_diller'] as DocumentReference?;
    _reviewByCarrier = snapshotData['review_by_carrier'] as DocumentReference?;
    _disputCreatedBy = snapshotData['disput_created_by'] as DocumentReference?;
    _geoRequestDate = snapshotData['geo_request_date'] as DateTime?;
    _requestLocation = snapshotData['request_location'] as LatLng?;
    _payTokenValue = castToType<int>(snapshotData['pay_token_value']);
     _cancelReason = snapshotData['cancel_reason'] as DocumentReference?;
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('deals');

  static Stream<DealsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DealsRecord.fromSnapshot(s));

  static Future<DealsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DealsRecord.fromSnapshot(s));

  static DealsRecord fromSnapshot(DocumentSnapshot snapshot) => DealsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DealsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DealsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() => 'DealsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) => other is DealsRecord && reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDealsRecordData({
  String? carName,
  String? carNumber,
  String? description,
  String? locationAddress,
  LatLng? location,
  DocumentReference? auction,
  DateTime? dealDate,
  DateTime? createdTime,
  int? price,
  String? payType,
  DealStatus? status,
  DocumentReference? owner,
  DocumentReference? carrier,
  double? ownerRate,
  DocumentReference? completedBy,
  DocumentReference? reviewByDiller,
  DocumentReference? reviewByCarrier,
  DocumentReference? disputCreatedBy,
  LatLng? requestLocation,
  DateTime? geoRequestDate,
  int? payTokenValue,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'car_name': carName,
      'car_number': carNumber,
      'description': description,
      'location_address': locationAddress,
      'location': location,
      'auction': auction,
      'deal_date': dealDate,
      'created_time': createdTime,
      'price': price,
      'pay_type': payType,
      'status': status,
      'owner': owner,
      'carrier': carrier,
      'owner_rate': ownerRate,
      'completed_by': completedBy,
      'review_by_diller': reviewByDiller,
      'review_by_carrier': reviewByCarrier,
      'disput_created_by': disputCreatedBy,
      'request_location': requestLocation,
      'geo_request_date': geoRequestDate,
      'pay_token_value': payTokenValue,
    }.withoutNulls,
  );

  return firestoreData;
}

class DealsRecordDocumentEquality implements Equality<DealsRecord> {
  const DealsRecordDocumentEquality();

  @override
  bool equals(DealsRecord? e1, DealsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.carName == e2?.carName &&
        listEquality.equals(e1?.carPhotos, e2?.carPhotos) &&
        e1?.description == e2?.description &&
        e1?.locationAddress == e2?.locationAddress &&
        e1?.location == e2?.location &&
        e1?.auction == e2?.auction &&
        e1?.dealDate == e2?.dealDate &&
        e1?.createdTime == e2?.createdTime &&
        e1?.price == e2?.price &&
        e1?.payType == e2?.payType &&
        listEquality.equals(e1?.files, e2?.files) &&
        e1?.status == e2?.status &&
        e1?.owner == e2?.owner &&
        e1?.carrier == e2?.carrier &&
        e1?.ownerRate == e2?.ownerRate &&
        listEquality.equals(e1?.responses, e2?.responses);
  }

  @override
  int hash(DealsRecord? e) => const ListEquality().hash([
        e?.carName,
        e?.carPhotos,
        e?.description,
        e?.locationAddress,
        e?.location,
        e?.auction,
        e?.dealDate,
        e?.createdTime,
        e?.price,
        e?.payType,
        e?.files,
        e?.status,
        e?.owner,
        e?.carrier,
        e?.ownerRate,
        e?.responses
      ]);

  @override
  bool isValidKey(Object? o) => o is DealsRecord;
}
