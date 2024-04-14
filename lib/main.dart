import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dairy_smart/authentication/auth_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'authentication/auth_page.dart';

void main() async {
  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        // Add ChatService provider
        //other providers if needed
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const AuthPage(),
    );
  }
}
