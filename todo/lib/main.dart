import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './tasks.dart';
import './login.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://bhasfzhuyhccroeprjux.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoYXNmemh1eWhjY3JvZXByanV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTI2NzY1MDAsImV4cCI6MjAwODI1MjUwMH0.X4llboJVIiSMNwjGFbJdcEMhgt2HEuDvAdxCv4v1lWo',
  );
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        colorScheme: const ColorScheme.dark(
            primary: Colors.black,
            secondary: Colors.white,
            tertiary: Colors.red),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const LoginPage(),
        '/home': (_) => const HomePage(
              title: 'Home',
            ),
      },
    );
  }
}
