import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './tasks.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

final supabase = Supabase.instance.client;

class _LoginPageState extends State<LoginPage> {
  String emailvalue = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(children: [
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
                hintText: "Enter Email Address",
                focusColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(color: Colors.white)),
            onChanged: (value) => emailvalue = value,
            cursorColor: Colors.white, // Set the cursor color
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
                hintText: "Enter Your Password",
                focusColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(color: Colors.white)),
            onChanged: (value) => emailvalue = value,
            cursorColor: Colors.white, // Set the cursor color
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            child: const Center(child: Text('GET OTP')),
            onPressed: () async {
              await supabase.auth.signInWithOtp(email: emailvalue);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage(
                          title: 'Home',
                        )),
              );
            },
          )
        ]));
  }
}
