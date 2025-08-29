import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl; 
  const ProfileImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, height: 300,
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: (imageUrl != null && imageUrl!.isNotEmpty) 
        ? Image.network(imageUrl!, fit: BoxFit.cover) 
        : Center(child: Icon(Icons.person, size: 80, color: Colors.grey[700])),
    );
  }
}
