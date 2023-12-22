import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/buttons.dart';

class CustomerPageView extends StatefulWidget {
  const CustomerPageView({super.key, required this.customer});

  final MCustomer customer;

  @override
  State<CustomerPageView> createState() => _CustomerPageViewState();
}

class _CustomerPageViewState extends State<CustomerPageView> {
  MCustomer get customer => widget.customer;

  void _copyName() {
    _copy(customer.getFullName, LocaleKeys.nameSurname);
  }

  void _copyPhone() {
    _copy(customer.getPhone, LocaleKeys.phone);
  }

  void _copyIdNo() {
    _copy(customer.idNo.toString(), LocaleKeys.idNo);
  }

  void _copyTax() {
    _copy(customer.taxNo.toString(), LocaleKeys.taxNo);
  }

  void _copyAddress() {
    _copy(customer.address ?? "--", LocaleKeys.address);
  }

  void _copy(String data, String label) {
    Clipboard.setData(ClipboardData(text: data));
    CustomSnackbar.showSnackBar(
        context: context, text: "$label ${LocaleKeys.copied}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Theme(
        data: Theme.of(context).copyWith(
            listTileTheme: ListTileThemeData(
          titleTextStyle: context.textTheme.titleLarge,
        )),
        child: Padding(
          padding: LocalValues.paddingPage(context),
          child: Column(
            children: [
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.person_4),
                iconSize: 80,
              ),
              const SizedBox(height: 30),
              ListTile(
                title: Text(customer.getFullName),
                leading: const Icon(Icons.person),
                onTap: _copyName,
              ),
              ListTile(
                title: Text(customer.getPhone),
                leading: const Icon(Icons.phone),
                onTap: _copyPhone,
              ),
              ListTile(
                title: Text("${LocaleKeys.idNo}: ${customer.idNo}"),
                leading: const Icon(Icons.info_rounded),
                onTap: _copyIdNo,
              ),
              ListTile(
                title: Text("${LocaleKeys.taxNo}: ${customer.taxNo}"),
                leading: const Icon(Icons.info),
                onTap: _copyTax,
              ),
              ListTile(
                title: Text(customer.address ?? "---"),
                leading: const Icon(Icons.home),
                onTap: _copyAddress,
              ),
              const Spacer(),
              Buttons(context, LocaleKeys.makeCall, () {}).filled(),
              const Spacer(),
              Buttons(context, LocaleKeys.sendIBAN, () {}).outlined(),
              const Spacer(),
            ],
          ).center,
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.customer),
    );
  }
}
