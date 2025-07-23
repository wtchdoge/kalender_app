import 'package:database_test_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mitarbeiternameController = TextEditingController();
  String? _error;

  Future<void> _register() async {
    final mitarbeitername = _mitarbeiternameController.text.trim();
    if (mitarbeitername.isEmpty) {
      setState(() => _error = 'Bitte gib einen Mitarbeiternamen an.');
      return;
    }
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await cred.user?.updateDisplayName(_usernameController.text.trim());

      // Firestore User-Dokument direkt nach Registrierung anlegen
      final userId = cred.user?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'mitarbeitername': mitarbeitername,
          'created': DateTime.now().toIso8601String(),
        });
        // Auch in die neue Collection 'mitarbeiter' speichern
        await FirebaseFirestore.instance.collection('mitarbeiter').doc(userId).set({
          'mitarbeitername': mitarbeitername,
          'userId': userId,
          'created': DateTime.now().toIso8601String(),
        });
      }

      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = 'Registrierung fehlgeschlagen. Überprüfe deine Daten.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrieren')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Benutzername'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _mitarbeiternameController,
              decoration: const InputDecoration(labelText: 'Mitarbeitername'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: TextStyle(color: AppColors.accent)),
              ),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrieren'),
            ),
          ],
        ),
      ),
    );
  }
}
