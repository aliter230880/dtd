import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'user_profile_raitings_model.dart';
export 'user_profile_raitings_model.dart';

class UserProfileRaitingsWidget extends StatefulWidget {
  const UserProfileRaitingsWidget({
    super.key,
    required this.userRef,
  });

  final DocumentReference? userRef;

  @override
  State<UserProfileRaitingsWidget> createState() => _UserProfileRaitingsWidgetState();
}

class _UserProfileRaitingsWidgetState extends State<UserProfileRaitingsWidget> {
  late UserProfileRaitingsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserProfileRaitingsModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReviewsRecord>>(
      future: queryReviewsRecordOnce(
        queryBuilder: (reviewsRecord) => reviewsRecord
            .where(
              'receiver',
              isEqualTo: widget.userRef,
            )
            .orderBy('created_time')
            .limit(5),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<ReviewsRecord> containerReviewsRecordList = snapshot.data!;
        return Container(
          decoration: const BoxDecoration(),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        FFLocalizations.of(context).getText(
                          'hj9lsbje' /* Отзывы */,
                        ),
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
                          child: FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 18.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 8.0, 0.0),
                          child: AuthUserStreamWidget(
                            builder: (context) => Text(
                              valueOrDefault<String>(
                                valueOrDefault(currentUserDocument?.rate, 0.0).toStringAsFixed(1),
                                '0',
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                        Text(
                          containerReviewsRecordList.isEmpty
                              ? FFLocalizations.of(context).getText('no_reviews')
                              : '(${valueOrDefault<String>(
                                  containerReviewsRecordList.length.toString(),
                                  '0',
                                  // )} ${FFLocalizations.of(context).getText('reviews')})',
                                )} ${getReviewCounterText(context, containerReviewsRecordList.length)})',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                Builder(
                  builder: (context) {
                    if (containerReviewsRecordList.isEmpty) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'jt3ud1l1' /* Отзывов пока нет */,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).secondary,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 14.0),
                            child: Builder(
                              builder: (context) {
                                final reviewsvar = containerReviewsRecordList.map((e) => e).toList().take(2).toList();
                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: reviewsvar.length >= 2 ? 2 : reviewsvar.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                                  itemBuilder: (context, reviewsvarIndex) {
                                    final reviewsvarItem = reviewsvar[reviewsvarIndex];
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: FutureBuilder<UsersRecord>(
                                          future: UsersRecord.getDocumentOnce(reviewsvarItem.sender!),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child: CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      FlutterFlowTheme.of(context).primary,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            final rowUsersRecord = snapshot.data!;
                                            return Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(100.0),
                                                    child: CachedNetworkImage(
                                                      fadeInDuration: const Duration(milliseconds: 300),
                                                      fadeOutDuration: const Duration(milliseconds: 300),
                                                      imageUrl: rowUsersRecord.photoUrl,
                                                      width: 30.0,
                                                      height: 30.0,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context, error, stackTrace) => Image.asset(
                                                        'assets/images/error_image.png',
                                                        width: 30.0,
                                                        height: 30.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.max,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsetsDirectional.fromSTEB(
                                                                  0.0, 0.0, 12.0, 0.0),
                                                              child: Text(
                                                                rowUsersRecord.displayName,
                                                                maxLines: 1,
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      fontFamily: 'Inter',
                                                                      letterSpacing: 0.0,
                                                                      fontWeight: FontWeight.w600,
                                                                      useGoogleFonts: false,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          RatingBar.builder(
                                                            onRatingUpdate: (value) {},
                                                            itemBuilder: (context, index) => Icon(
                                                              Icons.star_rounded,
                                                              color: FlutterFlowTheme.of(context).primary,
                                                            ),
                                                            allowHalfRating: true,
                                                            direction: Axis.horizontal,
                                                            initialRating: reviewsvarItem.rate,
                                                            unratedColor: const Color(0xFFE9E9E9),
                                                            itemCount: 5,
                                                            itemSize: 16.0,
                                                            ignoreGestures: true,
                                                            glowColor: FlutterFlowTheme.of(context).primary,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        dateTimeFormat(
                                                          'relative',
                                                          reviewsvarItem.createdTime!,
                                                          locale: FFLocalizations.of(context).languageCode,
                                                        ),
                                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                                              fontFamily: 'Inter',
                                                              color: FlutterFlowTheme.of(context).hintColor,
                                                              fontSize: 10.0,
                                                              letterSpacing: 0.0,
                                                              useGoogleFonts: false,
                                                            ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                                        child: Text(
                                                          reviewsvarItem.text,
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                fontFamily: 'Inter',
                                                                fontSize: 12.0,
                                                                letterSpacing: 0.0,
                                                                useGoogleFonts: false,
                                                              ),
                                                          maxLines: 6,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                'ReviewsPage',
                                queryParameters: {
                                  'userRef': serializeParam(
                                    widget.userRef,
                                    ParamType.DocumentReference,
                                  ),
                                }.withoutNulls,
                              );
                            },
                            child: Text(
                              FFLocalizations.of(context).getText('gyrqgctd'),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).secondary,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
