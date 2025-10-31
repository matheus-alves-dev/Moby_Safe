import 'package:flutter/material.dart';

class MobSafetyAppBar {
  static AppBar build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MobSafety',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Text(
            'Inspeção de Segurança Viária',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: true,
    );
  }
}