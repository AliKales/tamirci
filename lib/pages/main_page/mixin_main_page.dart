// ignore_for_file: use_build_context_synchronously

part of 'main_page_view.dart';

mixin _MixinMainPage<T extends StatefulWidget> on State<T> {
  ScrollController scrollController = ScrollController();
  List<MService>? services;

  bool isError = false;

  @override
  void initState() {
    super.initState();

    context.afterBuild((p0) => load());
  }

  Future<void> load() async {
    CustomProgressIndicator.showProgressIndicator(context);
    final r = await FFirestore.getServices(
      limit: 20,
      lastDate: services?.lastOrNull?.createdAt,
    );
    context.pop();
    if (r.hasError) {
      setState(() {
        isError = true;
      });
      return;
    }

    services ??= [];
    services!.addAll((r.response ?? []));
    setState(() {});
  }

  Future<void> addNewService() async {
    final r = await context.push<MService>(PagePaths.service);
    if (r == null) return;

    int i = services!.indexWhere((e) => e.docID == r.docID);

    if (i != -1) {
      services![i] = r;
    } else {
      services!.insert(0, r);
    }

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
      if (r.response?.exists.isFalse ?? true) {
        CustomSnackbar.showSnackBar(
            context: context, text: LocaleKeys.thisVehicleDeleted);
        return;
      }
      s.vehicle = MVehicle.fromJson(r.response!.data()!);
    }

    services![i] = s;

    final r = await context.push(PagePaths.service, extra: s);

    if (r != null && r is MService) {
      services![i] = r;
    } else if (r != null && r is int) {
      services!.removeAt(i);
      setState(() {});
    }
  }

  void goSearch() {
    context.push(PagePaths.search);
  }

  void goIban() {
    context.push(PagePaths.iban);
  }

  void goStats() {
    context.push(PagePaths.stats);
  }

  Future<void> logOut() async {
    final r = await FAuth.signOut();

    if (r.isNotEmptyAndNull) {
      CustomSnackbar.showSnackBar(context: context, text: r ?? "Error");
      return;
    }

    context.go("/");
  }
}
