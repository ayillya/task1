import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'user_model.dart';

enum FetchState { initial, loading, success, apiError, exception }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserFetcherPage(),
    );
  }
}

class UserFetcherPage extends StatefulWidget {
  const UserFetcherPage({super.key});

  @override
  State<UserFetcherPage> createState() => _UserFetcherPageState();
}

class _UserFetcherPageState extends State<UserFetcherPage> {
  final TextEditingController _idController = TextEditingController();
  FetchState _state = FetchState.initial;
  User? _user;
  String? _error;

  Future<void> _fetch() async {
    final idText = _idController.text.trim();
    final id = int.tryParse(idText);

    if (id == null || id < 1 || id > 3) {
      setState(() {
        _state = FetchState.apiError;
        _error = "Please enter a valid ID (1, 2, or 3).";
      });
      return;
    }

    setState(() {
      _state = FetchState.loading;
    });

    try {
      final uri = Uri.parse("https://2fa0d036-25f8-4bc9-80a4-ff1726e4e097.mock.pstmn.io/caddayn/mock/users/$id");
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);

        if (decoded['success'] == true && decoded['data']?['user'] != null) {
          final user = User.fromJson(decoded['data']['user']);
          setState(() {
            _user = user;
            _state = FetchState.success;
          });
        } else {
          setState(() {
            _state = FetchState.apiError;
            _error = decoded['error']?.toString() ?? decoded['data']?['message']?.toString() ?? 'No user found';
          });
        }
      } else {
        setState(() {
          _state = FetchState.apiError;
          _error = "HTTP ${res.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _state = FetchState.exception;
        _error = "Something went wrong";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _state = FetchState.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextField (fixed width)
              SizedBox(
                width: 700,
                child: TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    hintText: "User ID",
                    labelStyle: const TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _fetch(),
                ),
              ),

              const SizedBox(height: 25),

              // Button
              ElevatedButton(
                onPressed: _fetch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Fetch User"),
              ),

              const SizedBox(height: 24),

              // State-dependent section
              switch (_state) {
                FetchState.initial => const Text(
                    "Enter a User ID and click button to get user details",
                    style: TextStyle(color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                FetchState.loading => const CircularProgressIndicator(),
                FetchState.success => _SuccessView(user: _user!), 
                FetchState.apiError => Text(
                    _error ?? "API Error",
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                FetchState.exception => Text(
                    _error ?? "Something went wrong",
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
              }
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final User user;
  const _SuccessView({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 300,
      padding: const EdgeInsets.all(10), // padding inside the green box
      decoration: BoxDecoration(
        color: Colors.green, // light green background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column (Image)
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              user.profileImage ?? '',
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 20), // gap between image and details

          // Right column (Details)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),

                // Name
                Row(
                  children: [
                    SizedBox(
                      width: 100, // fixed width for all labels
                      child: const Text(
                        "Name:",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),

                // Age
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: const Text(
                        "Age:",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      "${user.age ?? 'N/A'}",
                      style: const TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),

                // Profession
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: const Text(
                        "Profession:",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      "${user.profession ?? 'N/A'}",
                      style: const TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),

                // ID
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: const Text(
                        "ID:",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      "${user.id}",
                      style: const TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
