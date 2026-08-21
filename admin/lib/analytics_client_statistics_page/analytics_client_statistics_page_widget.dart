// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:auto_deal_admin/chat_page/chat_page_widget.dart';
import 'package:auto_deal_admin/flutter_flow/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../backend/schema/enums/enums.dart';
import '/backend/backend.dart';
import '/components/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'analytics_client_statistics_page_model.dart';
export 'analytics_client_statistics_page_model.dart';

class ClientModel {
  final UsersRecord user;
  final double purchasedTokens;
  final double purchasedTokensPrice;
  final double totalEarnMoney;

  ClientModel(
      {required this.user,
      required this.purchasedTokens,
      required this.purchasedTokensPrice,
      required this.totalEarnMoney});
}

enum ClientFilter { earnDown, earnUp }

@RoutePage()
class AnalyticsClientStatisticsPageWidget extends StatefulWidget {
  const AnalyticsClientStatisticsPageWidget({super.key});

  @override
  State<AnalyticsClientStatisticsPageWidget> createState() => _AnalyticsClientStatisticsPageWidgetState();
}

class _AnalyticsClientStatisticsPageWidgetState extends State<AnalyticsClientStatisticsPageWidget> {
  late AnalyticsClientStatisticsPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();
  bool loading = true;
  List<ClientModel> clients = [];
  List<UsersRecord> users = [];
  DateTime? filterFrom;
  DateTime? filterTo;
  ClientFilter? clientFilter;
  final DateTime min = DateTime(2024, 1, 1);
  final DateTime max = DateTime(2040, 1, 1);

  void init() async {
    setState(() {
      clients.clear();
      loading = true;
    });
    try {
      final resultUsers = await queryUsersRecordOnce(
        queryBuilder: (q) => q.where('banned', isEqualTo: false).where('profile_filled', isEqualTo: true),
      );

      users = resultUsers;

      for (var user in resultUsers) {
        if (user.type == UserType.Carrier) {
          final resultTransactions = await queryTransactionsRecordOnce(
            queryBuilder: (q) {
              q = q
                  .where('user_ref', isEqualTo: user.reference)
                  .where('type', isEqualTo: 'response')
                  .where('created_time', isGreaterThanOrEqualTo: filterFrom ?? min)
                  .where('created_time', isLessThanOrEqualTo: filterTo ?? max);

              return q;
            },
          );

          final resultPurchasedTransactions = await queryTransactionsRecordOnce(
            queryBuilder: (q) {
              q = q.where('user_ref', isEqualTo: user.reference).where('type', isEqualTo: 'popup').limit(1);
              return q;
            },
          );

          double purchasedTokensPrice = 0.0;

          if (resultPurchasedTransactions.isNotEmpty) {
            purchasedTokensPrice =
                resultPurchasedTransactions.first.amountPrice / resultPurchasedTransactions.first.amount;
          }

          print('Carrier purchasedTokensPrice : $purchasedTokensPrice');

          final double purchasedTokens =
              resultTransactions.isEmpty ? 0 : resultTransactions.map((e) => e.amount).reduce((v, e) => v + e);
          final double purchasedTokensPriceAll = purchasedTokens * purchasedTokensPrice;

          print('Carrier purchasedTokensPriceAll : $purchasedTokensPriceAll');
          clients.add(ClientModel(
            user: user,
            purchasedTokens: purchasedTokens,
            purchasedTokensPrice: purchasedTokensPriceAll,
            totalEarnMoney: user.carrierTotalEarning,
          ));
        } else {
          final resultTransactions = await queryTransactionsRecordOnce(
            queryBuilder: (q) {
              q = q
                  .where('user_ref', isEqualTo: user.reference)
                  .where('type', isEqualTo: 'publication')
                  .where('created_time', isGreaterThanOrEqualTo: filterFrom ?? min)
                  .where('created_time', isLessThanOrEqualTo: filterTo ?? max);

              return q;
            },
          );

          final resultPurchasedTransactions = await queryTransactionsRecordOnce(
            queryBuilder: (q) {
              q = q.where('user_ref', isEqualTo: user.reference).where('type', isEqualTo: 'popup').limit(1);
              return q;
            },
          );

          double purchasedTokensPrice = 0.0;

          if (resultPurchasedTransactions.isNotEmpty) {
            purchasedTokensPrice =
                resultPurchasedTransactions.first.amountPrice / resultPurchasedTransactions.first.amount;
          }

          print('Diller purchasedTokensPrice : $purchasedTokensPrice');

          final double purchasedTokens =
              resultTransactions.isEmpty ? 0 : resultTransactions.map((e) => e.amount).reduce((v, e) => v + e);
          final double purchasedTokensPriceAll = purchasedTokens * purchasedTokensPrice;

          print('Diller purchasedTokensPriceAll : $purchasedTokensPriceAll');
          clients.add(ClientModel(
            user: user,
            purchasedTokens: purchasedTokens,
            purchasedTokensPrice: purchasedTokensPriceAll,
            totalEarnMoney: 0,
          ));
        }
      }

      print('clients: ${clients.length}');

      clients.forEach((s) {
        print(
            'User: ${s.user.displayName} | purchasedTokens: ${s.purchasedTokens} | purchasedTokensPrice: ${s.purchasedTokensPrice}');
      });
      setState(() {
        loading = false;
      });
    } catch (e) {
      print('init error: $e');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AnalyticsClientStatisticsPageModel());
    init();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void onDateFilterTap() async {
    DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(20200),
      builder: (context, child) {
        return SizedBox(width: 500, height: 400, child: child);
      },
      confirmText: 'Сохранить',
      cancelText: 'Отменить',
      saveText: 'Сохранить',
      locale: const Locale.fromSubtags(languageCode: 'ru'),
    );

    if (range == null) return;

    setState(() {
      filterFrom = range.start;
      filterTo = range.end;
    });
    init();
  }

