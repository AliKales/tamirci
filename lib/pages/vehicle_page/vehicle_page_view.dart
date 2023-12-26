// ignore_for_file: use_build_context_synchronously

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/firebase/f_firestore.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/core/models/m_vehicle.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/router.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/service_widget/service_widget.dart';

class VehiclePageView extends StatefulWidget {
  const VehiclePageView({super.key, required this.data});

  final MapEntry<MCustomer, MVehicle> data;

  @override
  State<VehiclePageView> createState() => _VehiclePageViewState();
}

class _VehiclePageViewState extends State<VehiclePageView> {
  List<MService>? _services;
  MVehicle get _vehicle => widget.data.value;
  MCustomer get _customer => widget.data.key;

  bool _noMore = false;

  Future<void> _loadServices([bool isMore = false]) async {
    CustomProgressIndicator.showProgressIndicator(context);

    final r = await FFirestore.getServices(
      equalTo: [
        MapEntry("vehicleID", _vehicle.plate!),
        MapEntry("customerID", _customer.phone.toString()),
      ],
      limit: 5,
      lastDate: _services?.last.createdAt,
    );

    context.pop();

    if (r.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: "Error ${r.exception?.message}");
      return;
    }

    if (isMore && r.response.isEmptyOrNull) {
      setState(() {
        _noMore = true;
      });
      return;
    }

    _services ??= [];
    _services = _services! + (r.response ?? []);

    setState(() {});
  }

  void _onServiceTap(int i) {
    final s = _services![i];
    s.customer = _customer;
    s.vehicle = _vehicle;
    context.push(PagePaths.service, extra: s);
  }

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
              _buttonNListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonNListView() {
    if (_services == null) {
      return Buttons(context, LocaleKeys.seeServices, _loadServices).filled();
    }

    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ServiceWidget(
                service: _services![index],
                onTap: () => _onServiceTap(index),
              );
            },
            itemCount: _services!.length,
            shrinkWrap: true,
          ),
        ),
        if (!_noMore)
          Buttons(
            context,
            LocaleKeys.more,
            () => _loadServices(true),
          ).outlined(),
      ],
    );
  }

  AppBar _appBar() => AppBar(title: const Text(LocaleKeys.vehicle));
}
