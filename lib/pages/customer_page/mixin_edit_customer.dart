import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/firebase/f_firestore.dart';

mixin MixinEditCustomer {
  void editCustomer({
    required BuildContext context,
    required String customerId,
    required String key,
    required dynamic val,
  }) {
    FFirestore.update(
      FirestoreCol.customers,
      customerId,
      {key: val},
    );

    CustomSnackbar.showSnackBar(
        context: context, text: "Değişiklik kaydedildi!");
  }
}
