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
      final uri = Uri.parse("https://caddaynapi.free.beeceptor.com/user/$id");
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
              color: Colors.grey[300], // background for the placeholder
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: (user.profileImage != null && user.profileImage!.isNotEmpty)
                ? Image.network(
                    user.profileImage!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Icon(
                      Icons.person,
                      size: 80, // adjust size as you like
                      color: Colors.grey[700], // matches grey background
                    ),
                  ),
          ),

// helper method

          const SizedBox(width: 20), // gap between image and details

          // Right column (Details)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),

                // Name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 67,
                      child: const Text(
                        "Name",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(
                      " : ",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        user.name,
                        style: const TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ],
                ),

                                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 67,
                      child: const Text(
                        "User ID",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(
                      " : ",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${user.id}",
                        style: const TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ],
                ),

                // Age
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 67,
                      child: const Text(
                        "Age",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(
                      " : ",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${user.age ?? 'N/A'}",
                        style: const TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ],
                ),

                // Profession
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 67,
                      child: const Text(
                        "Profession",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(
                      " : ",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        user.profession ?? 'N/A',
                        style: const TextStyle(color: Colors.yellow),
                      ),
                    ),
                  ],
                ),

                // ID

              ],
            ),
          )
        ],
      ),
    );
  }
}
