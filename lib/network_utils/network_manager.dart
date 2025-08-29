import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class NetworkManager {
  static Future<User?> fetchUser(int id) async {
    try { 
      final uri = Uri.parse("https://caddaynapi.free.beeceptor.com/user/$id"); 
      final res = await http.get(uri); 
      if (res.statusCode == 200) { 
        final decoded = json.decode(res.body); 
        if (decoded['success'] == true && decoded['data']?['user'] != null) { return User.fromJson(decoded['data']['user']); } 
        else { throw Exception(decoded['error']?.toString() ?? decoded['data']?['message']?.toString() ?? 'No user found'); } 
      } else { throw Exception("HTTP ${res.statusCode}"); } 
    } catch (e) { throw Exception("Something went wrong"); }
  }
}
