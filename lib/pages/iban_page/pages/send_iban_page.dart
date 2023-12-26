part of '../iban_page_view.dart';

class _SendIbanPage extends StatefulWidget {
  const _SendIbanPage({super.key, required this.ibans});

  final List<MIban> ibans;

  @override
  State<_SendIbanPage> createState() => __SendIbanPageState();
}

class __SendIbanPageState extends State<_SendIbanPage>
    with AutomaticKeepAliveClientMixin {
  final _tECCountryCode = TextEditingController(text: "90");
  final _tECPhone = TextEditingController();

  List<MIban> get _ibans => widget.ibans;

  String _selectedIban = "";

  @override
  void initState() {
    super.initState();
    _selectedIban = _ibans.firstOrNull?.ibanNo ?? "";
  }

  @override
  void dispose() {
    _tECCountryCode.dispose();
    _tECPhone.dispose();
    super.dispose();
  }

  void _send() {
    final phone = _tECPhone.textTrim;
    final countryCode = _tECCountryCode.textTrim;

    if (phone.isEmpty || countryCode.isEmpty) {
      CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.pleaseFillBlanks);
      return;
    }

    UrlLauncher.sendSMS("+$countryCode$phone", _selectedIban);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: LocalValues.paddingPage(context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            PhoneTextField(
                tECCountryCode: _tECCountryCode, tECPhone: _tECPhone),
            ..._ibans
                .map(
                  (e) => RadioListTile<String>(
                    value: e.ibanNo,
                    groupValue: _selectedIban,
                    onChanged: (value) {
                      setState(() {
                        _selectedIban = value ?? "";
                      });
                    },
                    title: Text(e.bankName),
                  ),
                )
                .toList(),
            const SizedBox(height: 10),
            Buttons(context, LocaleKeys.sendIBAN, _send).filled(),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
