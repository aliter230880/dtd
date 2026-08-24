import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
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

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "type" field.
  UserType? _type;
  UserType? get type => _type;
  bool hasType() => _type != null;

  // "balance" field.
  double? _balance;
  double get balance => _balance ?? 0.0;
  bool hasBalance() => _balance != null;

  // "rate" field.
  double? _rate;
  double get rate => _rate ?? 0.0;
  bool hasRate() => _rate != null;

  // "rate" field.
  int? _rateCount;
  int get rateCount => _rateCount ?? 0;
  bool hasRateCount() => _rateCount != null;

  // "profile_filled" field.
  bool? _profileFilled;
  bool get profileFilled => _profileFilled ?? false;
  bool hasProfileFilled() => _profileFilled != null;

  // "carrier_company_name" field.
  String? _carrierCompanyName;
  String get carrierCompanyName => _carrierCompanyName ?? '';
  bool hasCarrierCompanyName() => _carrierCompanyName != null;

  // "carrier_number" field.
  String? _carrierNumber;
  String get carrierNumber => _carrierNumber ?? '';
  bool hasCarrierNumber() => _carrierNumber != null;

  // "carrier_driver_license" field.
  String? _carrierDriverLicense;
  String get carrierDriverLicense => _carrierDriverLicense ?? '';
  bool hasCarrierDriverLicense() => _carrierDriverLicense != null;

  // "file" field.
  String? _file;
  String get file => _file ?? '';
  bool hasFile() => _file != null;

  // "diller_license" field.
  String? _dillerLicense;
  String get dillerLicense => _dillerLicense ?? '';
  bool hasDillerLicense() => _dillerLicense != null;

  // "diller_driver_license" field.
  String? _dillerDriverLicense;
  String get dillerDriverLicense => _dillerDriverLicense ?? '';
  bool hasDillerDriverLicense() => _dillerDriverLicense != null;

  // "diller_driver_date" field.
  DateTime? _dillerDriverDate;
  DateTime? get dillerDriverDate => _dillerDriverDate;
  bool hasDillerDriverDate() => _dillerDriverDate != null;

  // "diller_cars" field.
  List<String>? _dillerCars;
  List<String> get dillerCars => _dillerCars ?? const [];
  bool hasDillerCars() => _dillerCars != null;

  // "banned" field.
  bool? _banned;
  bool get banned => _banned ?? false;
  bool hasBanned() => _banned != null;

  // "banned_time" field.
  DateTime? _bannedTime;
  DateTime? get bannedTime => _bannedTime;
  bool hasBannedTime() => _bannedTime != null;

  int? _freeDealCount;
  int get freeDealCount => _freeDealCount ?? 0;
  bool hasfreeDealCount() => _freeDealCount != null;

  int? _freeResponseCount;
  int get freeResponseCount => _freeResponseCount ?? 0;
  bool hasfreeResponseCount() => _freeResponseCount != null;

  double? _carrierTotalEarning;
  double get carrierTotalEarning => _carrierTotalEarning ?? 0.0;

  // "verified" field.
  bool? _verified;
  bool get verified => _verified ?? false;
  bool hasVerified() => _verified != null;

  // "verification_status" field.
  String? _verificationStatus;
  String get verificationStatus => _verificationStatus ?? '';
  bool hasVerificationStatus() => _verificationStatus != null;

  // "verification_date" field.
  DateTime? _verificationDate;
  DateTime? get verificationDate => _verificationDate;
  bool hasVerificationDate() => _verificationDate != null;

  // "verification_expired" field.
  bool? _verificationExpired;
  bool get verificationExpired => _verificationExpired ?? false;
  bool hasVerificationExpired() => _verificationExpired != null;

  // "dot_number" field.
  String? _dotNumber;
  String get dotNumber => _dotNumber ?? '';
  bool hasDotNumber() => _dotNumber != null;

  // "mc_number" field.
  String? _mcNumber;
  String get mcNumber => _mcNumber ?? '';
  bool hasMcNumber() => _mcNumber != null;

  // "company_legal_name" field.
  String? _companyLegalName;
  String get companyLegalName => _companyLegalName ?? '';
  bool hasCompanyLegalName() => _companyLegalName != null;

  // "fmcsa_safety_rating" field.
  String? _fmcsaSafetyRating;
  String get fmcsaSafetyRating => _fmcsaSafetyRating ?? '';
  bool hasFmcsaSafetyRating() => _fmcsaSafetyRating != null;

  // "fmcsa_authority_status" field.
  String? _fmcsaAuthorityStatus;
  String get fmcsaAuthorityStatus => _fmcsaAuthorityStatus ?? '';
  bool hasFmcsaAuthorityStatus() => _fmcsaAuthorityStatus != null;

  // "fmcsa_address" field.
  String? _fmcsaAddress;
  String get fmcsaAddress => _fmcsaAddress ?? '';
  bool hasFmcsaAddress() => _fmcsaAddress != null;

  // "dealer_license_number" field.
  String? _dealerLicenseNumber;
  String get dealerLicenseNumber => _dealerLicenseNumber ?? '';
  bool hasDealerLicenseNumber() => _dealerLicenseNumber != null;

  // "dealer_license_state" field.
  String? _dealerLicenseState;
  String get dealerLicenseState => _dealerLicenseState ?? '';
  bool hasDealerLicenseState() => _dealerLicenseState != null;

  // "verification_rejection_reason" field.
  String? _verificationRejectionReason;
  String get verificationRejectionReason => _verificationRejectionReason ?? '';
  bool hasVerificationRejectionReason() => _verificationRejectionReason != null;

  // "verification_document_urls" field.
  List<String>? _verificationDocumentUrls;
  List<String> get verificationDocumentUrls => _verificationDocumentUrls ?? const [];
  bool hasVerificationDocumentUrls() => _verificationDocumentUrls != null;

  // "verification_request_date" field.
  DateTime? _verificationRequestDate;
  DateTime? get verificationRequestDate => _verificationRequestDate;
  bool hasVerificationRequestDate() => _verificationRequestDate != null;

  // "verification_admin_id" field.
  String? _verificationAdminId;
  String get verificationAdminId => _verificationAdminId ?? '';
  bool hasVerificationAdminId() => _verificationAdminId != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _type = deserializeEnum<UserType>(snapshotData['type']);
    _balance = castToType<double>(snapshotData['balance']);
    _rate = castToType<double>(snapshotData['rate']);
    _rateCount = snapshotData['rate_count'] as int?;
    _profileFilled = snapshotData['profile_filled'] as bool?;
    _carrierCompanyName = snapshotData['carrier_company_name'] as String?;
    _carrierNumber = snapshotData['carrier_number'] as String?;
    _carrierDriverLicense = snapshotData['carrier_driver_license'] as String?;
    _file = snapshotData['file'] as String?;
    _dillerLicense = snapshotData['diller_license'] as String?;
    _dillerDriverLicense = snapshotData['diller_driver_license'] as String?;
    _dillerDriverDate = snapshotData['diller_driver_date'] as DateTime?;
    _dillerCars = getDataList(snapshotData['diller_cars']);
    _banned = snapshotData['banned'] as bool?;
    _bannedTime = snapshotData['banned_time'] as DateTime?;
    _freeDealCount = castToType<int>(snapshotData['free_deal_count']);
    _freeResponseCount = castToType<int>(snapshotData['free_response_count']);
    _carrierTotalEarning = castToType<double>(snapshotData['carrier_total_earning']);
    _verified = snapshotData['verified'] as bool?;
    _verificationStatus = snapshotData['verification_status'] as String?;
    _verificationDate = snapshotData['verification_date'] as DateTime?;
    _verificationExpired = snapshotData['verification_expired'] as bool?;
    _dotNumber = snapshotData['dot_number'] as String?;
    _mcNumber = snapshotData['mc_number'] as String?;
    _companyLegalName = snapshotData['company_legal_name'] as String?;
    _fmcsaSafetyRating = snapshotData['fmcsa_safety_rating'] as String?;
    _fmcsaAuthorityStatus = snapshotData['fmcsa_authority_status'] as String?;
    _fmcsaAddress = snapshotData['fmcsa_address'] as String?;
    _dealerLicenseNumber = snapshotData['dealer_license_number'] as String?;
    _dealerLicenseState = snapshotData['dealer_license_state'] as String?;
    _verificationRejectionReason = snapshotData['verification_rejection_reason'] as String?;
    _verificationDocumentUrls = getDataList(snapshotData['verification_document_urls']);
    _verificationRequestDate = snapshotData['verification_request_date'] as DateTime?;
    _verificationAdminId = snapshotData['verification_admin_id'] as String?;
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() => 'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) => other is UsersRecord && reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  UserType? type,
  double? balance,
  double? rate,
  int? rateCount,
  bool? profileFilled,
  String? carrierCompanyName,
  String? carrierNumber,
  String? carrierDriverLicense,
  String? file,
  String? dillerLicense,
  String? dillerDriverLicense,
  DateTime? dillerDriverDate,
  bool? banned,
  DateTime? bannedTime,
  int? freeDealCount,
  int? freeResponseCount,
  double? carrierTotalEarning,
  bool? verified,
  String? verificationStatus,
  DateTime? verificationDate,
  bool? verificationExpired,
  String? dotNumber,
  String? mcNumber,
  String? companyLegalName,
  String? fmcsaSafetyRating,
  String? fmcsaAuthorityStatus,
  String? fmcsaAddress,
  String? dealerLicenseNumber,
  String? dealerLicenseState,
  String? verificationRejectionReason,
  DateTime? verificationRequestDate,
  String? verificationAdminId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'type': type,
      'balance': balance,
      'rate': rate,
      'rate_count': rateCount,
      'profile_filled': profileFilled,
      'carrier_company_name': carrierCompanyName,
      'carrier_number': carrierNumber,
      'carrier_driver_license': carrierDriverLicense,
      'file': file,
      'diller_license': dillerLicense,
      'diller_driver_license': dillerDriverLicense,
      'diller_driver_date': dillerDriverDate,
      'banned': banned,
      'banned_time': bannedTime,
      'free_deal_count': freeDealCount,
      'free_response_count': freeResponseCount,
      'carrier_total_earning': carrierTotalEarning,
      'verified': verified,
      'verification_status': verificationStatus,
      'verification_date': verificationDate,
      'verification_expired': verificationExpired,
      'dot_number': dotNumber,
      'mc_number': mcNumber,
      'company_legal_name': companyLegalName,
      'fmcsa_safety_rating': fmcsaSafetyRating,
      'fmcsa_authority_status': fmcsaAuthorityStatus,
      'fmcsa_address': fmcsaAddress,
      'dealer_license_number': dealerLicenseNumber,
      'dealer_license_state': dealerLicenseState,
      'verification_rejection_reason': verificationRejectionReason,
      'verification_request_date': verificationRequestDate,
      'verification_admin_id': verificationAdminId,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.type == e2?.type &&
        e1?.balance == e2?.balance &&
        e1?.rate == e2?.rate &&
        e1?.profileFilled == e2?.profileFilled &&
        e1?.carrierCompanyName == e2?.carrierCompanyName &&
        e1?.carrierNumber == e2?.carrierNumber &&
        e1?.carrierDriverLicense == e2?.carrierDriverLicense &&
        e1?.file == e2?.file &&
        e1?.dillerLicense == e2?.dillerLicense &&
        e1?.dillerDriverLicense == e2?.dillerDriverLicense &&
        e1?.dillerDriverDate == e2?.dillerDriverDate &&
        listEquality.equals(e1?.dillerCars, e2?.dillerCars) &&
        e1?.banned == e2?.banned &&
        e1?.bannedTime == e2?.bannedTime &&
        e1?.verified == e2?.verified &&
        e1?.verificationStatus == e2?.verificationStatus &&
        e1?.verificationDate == e2?.verificationDate &&
        e1?.verificationExpired == e2?.verificationExpired &&
        e1?.dotNumber == e2?.dotNumber &&
        e1?.mcNumber == e2?.mcNumber &&
        e1?.companyLegalName == e2?.companyLegalName &&
        e1?.fmcsaSafetyRating == e2?.fmcsaSafetyRating &&
        e1?.fmcsaAuthorityStatus == e2?.fmcsaAuthorityStatus &&
        e1?.fmcsaAddress == e2?.fmcsaAddress &&
        e1?.dealerLicenseNumber == e2?.dealerLicenseNumber &&
        e1?.dealerLicenseState == e2?.dealerLicenseState &&
        e1?.verificationRejectionReason == e2?.verificationRejectionReason &&
        listEquality.equals(e1?.verificationDocumentUrls, e2?.verificationDocumentUrls) &&
        e1?.verificationRequestDate == e2?.verificationRequestDate &&
        e1?.verificationAdminId == e2?.verificationAdminId;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.type,
        e?.balance,
        e?.rate,
        e?.profileFilled,
        e?.carrierCompanyName,
        e?.carrierNumber,
        e?.carrierDriverLicense,
        e?.file,
        e?.dillerLicense,
        e?.dillerDriverLicense,
        e?.dillerDriverDate,
        e?.dillerCars,
        e?.banned,
        e?.bannedTime,
        e?.verified,
        e?.verificationStatus,
        e?.verificationDate,
        e?.verificationExpired,
        e?.dotNumber,
        e?.mcNumber,
        e?.companyLegalName,
        e?.fmcsaSafetyRating,
        e?.fmcsaAuthorityStatus,
        e?.fmcsaAddress,
        e?.dealerLicenseNumber,
        e?.dealerLicenseState,
        e?.verificationRejectionReason,
        e?.verificationDocumentUrls,
        e?.verificationRequestDate,
        e?.verificationAdminId,
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
