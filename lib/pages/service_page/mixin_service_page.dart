// ignore_for_file: use_build_context_synchronously

part of 'service_page_view.dart';

mixin _MixinNewService on State<ServicePageView> {
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
  bool _customerExists = false;

  bool _isVehicleAlreadyChecked = false;
  bool _shouldSetVehicle = false;
  bool _vehicleExists = false;

  String? _customerID;
  String? _vehicleID;

  Future<void> initialize(MService? s) async {
    if (s != null) {
      service = s;
      customer = s.customer!;
      vehicle = s.vehicle!;
      isNew = false;
    }
    context.afterBuild(
      (p0) async {
        if (widget.findCustomer != null) {
          await findCustomer(widget.findCustomer!);
        }
        if (widget.findVehicle != null) {
          await findVehicle(widget.findVehicle!);
        }
      },
    );
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

    await context.push<List<MapEntry<String, String>>>(PagePaths.scanner,
        extra: ServicePages.values[page]);
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
    if (!_customerExists) {
      customer = customerController.receiveCustomer!.call(customer);
    }
    if (!_vehicleExists) {
      vehicle = vehicleController.receiveVehicle!.call(vehicle);
    }

    service = serviceController.receiveService!.call(service);
    service = priceController.receiveService!.call(service);
    service.customer = customer;

    service.vehicle = vehicle;
    service.customer = customer;
    service.kilometer ??= vehicle.kilometer;
    service.customerFullName = customer.getFullName;
    service.plate = vehicle.plate;

    service.customerID = customer.docID;
    service.vehicleID = vehicle.docID;
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

    if (!_isCustomerAlreadyChecked &&
        !_customerExists &&
        await _checkCustomerExist()) return;

    if (_shouldSetCustomer && await _setCustomer()) return;

    _customerID ??= customer.docID;
    vehicle.customerID = customer.docID ?? _customerID;
    service.customerID ??= customer.docID ?? _customerID;

    if (!_isVehicleAlreadyChecked &&
        !_vehicleExists &&
        await _checkVehicleExist()) return;

    if (_shouldSetVehicle && await _setVehicle()) return;

    _vehicleID ??= vehicle.docID;
    service.vehicleID ??= vehicle.docID ?? _vehicleID;

    if (await _setService()) return;

    if (_customerExists && customer.docID.isNotEmptyAndNull) {
      FFirestore.update(
        FirestoreCol.shops,
        FAuth.uid,
        {
          'lastServiceAt': FieldValue.serverTimestamp(),
          'serviceCount': FieldValue.increment(1),
        },
        subs: [
          FirestoreSub(col: FirestoreCol.customers, doc: customer.docID),
        ],
      );
    }

    if (_vehicleExists && vehicle.docID.isNotEmptyAndNull) {
      FFirestore.update(
        FirestoreCol.shops,
        FAuth.uid,
        {
          'lastServiceAt': FieldValue.serverTimestamp(),
          'serviceCount': FieldValue.increment(1),
        },
        subs: [
          FirestoreSub(col: FirestoreCol.vehicles, doc: vehicle.docID),
        ],
      );
    }

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

    _shouldSetCustomer = true;

    return true;
  }

  Future<bool> _checkVehicleExist() async {
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

    _vehicleID = vehicle.docID;

    vehicleController.updateTextFields?.call();

    _vehicleExists = true;

    return true;
  }

  Future<void> onUpdate() async {
    final preService = _getServiceMapForUpdate(service);

    final doc = service.docID;

    _getDatas();

    final newService = _getServiceMapForUpdate(service);

    if (preService != newService) {
      CustomProgressIndicator.showProgressIndicator(context);

      final r = await FFirestore.update(
        FirestoreCol.shops,
        FAuth.uid,
        newService,
        subs: [
          FirestoreSub(col: FirestoreCol.services, doc: doc),
        ],
      );

      context.pop();

      if (r.hasError) {
        _error(r);
        return;
      }
    } else {
      CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.nothingChanged);
      return;
    }

    context.pop(service);
  }

  Map<String, dynamic> _getServiceMapForUpdate(MService s) {
    final j = s.toJson();

    if (j.containsKey("vehicleID")) j.remove("vehicleID");
    if (j.containsKey("customerID")) j.remove("customerID");
    if (j.containsKey("createdAt")) j.remove("createdAt");
    if (j.containsKey("plate")) j.remove("plate");
    if (j.containsKey("customerFullName")) j.remove("customerFullName");

    return j;
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
    if (await _getCustomer(where)) {
      _customerExists = true;
      _vehicleExists =
          await _getVehicle(MapEntry("customerID", customer.docID!), true);
    }
  }

  Future<void> findVehicle(String plate) async {
    await _getVehicle(
        MapEntry("plate", plate.removeSpaces.toLowerCase()), false);
    if (vehicle.customerID.isEmptyOrNull) return;
    _customerExists =
        await _getCustomer(MapEntry("docID", vehicle.customerID!));
  }

  Future<void> deleteService() async {
    final sure = await SureDialog.areYouSure(context);

    if (!sure) return;

    await FFirestore.delete(FirestoreCol.shops, FAuth.uid,
        subs: [FirestoreSub(col: FirestoreCol.services, doc: service.docID!)]);
    await FFirestore.update(
      FirestoreCol.shops,
      FAuth.uid,
      subs: [
        FirestoreSub(
          col: FirestoreCol.customers,
          doc: customer.docID!,
        )
      ],
      {"serviceCount": FieldValue.increment(-1)},
    );
    await FFirestore.update(
      FirestoreCol.shops,
      FAuth.uid,
      subs: [
        FirestoreSub(
          col: FirestoreCol.vehicles,
          doc: vehicle.docID!,
        )
      ],
      {"serviceCount": FieldValue.increment(-1)},
    );

    context.pop(0);
  }

  Future<void> deleteCar() async {
    if (!await SureDialog.areYouSure(context)) return;

    await FFirestore.delete(FirestoreCol.shops, FAuth.uid,
        subs: [FirestoreSub(col: FirestoreCol.vehicles, doc: vehicle.docID!)]);
    await FFirestore.delete(FirestoreCol.shops, FAuth.uid,
        subs: [FirestoreSub(col: FirestoreCol.services, doc: service.docID!)]);
    context.pop(0);
  }

  Future<bool> _getCustomer(MapEntry<String, Object> where) async {
    CustomProgressIndicator.showProgressIndicator(context);
    final r = await FFirestore.getCustomers(equalTo: where);
    context.pop();

    if (r.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: r.exception?.message ?? "Error");
      return false;
    }

    if (r.response.isEmptyOrNull) {
      CustomSnackbar.showSnackBar(context: context, text: LocaleKeys.noResult);
      return false;
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

    return true;
  }

  Future<bool> _getVehicle(MapEntry<String, Object> where, bool ask) async {
    CustomProgressIndicator.showProgressIndicator(context);
    final r = await FFirestore.getVehicles(limit: 20, equalTo: where);
    context.pop();

    if (r.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.errorFindingVehicle);
      return false;
    }

    final list = r.response;

    if (list.isEmptyOrNull) {
      CustomSnackbar.showSnackBar(context: context, text: LocaleKeys.noResult);
      return false;
    }

    list!.insert(
      0,
      MVehicle(
        plate: LocaleKeys.newService,
      ),
    );

    int? selectedVehicleIndex;

    if (ask) {
      selectedVehicleIndex = await CustomDialog.showDialogRadioList(
        context,
        title: LocaleKeys.vehicle,
        items:
            list.map((e) => e.plate?.withSpaces.toUpperCase() ?? "-").toList(),
      );

      if (selectedVehicleIndex == null || selectedVehicleIndex == 0) {
        return false;
      }
    }

    if (selectedVehicleIndex != null) {
      vehicle = list[selectedVehicleIndex];
    } else {
      vehicle = list.last;
    }

    setState(() {});

    await Future.delayed(200.toDuration);

    vehicleController.updateTextFields?.call();

    return true;
  }

  void _error(FirestoreResponse response) {
    CustomSnackbar.showSnackBar(
        context: context, text: "Error ${response.exception?.message}");
  }
}
