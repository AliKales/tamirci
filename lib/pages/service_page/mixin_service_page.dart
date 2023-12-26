// ignore_for_file: use_build_context_synchronously

part of 'service_page_view.dart';

mixin _MixinNewService<T extends StatefulWidget> on State<T> {
  final controller = PageController();

  final customerController = CustomerViewController();
  final vehicleController = VehicleController();
  final serviceController = ServiceController();
  final priceController = ServiceController();

  final showFAB = ValueNotifier(false);

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

  bool _isCustomerAlreadyChecked = false;
  bool _shouldSetCustomer = false;
  bool _isVehicleAlreadyChecked = false;
  bool _shouldSetVehicle = false;

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

    service.vehicle = vehicle;
    service.customer = customer;

    service.kilometer ??= vehicle.kilometer;

    service.customerFullName = customer.getFullName;
    service.plate = vehicle.plate;
  }

  Future<void> onAddNew() async {
    _getDatas();

    if (customer.phone == null || customer.phoneCountryCode == null) {
      CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.phoneCantNull);
      controller.animateToPage(0, duration: 200.toDuration, curve: Curves.ease);
      return;
    }

    if (vehicle.plate.isEmptyOrNull) {
      CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.plateCantNull);

      controller.animateToPage(1, duration: 200.toDuration, curve: Curves.ease);
      return;
    }

    if (!_isCustomerAlreadyChecked && await _checkCustomerExist()) return;

    if (_shouldSetCustomer && await _setCustomer()) return;

    vehicle.customerID = customer.docID;
    service.customerID = customer.docID;

    if (!_isVehicleAlreadyChecked && await _checkVehicle()) return;

    if (_shouldSetVehicle && await _setVehicle()) return;

    service.vehicleID = vehicle.docID;

    if (await _setService()) return;

    context.pop(service);
  }

  Future<bool> _setService() async {
    CustomProgressIndicator.showProgressIndicator(context);

    final r = await FFirestore.set(
      FirestoreCol.shops,
      doc: FAuth.uid,
      map: service.toJson(),
      subs: [
        FirestoreSub(col: FirestoreCol.services),
      ],
    );

    context.pop();

    if (r.hasError) {
      _error(r);
      return true;
    }

    service.docID = r.docID;

    return false;
  }

  Future<bool> _setVehicle() async {
    CustomProgressIndicator.showProgressIndicator(context);

    final r = await FFirestore.set(
      FirestoreCol.shops,
      doc: FAuth.uid,
      map: vehicle.toJson(),
      subs: [
        FirestoreSub(col: FirestoreCol.vehicles),
      ],
    );

    context.pop();

    if (r.hasError) {
      _error(r);
      return true;
    }

    vehicle.docID = r.docID;
    _shouldSetVehicle = false;

    return false;
  }

  Future<bool> _setCustomer() async {
    CustomProgressIndicator.showProgressIndicator(context);
    final r = await FFirestore.set(
      FirestoreCol.shops,
      doc: FAuth.uid,
      map: customer.toJson(),
      subs: [
        FirestoreSub(col: FirestoreCol.customers),
      ],
    );

    context.pop();

    if (r.hasError) {
      _error(r);
      return true;
    }

    customer.docID = r.docID;

    _shouldSetCustomer = false;

    return false;
  }

  Future<bool> _checkCustomerExist() async {
    CustomProgressIndicator.showProgressIndicator(context);

    final r = await FFirestore.getCustomers(
        equalTo: MapEntry("phone", customer.phone!), limit: 1);

    context.pop();

    if (r.hasError) {
      _error(r);
      return true;
    }

    _isCustomerAlreadyChecked = true;

    if (r.response.isEmptyOrNull) {
      _shouldSetCustomer = true;
      return false;
    }

    await CustomDialog.showCustomDialog(
      context,
      title: LocaleKeys.warning,
      text: LocaleKeys.thisCustomerAlreadyExistsTryAgain,
    );

    setState(() {
      customer = r.response!.first;
    });

    customerController.updateTexts?.call();

    return true;
  }

  Future<bool> _checkVehicle() async {
    CustomProgressIndicator.showProgressIndicator(context);

    final r = await FFirestore.getVehicles(
        equalTo: MapEntry("plate", vehicle.plate!), limit: 1);

    context.pop();

    if (r.hasError) {
      _error(r);
      return true;
    }

    _isVehicleAlreadyChecked = true;

    if (r.response.isEmptyOrNull) {
      _shouldSetVehicle = true;
      return false;
    }

    await CustomDialog.showCustomDialog(
      context,
      title: LocaleKeys.warning,
      text: LocaleKeys.thisVehicleAlreadyExistsTryAgain,
    );

    setState(() {
      vehicle = r.response!.first;
    });

    vehicleController.updateTextFields?.call();

    return true;
  }

  Future<void> onUpdate() async {
    final preCustomer = customer.toJson();
    final preVehicle = vehicle.toJson();
    final preService = service.toJson();

    _getDatas();

    CustomProgressIndicator.showProgressIndicator(context);

    if (preCustomer != customer.toJson()) {
      await FFirestore.update(
        FirestoreCol.shops,
        FAuth.uid,
        customer.toJson(),
        subs: [
          FirestoreSub(
              col: FirestoreCol.customers, doc: customer.phone.toString()),
        ],
      );
    }
    if (preVehicle != vehicle.toJson()) {
      await FFirestore.update(
        FirestoreCol.shops,
        FAuth.uid,
        vehicle.toJson(),
        subs: [
          FirestoreSub(col: FirestoreCol.vehicles, doc: vehicle.plate),
        ],
      );
    }
    if (preService != service.toJson()) {
      await FFirestore.update(
        FirestoreCol.shops,
        FAuth.uid,
        service.toJson(),
        subs: [
          FirestoreSub(col: FirestoreCol.services, doc: service.docID),
        ],
      );
    }

    context.pop(service);
  }

  void onPageChanged(int? i) {
    if (i == null) return;

    if (i == 4) {
      showFAB.value = true;
    } else {
      showFAB.value = false;
    }
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

  void _error(FirestoreResponse response) {
    CustomSnackbar.showSnackBar(
        context: context, text: "Error ${response.exception?.message}");
  }
}
