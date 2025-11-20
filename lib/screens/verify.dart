import 'package:flutter/material.dart';
import 'home.dart';
// Deprecated OTP Firebase verification screen removed from Firebase. This now acts as a simple redirect.

class Verify extends StatelessWidget {
  const Verify({super.key, required this.phoneUser, required this.idUser});
  final String phoneUser;
  final String idUser;

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomePage())));
    return const Scaffold(
      body: Center(
        child: Text(
          'Phone verification disabled (Firebase removed). Redirecting...',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
