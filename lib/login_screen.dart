import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localiztion/logged_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  void initState() {
    checkLogin(context);
    super.initState();
  }

  void checkLogin(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString('login');
    if (val != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 35),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: email,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: password,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
                onPressed: () {
                  login(context);
                },
                icon: const Icon(Icons.login_rounded),
                label: const Text('Login')),
          ],
        ),
      ),
    ));
  }

  void login(BuildContext context) async {
    if (password.text.isNotEmpty && email.text.isNotEmpty) {
      var response = await http.post(Uri.parse('https://reqres.in/api/login'),
          body: ({
            'password': password.text,
            'email': email.text,
          }));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('login', body['token']);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Not')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('v')));
    }
  }
}
