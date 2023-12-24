// ignore_for_file: use_build_context_synchronously

part of 'main_page_view.dart';

mixin _MixinMainPage<T extends StatefulWidget> on State<T> {
  ScrollController scrollController = ScrollController();
  List<MService>? services;

  bool isError = false;

  @override
  void initState() {
    super.initState();

    context.afterBuild((p0) => _afterBuild());
  }

  Future<void> _afterBuild() async {
    final r = await FFirestore.getServices();
    if (r.hasError) {
      setState(() {
        isError = true;
      });
      return;
    }

    services = r.response ?? [];
    setState(() {});
  }

  Future<void> addNewService() async {
    final r = await context.push<MService>(PagePaths.service);
    if (r == null) return;

    services!.insert(0, r);
    setState(() {});
    await Future.delayed(200.toDuration);
    scrollController.animateTo(0, duration: 500.toDuration, curve: Curves.ease);
  }

  Future<void> onTap(int i) async {
    final s = services![i];

    if (s.customer == null) {
      CustomProgressIndicator.showProgressIndicator(context);

      final r = await FFirestore.get(FirestoreCol.shops,
          doc: FAuth.uid,
          subs: [FirestoreSub(col: FirestoreCol.customers, doc: s.customerID)]);

      context.pop();
      if (r.hasError) {
        CustomSnackbar.showSnackBar(
            context: context, text: r.exception?.message ?? "");
        return;
      }

      s.customer = MCustomer.fromJson(r.response!.data()!);
    }
    if (s.vehicle == null) {
      CustomProgressIndicator.showProgressIndicator(context);

      final r = await FFirestore.get(FirestoreCol.shops,
          doc: FAuth.uid,
          subs: [FirestoreSub(col: FirestoreCol.vehicles, doc: s.vehicleID)]);

      context.pop();
      if (r.hasError) {
        CustomSnackbar.showSnackBar(
            context: context, text: r.exception?.message ?? "");
        return;
      }

      s.vehicle = MVehicle.fromJson(r.response!.data()!);
    }

    services![i] = s;

    context.push(PagePaths.service, extra: s);
  }

  void goSearch() {
    context.push(PagePaths.search);
  }
}
