import 'dart:async';
import 'dart:io';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/verification/models/verification.dart';
import '/verification/services/validators.dart';
import '/verification/services/vin_service.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'create_deal1_comp_model.dart';
export 'create_deal1_comp_model.dart';

class CreateDeal1CompWidget extends StatefulWidget {
  const CreateDeal1CompWidget({
    super.key,
    required this.onTap,
  });

  final Future Function()? onTap;

  @override
  State<CreateDeal1CompWidget> createState() => _CreateDeal1CompWidgetState();
}

class _CreateDeal1CompWidgetState extends State<CreateDeal1CompWidget> {
  late CreateDeal1CompModel _model;

  final _vinService = VinService();
  Timer? _vinDebounce;
  int _vinRequestId = 0;
  VerificationResult _vinResult = const VerificationResult.idle();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateDeal1CompModel());

    _model.carNameTextController ??= TextEditingController(text: FFAppState().createDealCarName);
    _model.carNameFocusNode ??= FocusNode();

    _model.vinTextController ??= TextEditingController(text: FFAppState().createDealCarVin);
    _model.vinFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _vinDebounce?.cancel();
    _model.maybeDispose();

    super.dispose();
  }

  /// Проверка VIN: сначала офлайн контрольная цифра, затем запрос в NHTSA.
  /// Гонка запросов гасится счётчиком, ответ на устаревший ввод отбрасывается.
  void _onVinChanged(String raw) {
    _vinDebounce?.cancel();
    FFAppState().createDealCarVin = raw.trim().toUpperCase();

    final local = Validators.validateVin(raw);
    setState(() => _vinResult = local);

    if (local.status != VerificationStatus.checking) return;

    final myId = ++_vinRequestId;
    _vinDebounce = Timer(const Duration(milliseconds: 700), () async {
      if (!mounted) return;
      setState(() => _vinResult = const VerificationResult.checking());
      final res = await _vinService.decode(raw);
      if (!mounted || myId != _vinRequestId) return;
      setState(() => _vinResult = res);

      // Автозаполнение названия: марка, модель, год из ответа NHTSA.
      if (res.status == VerificationStatus.verified) {
        final parts = [
          res.autofill['Год'],
          res.autofill['Марка'],
          res.autofill['Модель'],
        ].where((e) => e != null && e.isNotEmpty).join(' ');
        if (parts.isNotEmpty) {
          _model.carNameTextController?.text = parts;
          FFAppState().createDealCarName = parts;
          setState(() {});
        }
      }
    });
  }

  ({Color color, IconData icon, String label})? get _vinVisual {
    switch (_vinResult.status) {
      case VerificationStatus.idle:
        return null;
      case VerificationStatus.checking:
        return (
          color: FlutterFlowTheme.of(context).secondary,
          icon: Icons.sync_rounded,
          label: 'Проверяем в базе NHTSA…'
        );
      case VerificationStatus.verified:
        return (
          color: const Color(0xFF2E7D4F),
          icon: Icons.verified_rounded,
          label: _vinResult.message ?? 'Подтверждено NHTSA'
        );
      case VerificationStatus.invalidFormat:
      case VerificationStatus.mismatch:
        return (
          color: FlutterFlowTheme.of(context).error,
          icon: Icons.error_outline_rounded,
          label: _vinResult.message ?? 'Ошибка в VIN'
        );
      case VerificationStatus.notFound:
        return (
          color: const Color(0xFFB26A00),
          icon: Icons.help_outline_rounded,
          label: _vinResult.message ?? 'VIN не найден в базе'
        );
      default:
        return (
          color: FlutterFlowTheme.of(context).secondary,
          icon: Icons.cloud_off_rounded,
          label: _vinResult.message ?? 'Проверка недоступна — можно продолжить'
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
            child: Text(
              'VIN автомобиля',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
            ),
          ),
          _vinField(),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 8.0),
            child: Text(
              FFLocalizations.of(context).getText(
                'k5v6aa9r' /* Название машины */,
              ),
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller: _model.carNameTextController,
              focusNode: _model.carNameFocusNode,
              onChanged: (_) => EasyDebounce.debounce(
                '_model.carNameTextController',
                const Duration(milliseconds: 200),
                () async {
                  FFAppState().createDealCarName = _model.carNameTextController.text;
                  setState(() {});
                },
              ),
              autofocus: false,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              obscureText: false,
              decoration: InputDecoration(
                hintText: FFLocalizations.of(context).getText(
                  'zpjizta7' /* Например, Ауди А5 */,
                ),
                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).hintColor,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                errorStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).error,
                      fontSize: 10.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                counterStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: const Color(0xFF424245),
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x00000000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).border,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).error,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 18.0, 15.0, 18.0),
                suffixIcon: _model.carNameTextController!.text.isNotEmpty
                    ? InkWell(
                        onTap: () async {
                          _model.carNameTextController?.clear();
                          FFAppState().createDealCarName = '';
                          setState(() {});
                        },
                        child: Icon(
                          Icons.clear,
                          color: FlutterFlowTheme.of(context).border,
                          size: 20.0,
                        ),
                      )
                    : null,
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              textAlign: TextAlign.start,
              minLines: 1,
              maxLength: 50,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.name,
              cursorColor: FlutterFlowTheme.of(context).primary,
              validator: _model.carNameTextControllerValidator.asValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
            child: Text(
              FFLocalizations.of(context).getText(
                'c7d8b4vr' /* Фото транпорта */,
              ),
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
              child: Builder(
                builder: (context) {
                  final photos = FFAppState().createDealCarPhotos.map((e) => e).toList();
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: photos.length,
                    itemBuilder: (context, photosIndex) {
                      final photosItem = photos[photosIndex];
                      return Builder(
                        builder: (context) {
                          if (photosItem == '') {
                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final selectedMedia = await selectMediaWithSourceBottomSheet(
                                  context: context,
                                  imageQuality: 50,
                                  allowPhoto: true,
                                  includeDimensions: true,
                                );
                                if (selectedMedia != null && selectedMedia.isNotEmpty) {
                                  final selected = selectedMedia.first;
                                  // Загружаем в Storage сразу при выборе
                                  final path = getStoragePath(
                                    currentUserUid,
                                    'deal_photo_${DateTime.now().millisecondsSinceEpoch}_$photosIndex.jpg',
                                    false,
                                  );
                                  final String? url = await uploadData(path, selected.bytes);
                                  if (url != null) {
                                    FFAppState().updateCreateDealCarPhotosAtIndex(photosIndex, (_) => url);
                                    setState(() {});
                                  }
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  size: 40.0,
                                ),
                              ),
                            );
                          } else {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: photosItem.startsWith('http')
                                      ? Image.network(
                                          photosItem,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(photosItem),
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(1.0, -1.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      FFAppState().updateCreateDealCarPhotosAtIndex(photosIndex, (_) => '');
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.clear_rounded,
                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          if (valueOrDefault<bool>(
            (_model.carNameTextController.text != '') && (FFAppState().hasCarPhotoItem),
            false,
          ))
            FFButtonWidget(
              onPressed: () async {
                await widget.onTap?.call();
              },
              text: FFLocalizations.of(context).getText(
                '64hmfy70' /* Далее */,
              ),
              options: FFButtonOptions(
                width: double.infinity,
                height: 56.0,
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: false,
                    ),
                elevation: 0.0,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
        ],
      ),
    );
  }

  /// Поле VIN: 17 символов, буквы I/O/Q исключены стандартом ISO 3779.
  /// Контрольная цифра считается офлайн, затем идёт запрос в NHTSA vPIC.
  Widget _vinField() {
    final visual = _vinVisual;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            controller: _model.vinTextController,
            focusNode: _model.vinFocusNode,
            onChanged: _onVinChanged,
            autofocus: false,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
              TextInputFormatter.withFunction(
                (_, next) => next.copyWith(text: next.text.toUpperCase()),
              ),
            ],
            decoration: InputDecoration(
              hintText: '1HGCM82633A004352',
              hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).hintColor,
                    letterSpacing: 0.0,
                    useGoogleFonts: false,
                  ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0x00000000),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).border,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: FlutterFlowTheme.of(context).secondaryBackground,
              contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 18.0, 15.0, 18.0),
              suffixIcon: visual == null
                  ? null
                  : Icon(visual.icon, color: visual.color, size: 20.0),
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
            maxLength: 17,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
            keyboardType: TextInputType.text,
            cursorColor: FlutterFlowTheme.of(context).primary,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4.0, 6.0, 4.0, 0.0),
          child: Text(
            visual?.label ?? 'Необязательно. По VIN подставим марку, модель и год',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Inter',
                  color: visual?.color ?? FlutterFlowTheme.of(context).hintColor,
                  letterSpacing: 0.0,
                  useGoogleFonts: false,
                ),
          ),
        ),
        if (_vinResult.status == VerificationStatus.verified && _vinResult.autofill.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: const Color(0xFFCADFD1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _vinResult.autofill.entries
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  e.key,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context).secondary,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.value,
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
