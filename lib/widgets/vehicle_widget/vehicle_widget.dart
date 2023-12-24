import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/models/m_vehicle.dart';

class VehicleWidget extends StatelessWidget {
  const VehicleWidget({super.key, required this.vehicle, this.onTap});

  final MVehicle vehicle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWellNoGlow(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.car_repair),
                iconSize: 30,
              ),
              const SizedBox(width: 5),
              Text(
                vehicle.plate?.withSpaces.toUpperCase() ?? "-",
                maxLines: 2,
                style: context.textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ).expanded,
              const Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
