// ignore_for_file: use_build_context_synchronously

part of 'customer_page_view.dart';

mixin _MixinCustomerPage<T extends StatefulWidget> on State<T> {
  late MCustomer customer;
  List<MVehicle> vehicles = [];

  void initialize(MCustomer c) {
    customer = c;
  }

  void makePhoneCall() {}

  void sendIban() {}

  Future<void> seeVehicles() async {
    if (vehicles.isNotEmptyAndNull) return;
    CustomProgressIndicator.showProgressIndicator(context);

    final r = await FFirestore.getVehicles(
        equalTo: MapEntry("customerID", customer.phone.toString()));

    context.pop();

    if (r.hasError) {
      CustomSnackbar.showSnackBar(
          context: context, text: "Error ${r.exception?.message}");
      return;
    }

    setState(() {
      vehicles = r.response ?? [];
    });
  }

  void copyName() {
    _copy(customer.getFullName, LocaleKeys.nameSurname);
  }

  void copyPhone() {
    _copy(customer.getPhone, LocaleKeys.phone);
  }

  void copyIdNo() {
    _copy(customer.idNo.toString(), LocaleKeys.idNo);
  }

  void copyTax() {
    _copy(customer.taxNo.toString(), LocaleKeys.taxNo);
  }

  void copyAddress() {
    _copy(customer.address ?? "--", LocaleKeys.address);
  }

  void _copy(String data, String label) {
    Clipboard.setData(ClipboardData(text: data));
    CustomSnackbar.showSnackBar(
        context: context, text: "$label ${LocaleKeys.copied}");
  }

  void goVehicle(int i) {
    context.push(PagePaths.vehicle, extra: vehicles[i]);
  }
}
