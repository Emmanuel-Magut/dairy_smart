import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserImage extends StatefulWidget {

  const UserImage({super.key,

  });

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return Text('No data for the user');
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            var profileImageUrl = userData['profileImage'] as String?;
            return profileImageUrl != null
                ? GestureDetector(
              onTap: (){

              },
              child: ClipOval(
                child: Image.network(
                  profileImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            )
                : GestureDetector(
              onTap: (){
      
              },
              child: const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }
}
