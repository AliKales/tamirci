import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/firebase/f_auth.dart';
import 'package:tamirci/core/firebase/f_firestore.dart';
import 'package:tamirci/core/h_hive.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_shop.dart';
import 'package:tamirci/core/url_launcher.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/router.dart';
import 'package:tamirci/widgets/buttons.dart';

part 'mixin_loading_page.dart';

class LoadingPageView extends StatefulWidget {
  const LoadingPageView({super.key});

  @override
  State<LoadingPageView> createState() => _LoadingPageViewState();
}

class _LoadingPageViewState extends State<LoadingPageView>
    with _MixinLoadingPage {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: LocalValues.paddingPage(context),
        child: _body1(),
      ),
    );
  }

  Column _body1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isLoading ? const CircularProgressIndicator().center : _messageWidget()
      ],
    );
  }

  Widget _messageWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          message,
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ).center,
        Buttons(context, LocaleKeys.remind, sendReminder).filled(),
        Text(LocaleKeys.remindInfo, style: context.textTheme.titleMedium),
      ],
    ).expanded;
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.datasGetting),
      actions: [
        if (!isLoading)
          IconButton(
            onPressed: logOut,
            icon: const Icon(Icons.logout),
          ),
      ],
    );
  }
}
