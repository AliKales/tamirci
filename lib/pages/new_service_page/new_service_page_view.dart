import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/core/models/m_piece.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/locale_keys.dart';
import 'package:tamirci/pages/new_service_page/pages/pieces_view.dart';
import 'package:tamirci/pages/new_service_page/pages/prices_view.dart';
import 'package:tamirci/pages/new_service_page/pages/service_view.dart';
import 'package:tamirci/pages/new_service_page/service_controller.dart';
import 'package:tamirci/router.dart';

import 'pages/customer_view.dart';
import 'pages/vehicle_view.dart';

part 'mixin_new_service.dart';

class NewServicePageView extends StatefulWidget {
  const NewServicePageView({super.key});

  @override
  State<NewServicePageView> createState() => _NewServicePageViewState();
}

class _NewServicePageViewState extends State<NewServicePageView>
    with _MixinNewService {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _appBar(),
      floatingActionButton: _fAB(),
      body: Column(
        children: [
          PageView(
            controller: controller,
            children: [
              CustomerView(customer: customer, controller: customerController),
              VehicleView(
                service: service,
                controller: vehicleController,
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
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Values.paddingHeightSmallXX.toDynamicHeight(context)),
            child: SmoothPageIndicator(
              controller: controller,
              count: 5,
              effect: WormEffect(
                activeDotColor: context.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton _fAB() {
    return FloatingActionButton.small(
      onPressed: onDone,
      child: const Icon(Icons.add),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(LocaleKeys.newService),
      actions: [
        IconButton(
            onPressed: _onScan,
            icon: const Icon(Icons.document_scanner_outlined)),
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
