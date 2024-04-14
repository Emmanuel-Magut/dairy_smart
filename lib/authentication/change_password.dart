import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPassWordPageState();
}

class _ForgotPassWordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Icon(Icons.check_circle,
            size: 40,
              color: Colors.green,
            ),
            content: Text("Success! Password reset link sent, check Your email"),
          );
        },
      );
    setState(() {
      _emailController.clear();
    });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Literata',
          ),
          ),
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text('Enter Your email address here to get a password reset link',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20,
                color: Colors.black,

                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),
                  ),
                ),

              ),
            ),
            SizedBox(height: 10),

            GestureDetector(
              onTap: passwordReset,
              child: Container(
                padding: const EdgeInsets.all(12),
                   decoration: BoxDecoration(
                     color: Colors.green,
                     borderRadius: BorderRadius.circular(12),

                   ),
                  child: const Text('Reset Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  )
                  )
              ),
            ),
          ],

        )
    );
  }
}
