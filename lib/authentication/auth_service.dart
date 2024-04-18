import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier{
  //instance of auth
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//instance of firestorm
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // sign user in
   Future<UserCredential> signInWithEmailandPassword(String email, String password) async {
     try{
       //signs in
       UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
         email: email,
         password: password,
       );
       //add a new document for the user in users collection if it doesn't exist
       _firestore.collection('users').doc(userCredential.user!.uid).set({

         'uid' : userCredential.user!.uid,
         'email': userCredential.user!.email,
         'active': bool,
        // 'username': userCredential.user!.email?.split('@')[0],

       },
       SetOptions(merge: true),
       );
     return userCredential;
     } on FirebaseAuthException catch (e) {
       throw Exception(e.code);
     }
    }


  Future<UserCredential> signUpWithEmailandPassword(String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the current user's UID
      String? uid = userCredential.user?.uid;

      if (uid != null) {
        // Update the isOnline and lastSeen fields in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'username': userCredential.user!.email?.split('@')[0],
        });


        return userCredential;
      } else {
        // Handle the case where UID is null
        throw Exception('User UID is null');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  // sign user out
   Future<void> signOut() async {
     return await FirebaseAuth.instance.signOut();
   }
}