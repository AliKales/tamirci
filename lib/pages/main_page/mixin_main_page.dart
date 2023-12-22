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

  void onTap(int i) {
    context.push(PagePaths.service, extra: services![i]);
  }

  void goSearch() {
    context.push(PagePaths.search);
  }
}
