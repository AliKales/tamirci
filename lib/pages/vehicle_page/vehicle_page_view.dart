import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_vehicle.dart';
import 'package:tamirci/locale_keys.dart';

class VehiclePageView extends StatefulWidget {
  const VehiclePageView({super.key, required this.vehicle});

  final MVehicle vehicle;

  @override
  State<VehiclePageView> createState() => _VehiclePageViewState();
}

class _VehiclePageViewState extends State<VehiclePageView> {
  MVehicle get _vehicle => widget.vehicle;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: LocalValues.paddingPage(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.car_repair),
                iconSize: 80,
              ),
              const SizedBox(height: 30),
              ListTile(
                title: Text(_vehicle.plate ?? "-"),
                leading: const Icon(Icons.info_rounded),
              ),
              ListTile(
                title: Text(_vehicle.vehicleMake ?? "-"),
                leading: const Icon(Icons.info_rounded),
              ),
              ListTile(
                title: Text(_vehicle.vehicleModel ?? "-"),
                leading: const Icon(Icons.info_rounded),
              ),
              ListTile(
                title: Text(_vehicle.vehicleModelDetail ?? "-"),
                leading: const Icon(Icons.info_rounded),
              ),
              ListTile(
                title: Text(_vehicle.vehicleYear?.toString() ?? "-"),
                leading: const Icon(Icons.date_range),
              ),
              ListTile(
                title: Text("${LocaleKeys.engineNo}: ${_vehicle.engineNo}"),
                leading: const Icon(Icons.info_rounded),
              ),
              ListTile(
                title: Text("${LocaleKeys.chassisNo}: ${_vehicle.chassisNo}"),
                leading: const Icon(Icons.info_rounded),
              ),
              ListTile(
                title: Text("${LocaleKeys.kilometer}: ${_vehicle.kilometer}"),
                leading: const Icon(Icons.info_rounded),
              ),
              ListTile(
                title: Text(_vehicle.color?.toString() ?? "-"),
                leading: const Icon(Icons.info_rounded),
              ),
              ListTile(
                title: Text(
                    "${LocaleKeys.lastService}: ${_vehicle.lastServiceAt?.toStringFromDate}"),
                leading: const Icon(Icons.date_range_rounded),
              ),
              ListTile(
                title: Text(
                    "${LocaleKeys.firstService}: ${_vehicle.createdAt?.toStringFromDate}"),
                leading: const Icon(Icons.date_range_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(title: const Text(LocaleKeys.vehicle));
}
