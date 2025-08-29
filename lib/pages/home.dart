import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/status_provider.dart';
import '../status_enum.dart';
import '../widgets/data_card.dart';

class UserFetcherPage extends StatelessWidget {
  const UserFetcherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 700,
                child: TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    hintText: "User ID", labelStyle: const TextStyle(color: Colors.green),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.green)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.green)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.green, width: 2)),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) { final id = int.tryParse(value); context.read<StatusProvider>().fetchUserById(id); },
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () { final id = int.tryParse(idController.text.trim()); context.read<StatusProvider>().fetchUserById(id); },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: const Text("Fetch User"),
              ),
              const SizedBox(height: 24),
              Consumer<StatusProvider>(
                builder: (context, provider, child) {
                  return provider.state == FetchState.initial
                      ? const Text("Enter a User ID and click button to get user details", style: TextStyle(color: Colors.green), textAlign: TextAlign.center)
                      : provider.state == FetchState.loading
                          ? const CircularProgressIndicator()
                          : provider.state == FetchState.success
                              ? DataCard(user: provider.user!)
                              : Text(provider.error ?? "Something went wrong", style: const TextStyle(color: Colors.red), textAlign: TextAlign.center);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
