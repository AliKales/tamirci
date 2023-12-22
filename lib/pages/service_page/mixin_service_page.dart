// ignore_for_file: use_build_context_synchronously

part of 'service_page_view.dart';

mixin _MixinNewService<T extends StatefulWidget> on State<T> {
  final controller = PageController();

  final customerController = CustomerViewController();
  final vehicleController = ServiceController();
  final serviceController = ServiceController();
  final priceController = ServiceController();

  MService service = MService(createdAt: DateTime.now());
  MCustomer customer = MCustomer(phoneCountryCode: 90);

  int get currentPage => controller.page?.toInt() ?? 0;

  bool isNew = true;

  void initialize(MService? s) {
    if (s != null) {
      service = s;
      customer = s.customer!;
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
    customer = customerController.receiveCustomer!.call();
    service = vehicleController.receiveService!.call(service);
    service = serviceController.receiveService!.call(service);
    service = priceController.receiveService!.call(service);
    service.customer = customer;
  }

  Future<void> onAddNew() async {
    _getDatas();

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

    service.customerID = customerResult.docID;

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
}
