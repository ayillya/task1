import 'package:flutter/material.dart';
import 'data_row_widget.dart';
import 'profile_image.dart';
import '../model/user_model.dart';

class DataCard extends StatelessWidget {
  final User user;const DataCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,height: 300,padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(12),),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImage(imageUrl: user.profileImage),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                DataRowWidget(label: "Name", value: user.name),DataRowWidget(label: "User ID", value: "${user.id}"),
                DataRowWidget(label: "Age", value: "${user.age ?? 'N/A'}"),
                DataRowWidget(label: "Profession", value: user.profession ?? "N/A"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
