import 'package:flutter/material.dart';

class DataRowWidget extends StatelessWidget {
  final String label; final String value;
  const DataRowWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 67, child: Text(label, style: const TextStyle(color: Colors.white))),
        const Text(" : ", style: TextStyle(color: Colors.white)),
        const SizedBox(width: 10),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.yellow))),
      ],
    );
  }
}
