part of 'new_service_page_view.dart';

mixin _MixinNewService<T extends StatefulWidget> on State<T> {
  final controller = PageController();

  final customerController = CustomerViewController();
  final vehicleController = ServiceController();
  final serviceController = ServiceController();
  final priceController = ServiceController();

  MService service = MService(createdAt: DateTime.now());
  MCustomer customer = MCustomer(phoneCountryCode: 90);

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

  void onDone() {
    customer = customerController.receiveCustomer!.call();
    service = vehicleController.receiveService!.call(service);
    service = serviceController.receiveService!.call(service);
    service = priceController.receiveService!.call(service);
  }
}
