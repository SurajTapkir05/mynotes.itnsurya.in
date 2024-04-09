import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  // Future<FirebaseApp>? _data;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                if(!context.mounted){
                  return;
                }
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
              } on FirebaseAuthException catch (e) {
                if (!context.mounted) {
                  return;
                }
                switch (e.code) {
                  case 'weak-password':
                    showErrorDialog(
                      context,
                      'Weak Password',
                    );
                  case 'email-already-in-use':
                    showErrorDialog(
                      context,
                      'Email already in use',
                    );
                  case 'invalid-email':
                    showErrorDialog(
                      context,
                      'Invalid Email',
                    );
                  case 'channel-error':
                    showErrorDialog(
                      context,
                      'Enter Email and Password',
                    );
                  default:
                    showErrorDialog(
                      context,
                      'Error: ${e.code}',
                    );
                }
              } catch (e) {
                showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text('Login here'),
          ),
        ],
      ),
    );
  }
}
