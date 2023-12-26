import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/h_hive.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_iban.dart';
import 'package:tamirci/core/url_launcher.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/c_text_field.dart';
import 'package:tamirci/widgets/phone_text_field.dart';

part 'pages/ibans_page.dart';
part 'pages/send_iban_page.dart';

class IbanPageView extends StatefulWidget {
  const IbanPageView({super.key});

  @override
  State<IbanPageView> createState() => _IbanPageViewState();
}

class _IbanPageViewState extends State<IbanPageView> {
  final _controller = PageController();

  List<MIban> _ibans = [];

  @override
  void initState() {
    super.initState();
    _ibans = HHive.getIbans();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addNewIban(MIban iban) {
    setState(() {
      _ibans.add(iban);
    });

    HHive.putSettings(
        HiveSettings.ibans, _ibans.map((e) => e.toJson()).toList());
  }

  void _toIbanPage() {
    _controller.animateToPage(1, duration: 200.toDuration, curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toIbanPage,
        label: const Text(LocaleKeys.sendIBAN),
        icon: const Icon(Icons.send_rounded),
      ),
      body: PageView(
        controller: _controller,
        children: [
          _IbansPage(ibans: _ibans, addNewIban: _addNewIban),
          _SendIbanPage(ibans: _ibans),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.iban),
    );
  }
}
