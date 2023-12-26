// ignore_for_file: use_build_context_synchronously

import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/firebase/f_auth.dart';
import 'package:tamirci/core/firebase/f_firestore.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_shop.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/router.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_text_field.dart';

class CreateShopPageView extends StatefulWidget {
  const CreateShopPageView({super.key});

  @override
  State<CreateShopPageView> createState() => _CreateShopPageViewState();
}

class _CreateShopPageViewState extends State<CreateShopPageView> {
  final _tECName = TextEditingController();
  final _tECShopName = TextEditingController();
  final _tECPhone = TextEditingController();

  @override
  void dispose() {
    _tECName.dispose();
    _tECShopName.dispose();
    _tECPhone.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _tECName.textTrim;
    final shopName = _tECShopName.textTrim;
    final phone = _tECPhone.textTrim;

    if (name.isEmptyOrNull || shopName.isEmptyOrNull || phone.isEmptyOrNull) {
      CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.pleaseFillBlanks);
      return;
    }

    final shop = MShop(
      ownerName: name,
      shopName: shopName,
      phone: phone,
      available: false,
      createdAt: DateTime.now(),
    );

    CustomProgressIndicator.showProgressIndicator(context);
    final f = await FFirestore.set(FirestoreCol.shops,
        doc: FAuth.uid, map: shop.toJson());
    context.pop();

    if (f.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: f.exception?.code ?? "");
      return;
    }

    context.go(PagePaths.loading);
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
              label: LocaleKeys.nameSurname,
              controller: _tECName,
            ),
            CTextField(
              label: LocaleKeys.shopName,
              controller: _tECShopName,
            ),
            CTextField(
              label: LocaleKeys.phone,
              controller: _tECPhone,
            ),
            Text(
              LocaleKeys.phoneIsImportant,
              style: context.textTheme.titleMedium,
            ),
            Buttons(context, LocaleKeys.create, _add).filled(),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.createShop),
    );
  }
}