  void onEarnSortTap(ClientFilter? f) {
    if (f == ClientFilter.earnDown) {
      clients.sort((a, b) => b.totalEarnMoney.compareTo(a.totalEarnMoney));
    } else {
      clients.sort((a, b) => a.totalEarnMoney.compareTo(b.totalEarnMoney));
    }
    setState(() {
      clientFilter = f!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wrapWithModel(
              model: _model.appBarModel,
              updateCallback: () => setState(() {}),
              child: const AppBarWidget(
                pageName: 'АНАЛИТИКА. СТАТИСТИКА ПО КЛИЕНТАМ',
              ),
            ),
            loading
                ? const Expanded(
                    child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator())))
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(50.0, 46.0, 60.0, 40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Новые пользователи',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          topWidgets(),
                          dateFilter(),
                          tableHeader(),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: clients.length,
                              itemBuilder: (context, listViewIndex) {
                                final item = clients[listViewIndex];
                                final listViewUsersRecord = item.user;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    border: Border.all(
                                      color: const Color(0xFFE9E9E9),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushRoute(ComplaintUserPageWidgetRoute(
                                        user: listViewUsersRecord,
                                        appBarText: 'АНАЛИТИКА. СТАТИСТИКА ПО КЛИЕНТАМ. ПРОФИЛЬ',
                                        complainsRecord: null,
                                      ));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 52.0,
                                          decoration: const BoxDecoration(),
                                          child: Align(
                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 26.0, 0.0, 26.0),
                                              child: Text(
                                                (listViewIndex + 1).toString(),
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Inter',
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 12.0, 0.0),
                                                  child: UserAvatar(avatar: listViewUsersRecord.photoUrl, size: 36)),
                                              Text(
                                                '${listViewUsersRecord.displayName}${listViewUsersRecord.lastName}',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Inter',
                                                      fontSize: 16.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 130.0,
                                          decoration: const BoxDecoration(),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              item.purchasedTokens.toString(),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 222.0,
                                          decoration: const BoxDecoration(),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(28.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              item.purchasedTokensPrice.toString(),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 169.0,
                                          decoration: const BoxDecoration(),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(28.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              listViewUsersRecord.balance.toString(),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 168.0,
                                          decoration: const BoxDecoration(),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(28.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              item.totalEarnMoney.toString(),
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget tableHeader() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 0.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          border: Border.all(
            color: const Color(0xFFE9E9E9),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20.0, 15.0, 20.0, 15.0),
              child: Text(
                '№',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).hintText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
                child: Text(
                  'Ф.И.О.',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).hintText,
                        fontSize: 12.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 33.0, 0.0),
              child: Text(
                'Потрачено \nвн.валюты, \$',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).hintText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 58.0, 0.0),
              child: Text(
                'Потраченная сумма на \nвн. валюту, \$',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).hintText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 62.0, 0.0),
              child: Text(
                'Остаток\nвн.валюты, \$',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).hintText,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(
              width: 200.0,
              height: 40.0,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<ClientFilter>(
                  isExpanded: true,
                  buttonStyleData: ButtonStyleData(
                    overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                  ),
                  items: ClientFilter.values
                      .map((e) => DropdownMenuItem<ClientFilter>(
                            value: e,
                            child: Text(
                              getClientFilterText(e),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ))
                      .toList(),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                      ),
                  customButton: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          clientFilter == null ? 'Заработанная\n сумма, \$' : getClientFilterText(clientFilter!),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: clientFilter == null
                                    ? FlutterFlowTheme.of(context).hintText
                                    : FlutterFlowTheme.of(context).primaryText,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Icon(
                        Icons.swap_vert_sharp,
                        color: FlutterFlowTheme.of(context).hintText,
                        size: 25.0,
                      ),
                    ],
                  ),
                  value: clientFilter,
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFFA9A9AA),
                      size: 24.0,
                    ),
                  ),
                  onChanged: onEarnSortTap,
                  dropdownStyleData: DropdownStyleData(
                    elevation: 2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 36,
                  ),
                ),
              ),
            ),
            // FlutterFlowDropDown<ClientFilter>(
            //   controller: FormFieldController<ClientFilter>(clientFilter),
            //   options: ClientFilter.values,
            //   optionLabels: ClientFilter.values.map((e) => getClientFilterText(e)).toList(),
            //   onChanged: onEarnSortTap,
            //   width: 168.0,
            //   height: 40.0,
            //   textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
            //         fontFamily: 'Inter',
            //         color: FlutterFlowTheme.of(context).hintText,
            //         fontSize: 12.0,
            //         letterSpacing: 0.0,
            //         fontWeight: FontWeight.w600,
            //       ),
            //   hintText: 'Заработанная\n сумма, \$',
            //   icon: Icon(
            //     Icons.swap_vert_sharp,
            //     color: FlutterFlowTheme.of(context).hintText,
            //     size: 25.0,
            //   ),
            //   fillColor: FlutterFlowTheme.of(context).primaryBackground,
            //   elevation: 0.0,
            //   borderColor: Colors.transparent,
            //   borderWidth: 0.0,
            //   borderRadius: 0.0,
            //   margin: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            //   hidesUnderline: true,
            //   isOverButton: false,
            //   isSearchable: false,
            //   isMultiSelect: false,
            //   labelText: '',
            //   labelTextStyle: FlutterFlowTheme.of(context).labelMedium.override(
            //         fontFamily: 'Inter',
            //         color: FlutterFlowTheme.of(context).primaryText,
            //         fontSize: 12.0,
            //         letterSpacing: 0.0,
            //         fontWeight: FontWeight.w600,
            //       ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget dateFilter() {
    return Align(
      alignment: const AlignmentDirectional(1.0, 0.0),
      child: GestureDetector(
        onTap: onDateFilterTap,
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                child: Text(
                  (filterFrom != null && filterTo != null)
                      ? '${DateFormat('dd.MM.yyyy').format(filterFrom!)} - ${DateFormat('dd.MM.yyyy').format(filterTo!)}'
                      : 'За все время',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Opacity(
                opacity: 0.9,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 3.0, 12.0, 3.0),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topWidgets() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 28.0, 0.0, 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 142.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [FlutterFlowTheme.of(context).yellowGradient2, FlutterFlowTheme.of(context).yellowGradient1],
                  stops: const [0.0, 1.0],
                  begin: const AlignmentDirectional(1.0, -0.98),
                  end: const AlignmentDirectional(-1.0, 0.98),
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 0.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'День',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      newUsersToday().toString(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 40.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
              child: Container(
                height: 142.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).yellowGradient2,
                      FlutterFlowTheme.of(context).yellowGradient1
                    ],
                    stops: const [0.0, 1.0],
                    begin: const AlignmentDirectional(1.0, -0.98),
                    end: const AlignmentDirectional(-1.0, 0.98),
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Image.asset('assets/images/chart.png'),
                        )),
                    Container(
                      height: 142.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context).yellowGradient2.withOpacity(0.8),
                            FlutterFlowTheme.of(context).yellowGradient1.withOpacity(0.8)
                          ],
                          stops: const [0.0, 1.0],
                          begin: const AlignmentDirectional(1.0, -0.98),
                          end: const AlignmentDirectional(-1.0, 0.98),
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 0.0, 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Месяц',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            newUsersThisMonth().toString(),
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  fontSize: 40.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 142.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [FlutterFlowTheme.of(context).yellowGradient2, FlutterFlowTheme.of(context).yellowGradient1],
                  stops: const [0.0, 1.0],
                  begin: const AlignmentDirectional(1.0, -0.98),
                  end: const AlignmentDirectional(-1.0, 0.98),
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 0.0, 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Год',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      newUsersThisYear().toString(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 40.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int newUsersToday() => users
      .where((user) =>
          user.createdTime?.year == now.year &&
          user.createdTime?.month == now.month &&
          user.createdTime?.day == now.day)
      .length;

  // Новые пользователи за месяц
  int newUsersThisMonth() =>
      users.where((user) => user.createdTime?.year == now.year && user.createdTime?.month == now.month).length;

  // Новые пользователи за год
  int newUsersThisYear() => users.where((user) => user.createdTime?.year == now.year).length;

  String getClientFilterText(ClientFilter f) {
    return f == ClientFilter.earnDown ? 'По убыванию' : 'По возрастанию';
  }
}
