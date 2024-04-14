import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserName extends StatefulWidget {
  const UserName({super.key});

  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
          return const Text('No data found for the user');
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var username = userData['username'] as String?;
          var useremail = userData['email'] as String?;

          return username != null

              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(username,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: "Pacifico",
                ),
              ),
              // You can display more user details here if needed
            ],
          )
              :  Text(user.email!);
        }
      },
    );
  }
}
