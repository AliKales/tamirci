// ignore_for_file: use_build_context_synchronously

part of 'loading_page_view.dart';

mixin _MixinLoadingPage<T extends StatefulWidget> on State<T> {
  String message = "";

  bool get isLoading => message.isEmptyOrNull;

  @override
  void initState() {
    super.initState();
    context.afterBuild((p0) => _afterBuild());
  }

  Future<void> _afterBuild() async {
    if (!await _handleEmailVerification()) return;
    if (!await _getUser()) return;

    context.go(PagePaths.main);
  }

  Future<bool> _getUser() async {
    final r = await FFirestore.get(FirestoreCol.shops, doc: FAuth.uid);

    if (r.hasError) {
      if (r.exception!.code == "permission-denied") {
        message = LocaleKeys.pleasePayment;
      } else {
        message = r.exception?.message ?? "Error";
      }
      setState(() {});
      return false;
    }

    if (!r.response!.exists) {
      context.go(PagePaths.createShop);
      return false;
    }

    LocalValues.shop = MShop.fromJson(r.response!.data().toStringDynamic!);

    return true;
  }

  Future<bool> _handleEmailVerification() async {
    final emailVerified = HHive.getSettings(HiveSettings.emailVerified) ??
        await FAuth.isEmailVerified();

    if (!emailVerified) {
      final time = HHive.getSettings(HiveSettings.emailVerificationSentAt);
      String? e;

      if (time == null || _canSend(DateTime.parse(time))) {
        e = await FAuth.sendVerification();
      }

      String m = LocaleKeys.emailVerification;

      if (e.isNotEmptyAndNull) {
        m = e!;
      } else {
        await HHive.putSettings(HiveSettings.emailVerificationSentAt,
            DateTime.now().toIso8601String());
      }

      setState(() {
        message = m;
      });
      return false;
    }

    await HHive.putSettings(HiveSettings.emailVerified, true);

    return true;
  }

  bool _canSend(DateTime last) {
    final now = DateTime.now();

    return now.difference(last).inMinutes > 5;
  }

  void sendReminder() {
    const email = "suggestionsandhelp@hotmail.com";
    const subject = "Tamirci odeme";
    final body = "Ödeme için bir hatırlatma. Kullanıcı ID: ${FAuth.uid}";
    UrlLauncher.sendMail(email, subject, body);
  }
}
