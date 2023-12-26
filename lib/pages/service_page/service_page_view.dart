import 'package:caroby/caroby.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tamirci/core/extensions/ext_object.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/firebase/f_auth.dart';
import 'package:tamirci/core/firebase/f_firestore.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/core/models/m_piece.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/core/models/m_vehicle.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/pages/service_page/pages/pieces_view.dart';
import 'package:tamirci/pages/service_page/pages/prices_view.dart';
import 'package:tamirci/pages/service_page/service_controller.dart';
import 'package:tamirci/router.dart';
import 'package:tamirci/widgets/buttons.dart';

import 'pages/customer_view.dart';
import 'pages/service_view.dart';
import 'pages/vehicle_view.dart';

part 'mixin_service_page.dart';

class ServicePageView extends StatefulWidget {
  const ServicePageView({super.key, required this.service});

  final MService? service;

  @override
  State<ServicePageView> createState() => _NewServicePageViewState();
}

class _NewServicePageViewState extends State<ServicePageView>
    with _MixinNewService {
  @override
  void initState() {
    super.initState();
    initialize(widget.service);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _appBar(),
      floatingActionButton: _fAB(),
      body: Column(
        children: [
          PageView(
            onPageChanged: onPageChanged,
            controller: controller,
            children: [
              CustomerView(
                customer: customer,
                controller: customerController,
                isNew: isNew,
                onFindCustomer: findCustomer,
              ),
              VehicleView(
                vehicle: vehicle,
                controller: vehicleController,
                isNew: isNew,
                onSearchPlate: findVehicle,
              ),
              ServiceView(
                service: service,
                controller: serviceController,
              ),
              PiecesView(
                service: service,
                onAdd: addPiece,
                onRemove: removePiece,
              ),
              PricesView(
                service: service,
                controller: priceController,
              ),
            ],
          ).expanded,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (kIsWeb)
                FloatingActionButton.small(
                  onPressed: () => changePageWeb(false),
                  child: const Icon(Icons.arrow_back_ios_sharp),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical:
                      Values.paddingHeightSmallXX.toDynamicHeight(context),
                  horizontal: 30,
                ),
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 5,
                  effect: WormEffect(
                    activeDotColor: context.colorScheme.primary,
                  ),
                ),
              ),
              if (kIsWeb)
                FloatingActionButton.small(
                  onPressed: () => changePageWeb(true),
                  child: const Icon(Icons.arrow_forward_ios_sharp),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fAB() {
    return ValueListenableBuilder(
      valueListenable: showFAB,
      builder: (context, value, child) {
        if (!value) return const SizedBox.shrink();
        if (isNew) {
          return FloatingActionButton.small(
            onPressed: onAddNew,
            child: const Icon(Icons.add),
          );
        }

        return FloatingActionButton.small(
          onPressed: onUpdate,
          child: const Icon(Icons.save_as),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(isNew ? LocaleKeys.newService : LocaleKeys.service),
      actions: [
        if (!kIsWeb && isNew)
          IconButton(
            onPressed: _onScan,
            icon: const Icon(Icons.document_scanner_outlined),
          ),
        if (!isNew)
          IconButton(
            onPressed: onCustomerTap,
            icon: const Icon(Icons.person_4_rounded),
          ),
      ],
    );
  }
}

enum ServicePages {
  customer,
  vehicle,
  service,
  pieces,
  prices;
}
