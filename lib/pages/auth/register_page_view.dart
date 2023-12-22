// ignore_for_file: use_build_context_synchronously

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/firebase/f_auth.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/router.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_text_field.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPageView> {
  final _tECEmail = TextEditingController();
  final _tECPass = TextEditingController();
  final _tECPass2 = TextEditingController();

  @override
  void dispose() {
    _tECEmail.dispose();
    _tECPass.dispose();
    _tECPass2.dispose();
    super.dispose();
  }

  void _login() {
    context.go(PagePaths.login);
  }

  Future<void> _register() async {
    final email = _tECEmail.textTrim;
    final pass = _tECPass.textTrim;
    final pass2 = _tECPass2.textTrim;

    if (email.isEmptyOrNull) {
      _snackbar(LocaleKeys.emailCantEmpty);
      return;
    }
    if (pass.isEmptyOrNull || pass2.isEmptyOrNull) {
      _snackbar(LocaleKeys.passwordCantEmpty);
      return;
    }
    if (pass.length < 6) {
      _snackbar(LocaleKeys.pass6Length);
      return;
    }
    if (pass != pass2) {
      _snackbar(LocaleKeys.passNotMatch);
      return;
    }

    CustomProgressIndicator.showProgressIndicator(context);
    final r = await FAuth.signUp(email, pass);
    context.pop();

    if (r.isNotEmptyAndNull) {
      _snackbar(FAuth.errorLocal(r!));
      return;
    }

    context.go(PagePaths.loading);
  }

  void _snackbar(String e) {
    CustomSnackbar.showSnackBar(context: context, text: e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: LocalValues.paddingPage(context),
        child: Column(
          children: [
            CTextField(
              label: LocaleKeys.email,
              controller: _tECEmail,
            ),
            CTextField(
              label: LocaleKeys.password,
              controller: _tECPass,
            ),
            CTextField(
              label: LocaleKeys.password,
              controller: _tECPass2,
            ),
            Buttons(context, LocaleKeys.register, _register).filled(),
            context.sizedBox(height: Values.paddingHeightSmallXX),
            Buttons(context, LocaleKeys.login, _login).textB(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.register),
    );
  }
}
