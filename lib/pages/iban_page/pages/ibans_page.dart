part of '../iban_page_view.dart';

class _IbansPage extends StatefulWidget {
  const _IbansPage({super.key, required this.ibans, required this.addNewIban});

  final List<MIban> ibans;
  final ValueChanged<MIban> addNewIban;

  @override
  State<_IbansPage> createState() => __IbansPageState();
}

class __IbansPageState extends State<_IbansPage>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _tECName;
  late TextEditingController _tECBankName;
  late TextEditingController _tECIban;

  bool _showTextFields = false;

  List<MIban> get _ibans => widget.ibans;

  @override
  void dispose() {
    if (_showTextFields) {
      _tECName.dispose();
      _tECIban.dispose();
      _tECBankName.dispose();
    }
    super.dispose();
  }

  void _addNewIban() {
    _tECName = TextEditingController();
    _tECBankName = TextEditingController();
    _tECIban = TextEditingController();

    setState(() {
      _showTextFields = true;
    });
  }

  void _add() {
    final name = _tECName.textTrim;
    final bankName = _tECBankName.textTrim;
    final iban = _tECIban.textTrim;

    if (name.isEmpty || bankName.isEmpty || iban.isEmpty) {
      CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.pleaseFillBlanks);
      return;
    }

    if (_ibans.indexWhere((e) => e.ibanNo == iban) != -1) {
      CustomSnackbar.showSnackBar(
          context: context, text: LocaleKeys.ibanExists);
      return;
    }

    final newIban = MIban(fullName: name, bankName: bankName, ibanNo: iban);

    _tECBankName.clear();
    _tECIban.clear();
    _tECName.clear();

    widget.addNewIban.call(newIban);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: LocalValues.paddingPage(context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _listView(),
            const SizedBox(height: 20),
            _showTextFields
                ? _textFields()
                : Buttons(context, LocaleKeys.addNewIban, _addNewIban)
                    .outlined(),
          ],
        ),
      ),
    );
  }

  Column _textFields() {
    return Column(
      children: [
        CTextField(
          label: LocaleKeys.nameSurname,
          controller: _tECName,
        ),
        CTextField(
          label: LocaleKeys.bankName,
          controller: _tECBankName,
        ),
        CTextField(
          label: LocaleKeys.iban,
          controller: _tECIban,
        ),
        Buttons(context, LocaleKeys.add, _add).filled(),
      ],
    );
  }

  ListView _listView() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _item(index);
      },
      separatorBuilder: (context, i) => const Divider(),
      itemCount: _ibans.length,
      shrinkWrap: true,
    );
  }

  Padding _item(int i) {
    final iban = _ibans[i];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          _text(iban.fullName.toUpperCase()),
          _text(iban.bankName.toUpperCase()),
          _text(iban.ibanNo),
          IconButton(
            onPressed: () {
              iban.ibanNo.copy();
              CustomSnackbar.showSnackBar(
                  context: context, text: LocaleKeys.ibanCopied);
            },
            icon: const Icon(Icons.copy),
          )
        ],
      ),
    );
  }

  Text _text(String text) {
    return Text(
      text,
      style: context.textTheme.titleLarge,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
