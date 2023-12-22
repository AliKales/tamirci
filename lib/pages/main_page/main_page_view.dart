import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/firebase/f_firestore.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/router.dart';
import 'package:tamirci/widgets/service_widget/service_widget.dart';

part 'mixin_main_page.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> with _MixinMainPage {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: _fAB(),
      body: Padding(
        padding: LocalValues.paddingPage(context),
        child: services == null ? _loadBody() : _mainBody(),
      ),
    );
  }

  Widget _loadBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isError
            ? Text(
                LocaleKeys.unexpectedError,
                style: context.textTheme.titleLarge,
              )
            : const CircularProgressIndicator().center,
      ],
    ).center;
  }

  ListView _mainBody() {
    return ListView.builder(
      controller: scrollController,
      itemBuilder: (context, index) {
        return ServiceWidget(
          service: services![index],
          onTap: () => onTap(index),
        );
      },
      itemCount: services!.length,
    );
  }

  FloatingActionButton _fAB() {
    return FloatingActionButton.extended(
      onPressed: addNewService,
      label: const Text(LocaleKeys.service),
      icon: const Icon(Icons.add),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.mainPage),
      actions: [
        IconButton(
          onPressed: goSearch,
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
