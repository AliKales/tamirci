import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/extensions/ext_string.dart';
import 'package:tamirci/core/models/m_service.dart';

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({
    super.key,
    required this.service,
    this.onTap,
  });

  final MService service;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            title: Text(
              service.customerFullName ?? "---",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            onTap: onTap,
            title: Text(
              service.vehicleID?.withSpaces.toUpperCase() ?? "---",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            leading: const Icon(Icons.car_repair),
          ),
          ListTile(
            onTap: onTap,
            title: Text(service.createdAt?.toStringFromDate ?? "--"),
            leading: const Icon(Icons.date_range_rounded),
          )
        ],
      ),
    );
  }
}
