import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/extensions/ext_object.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/pages/new_service_page/service_controller.dart';
import 'package:tamirci/widgets/c_dropdown_menu.dart';
import 'package:tamirci/widgets/c_text_field.dart';

import '../../../core/local_values.dart';

class VehicleView extends StatefulWidget {
  const VehicleView(
      {super.key, required this.service, required this.controller});

  final MService service;
  final ServiceController controller;

  @override
  State<VehicleView> createState() => _VehicleViewState();
}

class _VehicleViewState extends State<VehicleView>
    with AutomaticKeepAliveClientMixin {
  final _tECPlate = TextEditingController();
  final _tECVehicleMake = TextEditingController();
  final _tECVehicleModel = TextEditingController();
  final _tECChassisNo = TextEditingController();
  final _tECEngineNo = TextEditingController();
  final _tECVehicleYear = TextEditingController();
  final _tECColor = TextEditingController();
  final _tECKilometer = TextEditingController();

  List<String> _carMakes = [];

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;
    controller.receiveService = _receiveService;
    _loadVehicleMakes();

    context.afterBuild((p0) => _setTextControllers());
  }

  @override
  void dispose() {
    _tECVehicleMake.dispose();
    _tECVehicleModel.dispose();
    _tECChassisNo.dispose();
    _tECEngineNo.dispose();
    _tECVehicleYear.dispose();
    _tECColor.dispose();
    _tECKilometer.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VehicleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setTextControllers();
  }

  MService _receiveService(MService s) {
    return s.copyWith(
      plate: _tECPlate.textTrim.replaceAll(" ", "").toLowerCase(),
      vehicleMake: _tECVehicleMake.textTrim,
      vehicleModel: _tECVehicleModel.textTrim,
      chassisNo: _tECChassisNo.textTrim,
      engineNo: _tECEngineNo.textTrim,
      vehicleYear: _tECVehicleYear.textTrim.toIntOrNull,
      color: _tECColor.textTrim,
      kilometer: _tECKilometer.textTrim.toIntOrNull,
    );
  }

  void _setTextControllers() {
    _tECVehicleMake.text = widget.service.vehicleMake.toStringNull;
    _tECVehicleModel.text = widget.service.vehicleModel.toStringNull;
    _tECChassisNo.text = widget.service.chassisNo.toStringNull;
    _tECEngineNo.text = widget.service.engineNo.toStringNull;
    _tECVehicleYear.text = widget.service.vehicleYear.toStringNull;
    _tECColor.text = widget.service.color.toStringNull;
    _tECKilometer.text = widget.service.kilometer.toStringNull;
  }

  Future<void> _loadVehicleMakes() async {
    final result =
        await Utils.loadLocalJson("assets/jsons/vehicle-makes.json") as List;
    _carMakes = result.cast<String>();
  }

  double get _width {
    return context.width -
        (Values.paddingPageValue.toDynamicWidth(context) * 2);
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
              LocaleKeys.vehicle,
              style: context.textTheme.titleLarge,
            ),
            Row(
              children: [
                CTextField(
                  label: LocaleKeys.plate,
                  controller: _tECPlate,
                ).expanded,
                context.sizedBox(width: Values.paddingPageValue),
                IconButton.filled(
                    onPressed: () {}, icon: const Icon(Icons.search)),
              ],
            ),
            CDropdownMenu(
              labels: _carMakes,
              width: _width,
              controller: _tECVehicleMake,
              label: LocaleKeys.vehicleMake,
            ),
            const CTextField(
              label: LocaleKeys.vehicleModel,
            ),
            const CTextField(
              label: LocaleKeys.chassisNo,
            ),
            const CTextField(
              label: LocaleKeys.engineNo,
            ),
            const CTextField(
              label: LocaleKeys.vehicleYear,
            ),
            const CTextField(
              label: LocaleKeys.color,
            ),
            const CTextField(
              label: LocaleKeys.kilometer,
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
