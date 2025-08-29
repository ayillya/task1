class User {
  final int id; final String name; final int? age; final String? profession; final String? profileImage;

  User({required this.id, required this.name, this.age, this.profession, this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['user_id'] ?? 0, 
    name: json['name'] ?? '', 
    age: json['age'], 
    profession: json['profession'], 
    profileImage: json['profile_image'],
  );
}
