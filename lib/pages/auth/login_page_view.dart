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

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPageView> {
  final _tECEmail = TextEditingController();
  final _tECPassword = TextEditingController();

  @override
  void dispose() {
    _tECEmail.dispose();
    _tECPassword.dispose();
    super.dispose();
  }

  void _register() {
    context.go(PagePaths.register);
  }

  Future<void> _login() async {
    final email = _tECEmail.textTrim;
    final password = _tECPassword.textTrim;

    if (email.isEmptyOrNull) {
      _snackbar(LocaleKeys.emailCantEmpty);
      return;
    }
    if (password.isEmptyOrNull) {
      _snackbar(LocaleKeys.passwordCantEmpty);
      return;
    }
    if (password.length < 6) {
      _snackbar(LocaleKeys.pass6Length);
      return;
    }

    CustomProgressIndicator.showProgressIndicator(context);
    final f = await FAuth.logIn(email, password);
    context.pop();
    if (f.isNotEmptyAndNull) {
      _snackbar(FAuth.errorLocal(f!));
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
              controller: _tECPassword,
            ),
            Buttons(context, LocaleKeys.login, _login).filled(),
            context.sizedBox(height: Values.paddingHeightSmallXX),
            Buttons(context, LocaleKeys.register, _register).textB(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.login),
    );
  }
}
