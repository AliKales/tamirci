// ignore_for_file: use_build_context_synchronously

part of 'search_page_view.dart';

enum _Filter {
  plate(LocaleKeys.plate),
  phone(LocaleKeys.phone),
  idNo(LocaleKeys.idNo),
  taxNo(LocaleKeys.taxNo),
  name(LocaleKeys.name),
  surname(LocaleKeys.lastName),
  fullName(LocaleKeys.nameSurname),
  chassisNo(LocaleKeys.chassisNo),
  engineNo(LocaleKeys.engineNo);

  final String label;

  const _Filter(this.label);
}

mixin _MixinSearchPage<T extends StatefulWidget> on State<T> {
  final controller = ScrollController();

  List<MCustomer> customers = [];
  List<MVehicle> vehicles = [];
  List<String> plates = [];

  final tECSearch = TextEditingController();
  String searchText = "";
  final isTexting = ValueNotifier(false);

  _Filter selectedFilter = _Filter.values.first;

  @override
  void dispose() {
    tECSearch.dispose();
    controller.dispose();
    super.dispose();
  }

  void onSearchText(String? t) {
    searchText = t ?? "";
    if (t == "") {
      isTexting.value = false;
    } else if (!isTexting.value) {
      isTexting.value = true;
    }

    if (t.isEmptyOrNull) {
      setState(() {
        plates = [];
      });
    } else {
      _findPlates(t!);
    }
  }

  void clearSearch() {
    tECSearch.clear();
    onSearchText("");
  }

  void onFilterChange(_Filter? filter) {
    setState(() {
      selectedFilter = filter ?? _Filter.values.first;
    });
  }

  void search() {
    final text = tECSearch.textTrim;
    if (text.isEmptyOrNull) return;

    vehicles = [];
    customers = [];

    switch (selectedFilter) {
      case _Filter.plate:
        _searchVehicle(MapEntry("plate", _getPlate(text)));
      case _Filter.phone:
        _searchByCustomerPhone(text);
      case _Filter.idNo:
        _searchByIdNo(text);
      case _Filter.name:
        _searchCustomer(MapEntry("name", text.toLowerCase()));
      case _Filter.surname:
        _searchCustomer(MapEntry("surname", text.toLowerCase()));
      case _Filter.fullName:
        _searchCustomer(MapEntry("fullName", text.removeSpaces.toLowerCase()));
      case _Filter.chassisNo:
        _searchVehicle(MapEntry("chassisNo", text.toUpperCase()));
      case _Filter.engineNo:
        _searchVehicle(MapEntry("engineNo", text));
      default:
    }
  }

  Future<void> _findPlates(String val) async {
    final res = await FFirestore.vehicleInstance
        .where('plate', isGreaterThanOrEqualTo: _getPlate(val))
        .where('plate', isLessThanOrEqualTo: '${_getPlate(val)}\uf8ff')
        .limit(10)
        .get();
    plates = res.docs.map((e) => MVehicle.fromJson(e.data()).plate!).toList();
    setState(() {});
  }

  String _getPlate(String text) => text.replaceAll(" ", "").toLowerCase();

  Future<void> _searchVehicle(MapEntry<String, Object> where) async {
    CustomProgressIndicator.showProgressIndicator(context);

    final r = await FFirestore.getVehicles(equalTo: where);

    context.pop();

    if (r.hasError) {
      _error(_convertErrorToMessage(r.exception));
      return;
    }

    setState(() {
      vehicles = r.response ?? [];
    });

    _scrollToEnd();
  }

  Future<void> _searchByIdNo(String text) async {
    if (!RegExp(r'[0-9]').hasMatch(text)) {
      _error(LocaleKeys.idNoOnlyDigits);
      return;
    }

    await _searchCustomer(MapEntry("idNo", text.toInt));
  }

  Future<void> _searchByCustomerPhone(String text) async {
    if (!RegExp(r'[0-9]').hasMatch(text)) {
      _error(LocaleKeys.phoneOnlyDigits);
      return;
    }

    FirestoreResponse<List<MCustomer>>? response;

    CustomProgressIndicator.showProgressIndicator(context);

    if (text.startsWith("0")) {
      String newText = text.replaceFirst("0", "");
      response = await FFirestore.getCustomers(
          equalTo: MapEntry("phone", newText.toInt));
    }

    if (response == null || response.response == null) {
      response =
          await FFirestore.getCustomers(equalTo: MapEntry("phone", text.toInt));
    }

    context.pop();

    if (response.hasError) {
      _error(_convertErrorToMessage(response.exception));
      return;
    }

    if (response.response == null) {
      _error(LocaleKeys.noResult);
      return;
    }

    setState(() {
      customers.addAll(response!.response!);
    });

    _scrollToEnd();
  }

  Future<void> _searchCustomer(MapEntry<String, Object> where) async {
    CustomProgressIndicator.showProgressIndicator(context);

    final r = await FFirestore.getCustomers(equalTo: where);

    context.pop();

    if (r.hasError) {
      _error(_convertErrorToMessage(r.exception));
      return;
    }

    setState(() {
      customers = r.response ?? [];
    });

    _scrollToEnd();
  }

  Future<void> _scrollToEnd() async {
    await Future.delayed(100.toDuration);
    controller.animateTo(controller.max,
        duration: 200.toDuration, curve: Curves.ease);
  }

  String _convertErrorToMessage(FirebaseException? exception) {
    return "Hata: ${exception?.message}";
  }

  void _error(String text) {
    CustomSnackbar.showSnackBar(context: context, text: text);
  }

  void onUserTap(int i) {
    final c = customers[i];
    context.push(PagePaths.customer, extra: c);
  }

  Future<void> onVehicleTap(int i) async {
    CustomProgressIndicator.showProgressIndicator(context);
    final v = vehicles[i];
    final r = await FFirestore.getCustomer(id: v.customerID!);
    context.pop();

    if (r.hasError) {
      _error(r.exception?.message ?? "");
      return;
    }

    context.push(PagePaths.vehicle, extra: MapEntry(r.response!, v));
  }
}
