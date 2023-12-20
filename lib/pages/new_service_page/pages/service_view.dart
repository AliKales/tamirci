import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/pages/new_service_page/service_controller.dart';
import 'package:tamirci/widgets/c_text_field.dart';

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

  MService get _service => widget.service;

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
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ServiceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setTextControllers();
  }

  MService _receiveService(MService s) {
    return s.copyWith(
      customerComplaint: _tECCustomerComplaint.textTrim,
      problem: _tECProblem.textTrim,
      toDone: _tECToDone.textTrim,
    );
  }

  void _setTextControllers() {
    _tECCustomerComplaint.text = widget.service.customerComplaint ?? "";
    _tECProblem.text = widget.service.problem ?? "";
    _tECToDone.text = widget.service.toDone ?? "";
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
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
