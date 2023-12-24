import 'package:caroby/caroby.dart';
import 'package:flutter/material.dart';
import 'package:tamirci/core/models/m_customer.dart';

class CustomerWidget extends StatelessWidget {
  const CustomerWidget({super.key, required this.customer, this.onTap});

  final MCustomer customer;
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
                icon: const Icon(Icons.person_4),
                iconSize: 30,
              ),
              const SizedBox(width: 5),
              Text(
                customer.getFullName,
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
