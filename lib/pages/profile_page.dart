import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairy_smart/pages/update_profile_photo.dart';
import 'package:dairy_smart/pages/user_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("My Profile",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        ), // Call the UserImage widget here
      ),

      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('users').doc(user.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
              return const Center(
                child: Text('No data found for the user'),
              );
            } else {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
        
              // Retrieve fields from the document
              var username = userData['username'] as String?;
              var gender = userData['gender'] as String?;
              var role = userData['role'] as String?;
              var phone = userData['phone'] as String?;
              var photo = userData['profileImage'] as String?;
              var email = userData['email'] as String?;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                margin: const EdgeInsets.all(12),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Row(
                                children: [
                                 ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: ClipRect(
                                      child: Image.network(
                                        photo!,
                                        height: 220,
                                        width: 240,
                                        fit: BoxFit.cover, // Adjust the fit property here
                                      ),
                                    ),
                                  ),

                                  IconButton(
                                      onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const UpdateProfilePhoto())
                                        );
                                      },

                                      icon: const Icon(Icons.edit))
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          initialValue: username,
                          decoration: const InputDecoration(
                            labelText: 'User Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Update username in Firestore on change
                            _firestore.collection('users').doc(user.uid).update({'username': value});
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),

                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: gender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Update gender in Firestore on change
                            _firestore.collection('users').doc(user.uid).update({'gender': value});
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: role,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Update gender in Firestore on change
                            _firestore.collection('users').doc(user.uid).update({'role': value});
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone No',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Update residence in Firestore on change
                            _firestore.collection('users').doc(user.uid).update({'phone': value});
                          },
                        ),
                        const SizedBox(height: 16),

                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),


    );

  }
}
