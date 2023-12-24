import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamirci/core/extensions/ext_object.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/extensions/ext_text_controller.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/c_text_field.dart';

import '../service_controller.dart';

class ServiceView extends StatefulWidget {
  const ServiceView({
    super.key,
    required this.service,
    required this.controller,
  });

  final MService service;
  final ServiceController controller;

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView>
    with AutomaticKeepAliveClientMixin {
  final now = DateTime.now();
  final _tECCustomerComplaint = TextEditingController();
  final _tECProblem = TextEditingController();
  final _tECToDone = TextEditingController();
  final _tECKilometer = TextEditingController();

  @override
  void initState() {
    super.initState();
    final c = widget.controller;
    c.receiveService = _receiveService;

    context.afterBuild((p0) => _setTextControllers());
  }

  @override
  void dispose() {
    _tECCustomerComplaint.dispose();
    _tECProblem.dispose();
    _tECToDone.dispose();
    _tECKilometer.dispose();
    super.dispose();
  }

  MService _receiveService(MService s) {
    return s.copyWith(
      customerComplaint: _tECCustomerComplaint.textTrimOrNull,
      problem: _tECProblem.textTrimOrNull,
      toDone: _tECToDone.textTrimOrNull,
      kilometer: _tECKilometer.text.toIntOrNull,
    );
  }

  void _setTextControllers() {
    _tECCustomerComplaint.text = widget.service.customerComplaint ?? "";
    _tECProblem.text = widget.service.problem ?? "";
    _tECToDone.text = widget.service.toDone ?? "";
    _tECKilometer.text = widget.service.kilometer.toStringNull;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: LocalValues.paddingPage(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.service,
              style: context.textTheme.titleLarge,
            ),
            CTextField(
              label: LocaleKeys.date,
              readOnly: true,
              initialValue: now.toStringFromDate,
            ),
            CTextField(
              label: LocaleKeys.customerComplaint,
              maxLines: null,
              controller: _tECCustomerComplaint,
            ),
            CTextField(
              label: LocaleKeys.problem,
              maxLines: null,
              controller: _tECProblem,
            ),
            CTextField(
              label: LocaleKeys.toDone,
              maxLines: null,
              controller: _tECToDone,
            ),
            CTextField(
              label: LocaleKeys.kilometerAtService,
              maxLines: 1,
              controller: _tECKilometer,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CKilometerFormatter(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
