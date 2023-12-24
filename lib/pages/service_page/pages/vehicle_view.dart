import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamirci/core/extensions/ext_object.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/extensions/ext_text_controller.dart';
import 'package:tamirci/core/models/m_vehicle.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/c_dropdown_menu.dart';
import 'package:tamirci/widgets/c_text_field.dart';

import '../../../core/local_values.dart';

class VehicleController {
  MVehicle Function(MVehicle service)? receiveVehicle;
  VoidCallback? updateTextFields;

  void dispose() {
    receiveVehicle = null;
    updateTextFields = null;
  }
}

class VehicleView extends StatefulWidget {
  const VehicleView(
      {super.key,
      required this.vehicle,
      required this.controller,
      required this.isNew,
      required this.onSearchPlate});

  final MVehicle vehicle;
  final VehicleController controller;
  final bool isNew;
  final ValueChanged<String> onSearchPlate;

  @override
  State<VehicleView> createState() => _VehicleViewState();
}

class _VehicleViewState extends State<VehicleView>
    with AutomaticKeepAliveClientMixin {
  final _tECPlate = TextEditingController();
  final _tECVehicleMake = TextEditingController();
  final _tECVehicleModel = TextEditingController();
  final _tECVehicleModelDetail = TextEditingController();
  final _tECChassisNo = TextEditingController();
  final _tECEngineNo = TextEditingController();
  final _tECVehicleYear = TextEditingController();
  final _tECColor = TextEditingController();
  final _tECKilometer = TextEditingController();

  List<String> _carMakes = [];
  final List<String> _colors = [
    "bej",
    "beyaz",
    "bordo",
    "füme",
    "gri",
    "gümüş gri",
    "kahverengi",
    "kırmızı",
    "lacivert",
    "mavi",
    "mor",
    "pembe",
    "sarı",
    "siyah",
    "şampanya",
    "turkuaz",
    "turuncu",
    "yeşil",
  ];

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;
    controller.receiveVehicle = _receiveVehicle;
    controller.updateTextFields = _setTextControllers;

    _loadVehicleMakes();

    context.afterBuild((p0) => _setTextControllers());
  }

  @override
  void dispose() {
    _tECVehicleMake.dispose();
    _tECVehicleModel.dispose();
    _tECVehicleModelDetail.dispose();
    _tECChassisNo.dispose();
    _tECEngineNo.dispose();
    _tECVehicleYear.dispose();
    _tECColor.dispose();
    _tECKilometer.dispose();
    super.dispose();
  }

  MVehicle _receiveVehicle(MVehicle v) {
    return v.copyWith(
      plate: _tECPlate.textTrimOrNull?.replaceAll(" ", "").toLowerCase(),
      vehicleMake: _tECVehicleMake.textTrimOrNull?.toLowerCase(),
      vehicleModel: _tECVehicleModel.textTrimOrNull,
      vehicleModelDetail: _tECVehicleModelDetail.textTrimOrNull,
      chassisNo: _tECChassisNo.textTrimOrNull,
      engineNo: _tECEngineNo.textTrimOrNull,
      vehicleYear: _tECVehicleYear.textTrim.toIntOrNull,
      color: _tECColor.textTrimOrNull,
      kilometer: _tECKilometer.textTrim.replaceAll(".", "").toIntOrNull,
    );
  }

  void _setTextControllers() {
    _tECPlate.text = widget.vehicle.plate.toStringNull;
    _tECVehicleMake.text = widget.vehicle.vehicleMake.toStringNull;
    _tECVehicleModel.text = widget.vehicle.vehicleModel.toStringNull;
    _tECVehicleModelDetail.text =
        widget.vehicle.vehicleModelDetail.toStringNull;
    _tECChassisNo.text = widget.vehicle.chassisNo.toStringNull;
    _tECEngineNo.text = widget.vehicle.engineNo.toStringNull;
    _tECVehicleYear.text = widget.vehicle.vehicleYear.toStringNull;
    _tECColor.text = widget.vehicle.color.toStringNull;
    _tECKilometer.text = widget.vehicle.kilometer.toStringNull;
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

  Future<void> _pickColor() async {
    final r = await CustomDialog.showDialogRadioList(
      context,
      items: _colors.map((e) => e.toUpperCase()).toList(),
      title: LocaleKeys.color,
    );
    if (r == null) return;
    _tECColor.text = _colors[r];
  }

  void _searchPlate() {
    String p = _tECPlate.textTrim;
    if (p.isEmptyOrNull) return;
    widget.onSearchPlate.call(p);
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
                  inputFormatters: [
                    LocalValues.digitsLetters,
                  ],
                ).expanded,
                if (widget.isNew) ...[
                  context.sizedBox(width: Values.paddingPageValue),
                  IconButton.filled(
                    onPressed: _searchPlate,
                    icon: const Icon(Icons.search),
                  ),
                ],
              ],
            ),
            CDropdownMenu(
              labels: _carMakes.map((e) => e.toUpperCase()).toList(),
              width: _width,
              controller: _tECVehicleMake,
              label: LocaleKeys.vehicleMake,
            ),
            CTextField(
              label: LocaleKeys.vehicleModel,
              controller: _tECVehicleModel,
            ),
            CTextField(
              label: LocaleKeys.vehicleModelDetail,
              controller: _tECVehicleModelDetail,
            ),
            CTextField(
              label: LocaleKeys.chassisNo,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [LocalValues.digitsLetters],
              length: 17,
              controller: _tECChassisNo,
            ),
            CTextField(
              label: LocaleKeys.engineNo,
              controller: _tECEngineNo,
            ),
            CTextField(
              controller: _tECVehicleYear,
              label: LocaleKeys.vehicleYear,
              keyboardType: TextInputType.number,
              length: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            CTextField(
              label: LocaleKeys.color,
              controller: _tECColor,
              suffixIcon: IconButton(
                onPressed: _pickColor,
                icon: const Icon(Icons.arrow_drop_down_outlined),
              ),
            ),
            CTextField(
              controller: _tECKilometer,
              label: LocaleKeys.kilometer,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CKilometerFormatter(),
              ],
            ),
            context.sizedBox(height: 0.1),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
