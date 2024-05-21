import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/firebase/f_firestore.dart';
import 'package:tamirci/core/h_hive.dart';
import 'package:tamirci/core/local_values.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/core/models/m_vehicle.dart';
import 'package:tamirci/core/url_launcher.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/pages/customer_page/pages/customer_edit_page.dart';
import 'package:tamirci/router.dart';
import 'package:tamirci/widgets/buttons.dart';
import 'package:tamirci/widgets/vehicle_widget/vehicle_widget.dart';

part 'mixin_customer_page.dart';

class CustomerPageView extends StatefulWidget {
  const CustomerPageView({super.key, required this.customer});

  final MCustomer customer;

  @override
  State<CustomerPageView> createState() => _CustomerPageViewState();
}

class _CustomerPageViewState extends State<CustomerPageView>
    with _MixinCustomerPage {
  @override
  void initState() {
    super.initState();
    initialize(widget.customer);
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                IconButton.filled(
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.customer.docID ?? ""));
                  },
                  icon: const Icon(Icons.person),
                  iconSize: 80,
                ),
                const SizedBox(height: 30),
                ListTile(
                  title: Text(customer.getFullName),
                  leading: const Icon(Icons.person),
                  onTap: copyName,
                  trailing: IconButton(
                    onPressed: () {
                      context.navigatorPush(CustomerEditPageView(
                        customer: customer,
                        type: CustomerEditTypes.name,
                      ));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  title: Text(customer.getPhone.formatPhone),
                  leading: const Icon(Icons.phone),
                  onTap: copyPhone,
                  trailing: IconButton(
                    onPressed: () {
                      context.navigatorPush(CustomerEditPageView(
                        customer: customer,
                        type: CustomerEditTypes.phone,
                      ));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  title: Text("${LocaleKeys.idNo}: ${customer.idNo}"),
                  leading: const Icon(Icons.info_rounded),
                  onTap: copyIdNo,
                  trailing: IconButton(
                    onPressed: () {
                      context.navigatorPush(CustomerEditPageView(
                        customer: customer,
                        type: CustomerEditTypes.idNo,
                      ));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  title: Text("${LocaleKeys.taxNo}: ${customer.taxNo}"),
                  leading: const Icon(Icons.info),
                  onTap: copyTax,
                  trailing: IconButton(
                    onPressed: () {
                      context.navigatorPush(CustomerEditPageView(
                        customer: customer,
                        type: CustomerEditTypes.tax,
                      ));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                ListTile(
                  title: Text(customer.address ?? "---"),
                  leading: const Icon(Icons.home),
                  onTap: copyAddress,
                  trailing: IconButton(
                    onPressed: () {
                      context.navigatorPush(CustomerEditPageView(
                        customer: customer,
                        type: CustomerEditTypes.address,
                      ));
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
                const SizedBox(height: 15),
                Buttons(context, LocaleKeys.makeCall, makePhoneCall).filled(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Buttons(context, LocaleKeys.sendIBAN, sendIban)
                      .outlined(),
                ),
                Buttons(context, LocaleKeys.seeVehicles, seeVehicles).textB(),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return VehicleWidget(
                        vehicle: vehicles[index],
                        onTap: () => goVehicle(index),
                      );
                    },
                    itemCount: vehicles.length,
                    shrinkWrap: true,
                  ),
                ),
              ],
            ).center,
          ),
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
