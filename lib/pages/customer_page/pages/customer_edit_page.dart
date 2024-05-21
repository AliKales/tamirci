import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/firebase/f_firestore.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/widgets/buttons.dart';

class CustomerEditPageView extends StatefulWidget {
  const CustomerEditPageView(
      {super.key, required this.customer, required this.type});

  final MCustomer customer;
  final CustomerEditTypes type;

  @override
  State<CustomerEditPageView> createState() => _CustomerEditPageViewState();
}

class _CustomerEditPageViewState extends State<CustomerEditPageView> {
  late TextEditingController _tEC;
  late TextEditingController _tECName;
  late TextEditingController _tECSurname;

  String get _id => widget.customer.docID!;

  @override
  void initState() {
    super.initState();

    if (widget.type != CustomerEditTypes.name) {
      _tECName = TextEditingController();
      _tECSurname = TextEditingController();
    }

    switch (widget.type) {
      case CustomerEditTypes.name:
        _tEC = TextEditingController(text: widget.customer.getFullName);
        _tECName = TextEditingController(text: widget.customer.name);
        _tECSurname = TextEditingController(text: widget.customer.surname);
      case CustomerEditTypes.idNo:
        _tEC = TextEditingController(text: widget.customer.idNo?.toString());
      case CustomerEditTypes.tax:
        _tEC = TextEditingController(text: widget.customer.taxNo?.toString());
      case CustomerEditTypes.phone:
        _tEC = TextEditingController(text: widget.customer.phone?.toString());
      case CustomerEditTypes.address:
        _tEC = TextEditingController(text: widget.customer.address);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tEC.dispose();
    _tECName.dispose();
    _tECSurname.dispose();
  }

  String get _getLabel {
    switch (widget.type) {
      case CustomerEditTypes.name:
        return "Ad Soyad";
      case CustomerEditTypes.idNo:
        return "Kimlik NO";
      case CustomerEditTypes.tax:
        return "Vergi NO";
      case CustomerEditTypes.phone:
        return "Telefon";
      case CustomerEditTypes.address:
        return "Adres";
    }
  }

  void _save() {
    switch (widget.type) {
      case CustomerEditTypes.name:
        _saveName();
      case CustomerEditTypes.idNo:
        widget.customer.idNo = _tEC.textTrim.toInt;
        _saveFirestore({"idNo": _tEC.textTrim.toInt});
      case CustomerEditTypes.tax:
        widget.customer.taxNo = _tEC.textTrim;
        _saveFirestore({"taxNo": _tEC.textTrim});
      case CustomerEditTypes.phone:
        _savePhone();
      case CustomerEditTypes.address:
        widget.customer.address = _tEC.textTrim;
        _saveFirestore({"address": _tEC.textTrim});
    }
  }

  void _saveFirestore(Map<String, dynamic> val) {
    FFirestore.update(
      FirestoreCol.customers,
      _id,
      val,
      shopRef: true,
    );

    context.pop();
  }

  void _savePhone() {
    String phone = _tEC.textTrim.replaceAll(" ", "");
    if (phone.length != 10) {
      CustomSnackbar.showSnackBar(
          context: context, text: "Telefon numarası 10 haneli olmalı!");
      return;
    }

    try {
      int.parse(phone);
    } catch (_) {
      CustomSnackbar.showSnackBar(
          context: context, text: "Sadece numara içermelidir!");
      return;
    }

    FFirestore.update(
      FirestoreCol.customers,
      _id,
      {
        "phone": phone.toInt,
      },
      shopRef: true,
    );
    widget.customer.phone = phone.toInt;

    context.pop();
  }

  void _saveName() {
    FFirestore.update(
      FirestoreCol.customers,
      _id,
      {
        "name": _tECName.textTrim,
        "surname": _tECSurname.textTrim,
        "fullName": "${_tECName.textTrim} ${_tECSurname.textTrim}"
      },
      shopRef: true,
    );
    widget.customer.name = _tECName.textTrim;
    widget.customer.surname = _tECSurname.textTrim;
    widget.customer.fullName = "${_tECName.textTrim} ${_tECSurname.textTrim}";
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.getFullName),
      ),
      body: Padding(
        padding: Values.paddingPage(context),
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (widget.type == CustomerEditTypes.phone)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Telefon numarasını başta sıfır olmadan yazın: 545823....\n10 haneli olmalıdır",
                  style: context.textTheme.titleMedium!.toBold,
                ),
              ),
            _textFields(),
            const SizedBox(height: 20),
            Buttons(context, "KAYDET", _save).filled(),
          ],
        ),
      ),
    );
  }

  Widget _textFields() {
    if (widget.type != CustomerEditTypes.name) {
      return TextField(
        controller: _tEC,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: _getLabel,
        ),
      );
    }

    return Column(
      children: [
        TextField(
          controller: _tECName,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Ad",
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _tECSurname,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Soyad",
          ),
        ),
      ],
    );
  }
}

enum CustomerEditTypes {
  name,
  phone,
  idNo,
  tax,
  address,
}
