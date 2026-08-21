import 'dart:io' show Platform;

import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/backend/push_notifications/serialization_util.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '../cloud_functions/cloud_functions.dart';

import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

export 'push_notifications_handler.dart';
export 'serialization_util.dart';

const kUserPushNotificationsCollectionName = 'ff_user_push_notifications';

class UserTokenInfo {
  const UserTokenInfo(this.userPath, this.fcmToken);
  final String userPath;
  final String fcmToken;
}

Stream<UserTokenInfo> getFcmTokenStream(String userPath) =>
    Stream.value(!kIsWeb && (Platform.isIOS || Platform.isAndroid))
        .where((shouldGetToken) => shouldGetToken)
        .asyncMap<String?>((_) => FirebaseMessaging.instance.requestPermission().then(
              (settings) => settings.authorizationStatus == AuthorizationStatus.authorized
                  ? FirebaseMessaging.instance.getToken()
                  : null,
            ))
        .switchMap((fcmToken) => Stream.value(fcmToken).merge(FirebaseMessaging.instance.onTokenRefresh))
        .where((fcmToken) => fcmToken != null && fcmToken.isNotEmpty)
        .map((token) => UserTokenInfo(userPath, token!));
final fcmTokenUserStream = authenticatedUserStream
    .where((user) => user != null)
    .map((user) => user!.reference.path)
    .distinct()
    .switchMap(getFcmTokenStream)
    .map(
      (userTokenInfo) => makeCloudCall(
        'addFcmToken',
        {
          'userDocPath': userTokenInfo.userPath,
          'fcmToken': userTokenInfo.fcmToken,
          'deviceType': Platform.isIOS ? 'iOS' : 'Android',
        },
      ),
    );

void triggerPushNotification({
  required String? notificationTitle,
  required String? notificationText,
  String? notificationImageUrl,
  DateTime? scheduledTime,
  String? notificationSound,
  required List<DocumentReference> userRefs,
  required String initialPageName,
  required Map<String, dynamic> parameterData,
}) {
  if ((notificationTitle ?? '').isEmpty || (notificationText ?? '').isEmpty) {
    return;
  }
  final serializedParameterData = serializeParameterData(parameterData);
  final pushNotificationData = {
    'notification_title': notificationTitle,
    'notification_text': notificationText,
    if (notificationImageUrl != null) 'notification_image_url': notificationImageUrl,
    if (scheduledTime != null) 'scheduled_time': scheduledTime,
    if (notificationSound != null) 'notification_sound': notificationSound,
    'user_refs': userRefs.map((u) => u.path).join(','),
    'initial_page_name': initialPageName,
    'parameter_data': serializedParameterData,
    'sender': currentUserReference,
    'timestamp': DateTime.now(),
  };
  FirebaseFirestore.instance.collection(kUserPushNotificationsCollectionName).doc().set(pushNotificationData);
}

class NotificationService {
  //при отклике
  static void onCarrierResponse(
    DocumentReference dillerRef,
    DocumentReference dealRef,
  ) async {
    triggerPushNotification(
      notificationText: 'Новый отклик!',
      notificationTitle: 'Перевозчик откликнулся на ваш заказ',
      initialPageName: 'DealDetailDiller',
      userRefs: [dillerRef],
      notificationSound: 'default',
      parameterData: {"dealRef": dealRef},
    );
  }

  //при отклонении отклика диллером
  static void onDillerRejectResponse(
    DocumentReference carrierRef,
    DocumentReference dealRef,
  ) async {
    triggerPushNotification(
      notificationText: 'Ваш отклик отклонен!',
      notificationTitle: 'Диллер отклонил ваш отклик',
      initialPageName: 'DealDetailCarrier',
      userRefs: [carrierRef],
      notificationSound: 'default',
      parameterData: {"dealRef": dealRef},
    );
  }

  //при принятии отклика диллером
  static void onDillerAcceptResponse(
    DocumentReference carrierRef,
    DocumentReference dealRef,
  ) async {
    triggerPushNotification(
      notificationText: 'Ваш отклик принят!',
      notificationTitle: 'Диллер принял ваш отклик',
      initialPageName: 'DealDetailCarrier',
      userRefs: [carrierRef],
      notificationSound: 'default',
      parameterData: {"dealRef": dealRef},
    );
  }

  //при отклонении отклика перевозчиком
  static void onCarrierRejectDeal(
    DocumentReference dillerRef,
    DocumentReference dealRef,
  ) async {
    triggerPushNotification(
      notificationText: 'Перевозчик отклонил предложение!',
      notificationTitle: 'Перевозчик отклонил ранее принятый отклик',
      initialPageName: 'DealDetailDiller',
      userRefs: [dillerRef],
      notificationSound: 'default',
      parameterData: {"dealRef": dealRef},
    );
  }

  //при принятии отклика перевозчиком
  static void onCarrierAcceptDeal(
    DocumentReference dillerRef,
    DocumentReference dealRef,
  ) async {
    triggerPushNotification(
      notificationText: 'Перевозчик принял предложение!',
      notificationTitle: 'Ваш заказ был принят перевозчиком',
      initialPageName: 'DealDetailDiller',
      userRefs: [dillerRef],
      notificationSound: 'default',
      parameterData: {"dealRef": dealRef},
    );
  }

  //при завершении сделки диллером
  static void onDillerCompleteDeal(
    DocumentReference carrierRef,
    DocumentReference dealRef,
  ) async {
    triggerPushNotification(
      notificationText: 'Диллер завершил сделку!',
      notificationTitle: 'Подтвердите завершение сделки',
      initialPageName: 'DealDetailCarrier',
      userRefs: [carrierRef],
      notificationSound: 'default',
      parameterData: {"dealRef": dealRef},
    );
  }

  //при завершении сделки перевозчиком
  static void onCarrierCompleteDeal(
    DocumentReference dillerRef,
    DocumentReference dealRef,
  ) async {
    triggerPushNotification(
      notificationText: 'Перевозчик завершил сделку!',
      notificationTitle: 'Подтвердите завершение сделки',
      initialPageName: 'DealDetailCarrier',
      userRefs: [dillerRef],
      notificationSound: 'default',
      parameterData: {"dealRef": dealRef},
    );
  }

  //при сообщении
  static void onMessage(
    DocumentReference userRef,
    DocumentReference chatRef,
    String text,
  ) async {
    triggerPushNotification(
      notificationText: 'Новое сообщение',
      notificationTitle: text,
      initialPageName: 'ChatRoomPage',
      userRefs: [userRef],
      notificationSound: 'default',
      parameterData: {"chatRef": chatRef},
    );
  }

  //при модерации
  static void onModerationDeal(
    DocumentReference userRef,
    DocumentReference dealRef,
  ) async {
    triggerPushNotification(
      notificationText: 'Ваш заказ был отклонен',
      notificationTitle: 'Узнайте причину отклонения',
      initialPageName: 'DealDetailDiller',
      userRefs: [userRef],
      notificationSound: 'default',
      parameterData: {"dealRef": dealRef},
    );
  }
}
