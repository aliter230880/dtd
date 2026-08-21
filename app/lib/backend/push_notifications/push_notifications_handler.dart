import 'dart:async';

import 'package:bot_toast/bot_toast.dart';

import 'serialization_util.dart';
import '../backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final _handledMessageIds = <String?>{};

class PushNotificationsHandler extends StatefulWidget {
  const PushNotificationsHandler({super.key, required this.child});

  final Widget child;

  @override
  _PushNotificationsHandlerState createState() => _PushNotificationsHandlerState();
}

class _PushNotificationsHandlerState extends State<PushNotificationsHandler> {
  bool _loading = false;

  Future handleOpenedPushNotification() async {
    if (isWeb) {
      return;
    }

    final notification = await FirebaseMessaging.instance.getInitialMessage();
    if (notification != null) {
      await _handlePushNotification(notification);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handlePushNotification);

    FirebaseMessaging.onMessage.listen(_handleForegroungPushNotification);
  }

  Future _handlePushNotification(RemoteMessage message) async {
    if (_handledMessageIds.contains(message.messageId)) {
      return;
    }
    _handledMessageIds.add(message.messageId);

    if (mounted) {
      setState(() => _loading = true);
    }
    try {
      final initialPageName = message.data['initialPageName'] as String;
      final initialParameterData = getInitialParameterData(message.data);

      print('InitialPAge: $initialPageName');
      print('InitialDate: $initialParameterData');

      if (initialPageName == 'DealDetailDiller') {
        final DocumentReference? dealRef = getParameter<DocumentReference>(initialParameterData, 'dealRef');
        _onDillerDealOpen(dealRef);
      } else if (initialPageName == 'DealDetailCarrier') {
        final DocumentReference? dealRef = getParameter<DocumentReference>(initialParameterData, 'dealRef');
        _onCarrierDealOpen(dealRef);
      } else if (initialPageName == 'ChatRoomPage') {
        final DocumentReference? dealRef = getParameter<DocumentReference>(initialParameterData, 'chatRef');
        _onChatOpen(dealRef);
      } else {
        return;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future _handleForegroungPushNotification(RemoteMessage message) async {
    print('_handleForegroungPushNotification: ${message.data}');
    if (_handledMessageIds.contains(message.messageId)) {
      return;
    }
    _handledMessageIds.add(message.messageId);

    if (mounted) {
      setState(() => _loading = true);
    }
    try {
      final initialPageName = message.data['initialPageName'] as String;
      final initialParameterData = getInitialParameterData(message.data);

      print('InitialPAge: $initialPageName');
      print('InitialDate: $initialParameterData');

      if (initialPageName == 'DealDetailDiller') {
        final DocumentReference? dealRef = getParameter<DocumentReference>(initialParameterData, 'dealRef');

        ToastService.showNotificationToast(
          message.notification?.title,
          message.notification?.body,
          onTap: () => _onDillerDealOpen(dealRef),
        );
      } else if (initialPageName == 'DealDetailCarrier') {
        final DocumentReference? dealRef = getParameter<DocumentReference>(initialParameterData, 'dealRef');
        ToastService.showNotificationToast(
          message.notification?.title,
          message.notification?.body,
          onTap: () => _onDillerDealOpen(dealRef),
        );
      } else if (initialPageName == 'ChatRoomPage') {
        final ffcurrentChatRef = FFAppState().currentChatRef;
        final DocumentReference? chatRef = getParameter<DocumentReference>(initialParameterData, 'chatRef');

        if (ffcurrentChatRef != null && chatRef != null) {
          final bool isSame = ffcurrentChatRef.id == chatRef.id;
          print('isSame');
          if (isSame) return;
        }

        ToastService.showNotificationToast(
          message.notification?.title,
          message.notification?.body,
          onTap: () => _onChatOpen(chatRef),
        );
      } else {
        return;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _onDillerDealOpen(DocumentReference? dealRef) {
    if (dealRef == null) {
      return;
    }
    context.pushNamed(
      'DealDetailDiller',
      queryParameters: {
        'dealRef': serializeParam(dealRef, ParamType.DocumentReference),
      }.withoutNulls,
    );
  }

  void _onCarrierDealOpen(DocumentReference? dealRef) {
    if (dealRef == null) {
      return;
    }
    context.pushNamed(
      'DealDetailCarrier',
      queryParameters: {
        'dealRef': serializeParam(dealRef, ParamType.DocumentReference),
      }.withoutNulls,
    );
  }

  void _onChatOpen(DocumentReference? chatRef) async {
    if (chatRef == null) return;
    final chatsRecord = await ChatsRecord.getDocumentOnce(chatRef);

    if (mounted) {
      context.pushNamed(
        'ChatRoomPage',
        queryParameters: {
          'chat': serializeParam(chatsRecord, ParamType.Document),
        }.withoutNulls,
        extra: <String, dynamic>{'chat': chatsRecord},
      );
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      handleOpenedPushNotification();
    });
  }

  @override
  Widget build(BuildContext context) => _loading
      ? Container(
          color: FlutterFlowTheme.of(context).primaryText,
          child: Center(
            child: Image.asset(
              'assets/images/logo.svg',
              width: 158.0,
              height: 158.0,
              fit: BoxFit.cover,
            ),
          ),
        )
      : widget.child;
}

class ParameterData {
  const ParameterData({this.requiredParams = const {}, this.allParams = const {}});
  final Map<String, String?> requiredParams;
  final Map<String, dynamic> allParams;

  Map<String, String> get pathParameters => Map.fromEntries(
        requiredParams.entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value!)),
      );
  Map<String, dynamic> get extra => Map.fromEntries(
        allParams.entries.where((e) => e.value != null),
      );

  static Future<ParameterData> Function(Map<String, dynamic>) none() => (data) async => const ParameterData();
}

final parametersBuilderMap = <String, Future<ParameterData> Function(Map<String, dynamic>)>{
  'HomePage': ParameterData.none(),
  'onboardPage': ParameterData.none(),
  'splash_page': ParameterData.none(),
  'login_page': ParameterData.none(),
  'forgot_password_page': ParameterData.none(),
  'registration_page': ParameterData.none(),
  'fill_profile_main': ParameterData.none(),
  'fill_profile_type': ParameterData.none(),
  'fill_profile_carrier': ParameterData.none(),
  'fill_profile_diller': ParameterData.none(),
  'fill_profile_car_numbers': ParameterData.none(),
  'OrderTab': ParameterData.none(),
  'ChatTab': ParameterData.none(),
  'ProfileTab': ParameterData.none(),
  'CreateDealPage': ParameterData.none(),
  'DillerActiveDeals': ParameterData.none(),
  'DillerDisputeDeals': ParameterData.none(),
  'EditDeal': (data) async => ParameterData(
        allParams: {
          'deal': await getDocumentParameter<DealsRecord>(data, 'deal', DealsRecord.fromSnapshot),
        },
      ),
  'WalletPage': ParameterData.none(),
  'HistoryPage': (data) async => ParameterData(
        allParams: {
          'userRef': getParameter<DocumentReference>(data, 'userRef'),
        },
      ),
  'ReviewsPage': (data) async => ParameterData(
        allParams: {
          'userRef': getParameter<DocumentReference>(data, 'userRef'),
        },
      ),
  'TransactionsPage': ParameterData.none(),
  'EditProfile': ParameterData.none(),
  'EditDillerProfile1': ParameterData.none(),
  'EditDillerProfile2': ParameterData.none(),
  'EditCarrierProfile1': ParameterData.none(),
  'UserBannedPage': ParameterData.none(),
  'UserProfile': (data) async => ParameterData(
        allParams: {
          'user': getParameter<DocumentReference>(data, 'user'),
        },
      ),
  'NotificationsPage': ParameterData.none(),
  'FilterPage': ParameterData.none(),
  'FilterLocationPage': ParameterData.none(),
  'DealDetailDiller': (data) async => ParameterData(
        allParams: {
          'dealRef': getParameter<DocumentReference>(data, 'dealRef'),
        },
      ),
  'DealDetailCarrier': (data) async => ParameterData(
        allParams: {
          'dealRef': getParameter<DocumentReference>(data, 'dealRef'),
        },
      ),
  'ChatRoomPage': (data) async => ParameterData(
        allParams: {
          'chat': await getDocumentParameter<ChatsRecord>(data, 'chat', ChatsRecord.fromSnapshot),
        },
      ),
};

Map<String, dynamic> getInitialParameterData(Map<String, dynamic> data) {
  try {
    final parameterDataStr = data['parameterData'];
    if (parameterDataStr == null || parameterDataStr is! String || parameterDataStr.isEmpty) {
      return {};
    }
    return jsonDecode(parameterDataStr) as Map<String, dynamic>;
  } catch (e) {
    print('Error parsing parameter data: $e');
    return {};
  }
}

class ToastService {
  static showNotificationToast(String? title, String? body, {VoidCallback? onTap}) {
    BotToast.showCustomNotification(
      duration: const Duration(seconds: 10),
      toastBuilder: (cancelFunc) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (onTap != null) {
              onTap();
              BotToast.removeAll();
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFFAE28C),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  if (body != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        body,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      align: Alignment.topCenter,
    );
  }
}
