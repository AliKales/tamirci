// ignore_for_file: use_build_context_synchronously

part of 'service_page_view.dart';

mixin _MixinNewService<T extends StatefulWidget> on State<T> {
  final controller = PageController();

  final customerController = CustomerViewController();
  final vehicleController = VehicleController();
  final serviceController = ServiceController();
  final priceController = ServiceController();

  MService service = MService(
    createdAt: DateTime.now(),
  );

  MCustomer customer = MCustomer(
      phoneCountryCode: 90,
      createdAt: DateTime.now(),
      lastServiceAt: DateTime.now(),
      serviceCount: 0);

  MVehicle vehicle = MVehicle(
      createdAt: DateTime.now(),
      lastServiceAt: DateTime.now(),
      serviceCount: 0);

  int get currentPage => controller.page?.toInt() ?? 0;

  bool isNew = true;

  void initialize(MService? s) {
    if (s != null) {
      service = s;
      customer = s.customer!;
      vehicle = s.vehicle!;
      isNew = false;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    customerController.dispose();
    vehicleController.dispose();
    serviceController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _onScan() async {
    final page = controller.page!.toInt();

    final r = await context.push<List<MapEntry<String, String>>>(
        PagePaths.scanner,
        extra: ServicePages.values[page]);

    if (r == null) return;

    for (var e in r) {
      switch (e.key) {
        case LocaleKeys.idNo:
          e.value.toInt;
          break;
        default:
      }
    }
  }

  void addPiece(MPiece p) {
    if (service.usedPieces == null) {
      service.usedPieces = [p];
      return;
    }
    service.usedPieces!.add(p);
    setState(() {});
  }

  void removePiece(int i) {
    service.usedPieces!.removeAt(i);
    setState(() {});
  }

  void _getDatas() {
    customer = customerController.receiveCustomer!.call(customer);
    vehicle = vehicleController.receiveVehicle!.call(vehicle);
    service = serviceController.receiveService!.call(service);
    service = priceController.receiveService!.call(service);
    service.customer = customer;

    service.customerID = customer.phone.toStringNull;
    service.vehicleID = vehicle.plate.toStringNull;
    vehicle.customerID = customer.phone.toStringNull;

    service.vehicle = vehicle;
    service.customer = customer;

    service.kilometer ??= vehicle.kilometer;

    service.customerFullName = customer.getFullName;
  }

  Future<void> onAddNew() async {
    _getDatas();

    CustomProgressIndicator.showProgressIndicator(context);

    final customerResult =
        await FFirestore.get(FirestoreCol.shops, doc: FAuth.uid, subs: [
      FirestoreSub(col: FirestoreCol.customers, doc: customer.phone.toString())
    ]);

    context.pop();

    if (customerResult.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: 'Error ${customerResult.exception?.message}');
      return;
    }

    bool shouldSetCustomer = isNew;

    if (customerResult.response?.data() != null) {
      shouldSetCustomer = await CustomDialog.showCustomDialog<bool>(context,
              title: LocaleKeys.warning,
              text: LocaleKeys.wantToUpdateCustomer,
              actions: [
                Buttons(context, LocaleKeys.no, () => context.pop(false))
                    .textB(),
                Buttons(context, LocaleKeys.yes, () => context.pop(true))
                    .textB(),
              ]) ??
          false;
      if (!shouldSetCustomer) {
        final c = MCustomer.fromJson(customerResult.response!.data()!);
        service.customerFullName = c.getFullName;
      }
    }

    if (shouldSetCustomer) {
      CustomProgressIndicator.showProgressIndicator(context);

      final customerResult = await FFirestore.set(
        FirestoreCol.shops,
        doc: FAuth.uid,
        map: customer.toJson(),
        subs: [
          FirestoreSub(
            col: FirestoreCol.customers,
            doc: customer.phone.toStringNull,
          ),
        ],
      );

      context.pop(service);

      if (customerResult.hasError) {
        CustomSnackbar.showSnackBar(
            context: context, text: "Error: ${customerResult.exception?.code}");
        return;
      }
    }

    CustomProgressIndicator.showProgressIndicator(context);

    final vehicleResult = await FFirestore.get(FirestoreCol.shops,
        doc: FAuth.uid,
        subs: [FirestoreSub(col: FirestoreCol.vehicles, doc: vehicle.plate)]);

    context.pop();

    if (vehicleResult.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: 'Error ${vehicleResult.exception?.message}');
      return;
    }

    bool shouldSetVehicle = isNew;

    if (vehicleResult.response?.data() != null) {
      shouldSetVehicle = await CustomDialog.showCustomDialog<bool>(context,
              title: LocaleKeys.warning,
              text: LocaleKeys.wantToUpdateVehicle,
              actions: [
                Buttons(context, LocaleKeys.no, () => context.pop(false))
                    .textB(),
                Buttons(context, LocaleKeys.yes, () => context.pop(true))
                    .textB(),
              ]) ??
          false;
    }

    if (shouldSetVehicle) {
      CustomProgressIndicator.showProgressIndicator(context);

      final vehicleResult = await FFirestore.set(FirestoreCol.shops,
          doc: FAuth.uid,
          map: vehicle.toJson(),
          subs: [FirestoreSub(col: FirestoreCol.vehicles, doc: vehicle.plate)]);

      context.pop();

      if (vehicleResult.hasError) {
        String e = vehicleResult.exception?.message ?? "";
        CustomSnackbar.showSnackBar(context: context, text: "Error $e");
        return;
      }
    }

    CustomProgressIndicator.showProgressIndicator(context);

    final serviceResult = await FFirestore.set(
      FirestoreCol.shops,
      doc: FAuth.uid,
      map: service.toJson(),
      subs: [
        FirestoreSub(
          col: FirestoreCol.services,
        ),
      ],
    );

    context.pop(service);

    if (serviceResult.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: "Error: ${serviceResult.exception?.code}");
      return;
    }

    context.pop(service);
  }

  void onUpdate() {
    _getDatas();
  }

  void changePageWeb(bool isNext) {
    int i;

    if (isNext) {
      i = currentPage + 1;
      if (i > 4) return;
    } else {
      i = currentPage - 1;
      if (i < 0) return;
    }

    controller.animateToPage(i, duration: 300.toDuration, curve: Curves.ease);
  }

  void onCustomerTap() {
    context.push(PagePaths.customer, extra: customer);
  }

  Future<void> findCustomer(MapEntry<String, Object> where) async {
    await _getCustomer(where);
    if (customer.phone != null) {
      await _getVehicle(
          MapEntry("customerID", customer.phone.toString()), true);
    }
  }

  Future<void> findVehicle(String plate) async {
    await _getVehicle(
        MapEntry("plate", plate.removeSpaces.toLowerCase()), false);
    if (vehicle.customerID.isEmptyOrNull) return;
    await _getCustomer(MapEntry("phone", vehicle.customerID.toInt));
  }

  Future<void> _getCustomer(MapEntry<String, Object> where) async {
    CustomProgressIndicator.showProgressIndicator(context);
    final r = await FFirestore.getCustomers(equalTo: where);
    context.pop();

    if (r.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: r.exception?.message ?? "Error");
      return;
    }

    if (r.response.isEmptyOrNull) {
      CustomSnackbar.showSnackBar(context: context, text: LocaleKeys.noResult);
      return;
    }

    final list = r.response!;

    if (list.length == 1) {
      customer = list.first;
    } else {
      final index = await CustomDialog.showDialogRadioList(
        context,
        items: list.map((e) => e.getFullName).toList(),
      );
      if (index != null) customer = list[index];
    }

    setState(() {});

    await Future.delayed(200.toDuration);

    customerController.updateTexts!.call();
  }

  Future<void> _getVehicle(MapEntry<String, Object> where, bool ask) async {
    CustomProgressIndicator.showProgressIndicator(context);
    final r = await FFirestore.getVehicles(limit: 1, equalTo: where);
    context.pop();

    if (r.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.errorFindingVehicle);
      return;
    }

    final list = r.response;

    if (list.isEmptyOrNull) {
      CustomSnackbar.showSnackBar(context: context, text: LocaleKeys.noResult);
      return;
    }

    list!.insert(
      0,
      MVehicle(
        plate: LocaleKeys.newService,
      ),
    );

    if (ask) {
      final i = await CustomDialog.showDialogRadioList(
        context,
        title: LocaleKeys.vehicle,
        items:
            list.map((e) => e.plate?.withSpaces.toUpperCase() ?? "-").toList(),
      );

      if (i == null || i == 0) return;
    }

    final s = list.last;

    vehicle.plate = s.plate;
    vehicle.vehicleMake = s.vehicleMake;
    vehicle.vehicleModel = s.vehicleModel;
    vehicle.vehicleModelDetail = s.vehicleModelDetail;
    vehicle.chassisNo = s.chassisNo;
    vehicle.engineNo = s.engineNo;
    vehicle.vehicleYear = s.vehicleYear;
    vehicle.color = s.color;
    vehicle.kilometer = s.kilometer;
    vehicle.customerID = s.customerID;

    setState(() {});

    await Future.delayed(200.toDuration);

    vehicleController.updateTextFields?.call();
  }
}
