// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:auto_deal_admin/backend/schema/enums/enums.dart';
import 'package:auto_deal_admin/chat_page/chat_page_widget.dart';
import 'package:auto_deal_admin/flutter_flow/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';

import '/backend/backend.dart';
import '/components/app_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'analytics_summary_data_page_model.dart';
export 'analytics_summary_data_page_model.dart';

class SummaryModel {
  final UsersRecord user;
  final int allDeals;
  final int createdDeals;
  final int activeDeals;
  final int completedDeals;
  final double purchasedTokens;
  final double purchasedTokensPrice;

  SummaryModel({
    required this.user,
    required this.allDeals,
    required this.createdDeals,
    required this.activeDeals,
    required this.completedDeals,
    required this.purchasedTokens,
    required this.purchasedTokensPrice,
  });
}

enum SummaryFilter { all, create, active, completed }

@RoutePage()
class AnalyticsSummaryDataPageWidget extends StatefulWidget {
  const AnalyticsSummaryDataPageWidget({super.key});

  @override
  State<AnalyticsSummaryDataPageWidget> createState() => _AnalyticsSummaryDataPageWidgetState();
}

class _AnalyticsSummaryDataPageWidgetState extends State<AnalyticsSummaryDataPageWidget> {
  late AnalyticsSummaryDataPageModel _model;
  List<SummaryModel> summary = [];
  SummaryFilter summaryFilter = SummaryFilter.all;
  DateTime? filterFrom;
  DateTime? filterTo;
  bool loading = true;
  final DateTime min = DateTime(2024, 1, 1);
  final DateTime max = DateTime(2040, 1, 1);
  final TextEditingController _textEditingController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AnalyticsSummaryDataPageModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    init();
  }

  void init() async {
    setState(() {
      summary.clear();
      loading = true;
    });
    try {
      final resultUsers = await queryUsersRecordOnce(
        queryBuilder: (q) => q.where('banned', isEqualTo: false).where('profile_filled', isEqualTo: true),
      );

      for (var user in resultUsers) {
        if (user.type == UserType.Carrier) {
          final resultDeals = await queryDealsRecordOnce(queryBuilder: (q) {
            q = q
                .where('carrier', isEqualTo: user.reference)
                .where('created_time', isGreaterThanOrEqualTo: filterFrom ?? min)
                .where('created_time', isLessThanOrEqualTo: filterTo ?? max);

            return q;
          });

          final resultTransactions = await queryTransactionsRecordOnce(
            queryBuilder: (q) {
              q = q
                  .where('user_ref', isEqualTo: user.reference)
                  .where('type', isEqualTo: 'popup')
                  .where('created_time', isGreaterThanOrEqualTo: filterFrom ?? min)
                  .where('created_time', isLessThanOrEqualTo: filterTo ?? max);

              return q;
            },
          );

          summary.add(SummaryModel(
            user: user,
            allDeals: resultDeals.length,
            createdDeals: 0,
            activeDeals: resultDeals
                .where((deal) =>
                    deal.status == DealStatus.InActive ||
                    deal.status == DealStatus.InDispute ||
                    deal.status == DealStatus.InConfirmComplete)
                .length,
            completedDeals: resultDeals.where((deal) => deal.status == DealStatus.Canceled).length,
            purchasedTokens:
                resultTransactions.isEmpty ? 0 : resultTransactions.map((e) => e.amount).reduce((v, e) => v + e),
            purchasedTokensPrice:
                resultTransactions.isEmpty ? 0 : resultTransactions.map((e) => e.amountPrice).reduce((v, e) => v + e),
          ));
        } else {
          final resultDeals = await queryDealsRecordOnce(queryBuilder: (q) {
            q = q
                .where('owner', isEqualTo: user.reference)
                .where('created_time', isGreaterThanOrEqualTo: filterFrom ?? min)
                .where('created_time', isLessThanOrEqualTo: filterTo ?? max);
            return q;
          });

          final resultTransactions = await queryTransactionsRecordOnce(
            queryBuilder: (q) {
              q = q
                  .where('user_ref', isEqualTo: user.reference)
                  .where('type', isEqualTo: 'popup')
                  .where('created_time', isGreaterThanOrEqualTo: filterFrom ?? min)
                  .where('created_time', isLessThanOrEqualTo: filterTo ?? max);
              return q;
            },
          );

          summary.add(SummaryModel(
            user: user,
            allDeals: resultDeals.length,
            createdDeals: resultDeals.where((deal) => deal.status == DealStatus.InSearch).length,
            activeDeals: resultDeals
                .where((deal) =>
                    deal.status == DealStatus.InActive ||
                    deal.status == DealStatus.InDispute ||
                    deal.status == DealStatus.InConfirmComplete)
                .length,
            completedDeals: resultDeals.where((deal) => deal.status == DealStatus.Canceled).length,
            purchasedTokens:
                resultTransactions.isEmpty ? 0 : resultTransactions.map((e) => e.amount).reduce((v, e) => v + e),
            purchasedTokensPrice:
                resultTransactions.isEmpty ? 0 : resultTransactions.map((e) => e.amountPrice).reduce((v, e) => v + e),
          ));
        }
      }

      if (summaryFilter == SummaryFilter.all) {
        summary.sort((a, b) => b.allDeals.compareTo(a.allDeals));
      } else if (summaryFilter == SummaryFilter.create) {
        summary.sort((a, b) => b.createdDeals.compareTo(a.createdDeals));
      } else if (summaryFilter == SummaryFilter.active) {
        summary.sort((a, b) => b.activeDeals.compareTo(a.activeDeals));
      } else if (summaryFilter == SummaryFilter.completed) {
        summary.sort((a, b) => b.completedDeals.compareTo(a.completedDeals));
      }

      print('summary: ${summary.length}');

      summary.forEach((s) {
        print(
            'User: ${s.user.displayName} | ALL: ${s.allDeals} | CREATED: ${s.createdDeals} | ACTIVE: ${s.activeDeals} | COMPLETED: ${s.completedDeals}');
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
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  serachCustomButton() {
    return Container(
      height: 42,
      width: 430,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FlutterFlowTheme.of(context).primaryText),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.search, size: 22),
          const SizedBox(width: 12),
          Text(
            'Введите имя пользователя',
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: 'Inter',
                  color: const Color(0xFFBDBDBD),
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
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
                pageName: 'АНАЛИТИКА. СВОДНЫЕ ДАННЫЕ',
              ),
            ),
            loading
                ? const Expanded(
                    child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator())))
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(50.0, 46.0, 50.0, 40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 430,
                                height: 42,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<SummaryModel>(
                                    isExpanded: true,
                                    buttonStyleData: ButtonStyleData(
                                      overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                                    ),
                                    items: summary
                                        .map(
                                          (SummaryModel item) => DropdownMenuItem<SummaryModel>(
                                            value: item,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor: Colors.grey.shade200,
                                                  child: const Center(child: Icon(Icons.person, color: Colors.grey)),
                                                ),
                                                const SizedBox(width: 4),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      item.user.displayName,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Inter',
                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                            letterSpacing: 0.0,
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      item.user.email,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Inter',
                                                            color: FlutterFlowTheme.of(context).hintText,
                                                            letterSpacing: 0.0,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.normal,
                                                          ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    value: null,
                                    onChanged: (SummaryModel? value) {
                                      context.pushRoute(ComplaintUserPageWidgetRoute(
                                      user: value!.user,
                                      appBarText: 'АНАЛИТИКА. СТАТИСТИКА ПО КЛИЕНТАМ. ПРОФИЛЬ',
                                      complainsRecord: null,
                                    ));
                                    },
                                    customButton: serachCustomButton(),
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
                                    dropdownSearchData: DropdownSearchData(
                                      searchController: _textEditingController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        height: 42,
                                        color: Colors.white,
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 4,
                                          right: 16,
                                          left: 16,
                                        ),
                                        child: TextFormField(
                                          expands: true,
                                          maxLines: null,
                                          controller: _textEditingController,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Inter',
                                                letterSpacing: 0.0,
                                              ),
                                          decoration: InputDecoration(
                                            hintText: 'Поиск',
                                            isDense: true,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(color: FlutterFlowTheme.of(context).hintText)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: FlutterFlowTheme.of(context).hintText)),
                                            suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _textEditingController.clear();
                                                  });
                                                },
                                                child: const Icon(
                                                  CupertinoIcons.clear_circled_solid,
                                                )),
                                          ),
                                        ),
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return (item.value!.user.displayName)
                                            .toLowerCase()
                                            .contains(searchValue.toLowerCase());
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Align(
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
                              ),
                            ],
                          ),
                          Padding(
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
                                  SizedBox(
                                    width: 220.0,
                                    height: 44.0,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<SummaryFilter>(
                                        isExpanded: true,
                                        buttonStyleData: ButtonStyleData(
                                          overlayColor:
                                              MaterialStateProperty.resolveWith((states) => Colors.transparent),
                                        ),
                                        items: SummaryFilter.values
                                            .map((e) => DropdownMenuItem<SummaryFilter>(
                                                  value: e,
                                                  child: Text(
                                                    getSummaryFilterName(e),
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
                                                getSummaryFilterName(
                                                  summaryFilter,
                                                ),
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Inter',
                                                      color: summaryFilter == SummaryFilter.all
                                                          ? FlutterFlowTheme.of(context).hintText
                                                          : FlutterFlowTheme.of(context).primaryText,
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Color(0xFFA9A9AA),
                                              size: 24.0,
                                            ),
                                          ],
                                        ),
                                        value: summaryFilter,
                                        iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Color(0xFFA9A9AA),
                                            size: 24.0,
                                          ),
                                        ),
                                        onChanged: (val) => setState(() => summaryFilter = val!),
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
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 73.0, 0.0),
                                    child: Text(
                                      'Купленная валюта, \$',
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
                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 36.0, 0.0),
                                    child: Text(
                                      'Сумма на покупку вн. валюты, \$',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context).hintText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: summary.length,
                              itemBuilder: (context, listViewIndex) {
                                final item = summary[listViewIndex];
                                final listViewUsersRecord = item.user;
                                return InkWell(
                                  onTap: () {
                                    context.pushRoute(ComplaintUserPageWidgetRoute(
                                      user: listViewUsersRecord,
                                      appBarText: 'АНАЛИТИКА. СТАТИСТИКА ПО КЛИЕНТАМ. ПРОФИЛЬ',
                                      complainsRecord: null,
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      border: Border.all(
                                        color: const Color(0xFFE9E9E9),
                                        width: 1.0,
                                      ),
                                    ),
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
                                                '${listViewUsersRecord.displayName} ${listViewUsersRecord.lastName}',
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
                                          width: 148.0,
                                          decoration: const BoxDecoration(),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(22.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              getDealCounter(item),
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
                                          width: 255.0,
                                          decoration: const BoxDecoration(),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 0.0, 0.0),
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
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String getDealCounter(SummaryModel s) {
    int result = 0;

    if (summaryFilter == SummaryFilter.all) {
      return s.allDeals.toString();
    } else if (summaryFilter == SummaryFilter.create) {
      return s.createdDeals.toString();
    } else if (summaryFilter == SummaryFilter.active) {
      return s.activeDeals.toString();
    } else if (summaryFilter == SummaryFilter.completed) {
      return s.completedDeals.toString();
    }

    return result.toString();
  }
}

String getSummaryFilterName(SummaryFilter f) {
  switch (f) {
    case SummaryFilter.create:
      return 'Созданные заказы';
    case SummaryFilter.active:
      return 'Активные заказы';
    case SummaryFilter.completed:
      return 'Завершенные заказы';
    default:
      return 'Все';
  }
}
