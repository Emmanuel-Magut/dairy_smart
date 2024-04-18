import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RegisterCow extends StatefulWidget {
  const RegisterCow({Key? key}) : super(key: key);

  @override
  _RegisterCowState createState() => _RegisterCowState();
}

class _RegisterCowState extends State<RegisterCow> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final tagController = TextEditingController();
  final colorController = TextEditingController();
  final breedController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();

  File? _image;

  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _descriptionController = TextEditingController();


  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      _handleError('Error picking image: $e');
    }
  }

  Future<void> _uploadImageToFirestore() async {
    if (_image == null) return;

    try {
      Uint8List imageBytes = Uint8List.fromList(await _image!.readAsBytes());
      Reference storageReference =
      _storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
      await storageReference.putData(imageBytes);

      String imageUrl = await storageReference.getDownloadURL();
      if (nameController.text.isNotEmpty) {
        // Add the cow data to Firestore
        DocumentReference cowRef =
        await FirebaseFirestore.instance.collection('Dairy_Cows').add({
          "name": nameController.text,
          "cowImage": imageUrl,
          "tagNumber": tagController.text,
          "gender": genderController.text,
          "breed": breedController.text,
          "color": colorController.text,
          "DOB": _selectedDate,
          "breeding_status":'Pending',
        });

        // Add the document ID as the ID of the cow
        await cowRef.set({'id': cowRef.id}, SetOptions(merge: true));

      }
      setState(() {
        nameController.clear();
      });
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Icon(Icons.check_circle, color: Colors.green, size: 50),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Success!', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('New Cow was registered successfully'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                  child: const Text('Close',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  )
              ),
            ),
          ],
        ),
      );

    } catch (error) {
      _handleError('Error uploading image: $error');
    }
  }



  Future<void> _handleLostData() async {
    try {
      final ImagePicker picker = ImagePicker();
      final LostDataResponse response = await picker.retrieveLostData();

      if (response.isEmpty) {
        return;
      }

      final List<XFile>? files = response.files;

      if (files != null) {
        _handleLostFiles(files);
      } else {
        _handleError(response.exception);
      }
    } catch (e) {
      _handleError('Error handling lost data: $e');
    }
  }

  void _handleLostFiles(List<XFile> files) {
    for (XFile file in files) {
      print('Recovered file path: ${file.path}');
    }
  }

  void _handleError(dynamic errorMessage) {
    print('Errors: $errorMessage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Register Cow',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Georgia",
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Row(
                children: [
                  Container(
                    width: 180, // Adjust the width as needed
                    height: 180, // Adjust the height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: _image != null
                        ? Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    )
                        : const Center(
                      child: Text('No Image Selected'),
                    ),
                  ),
                  const SizedBox(width:20),
                  Column(
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await _pickImage(ImageSource.camera);
                              await _handleLostData();
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 60,
                              color: Colors.green,
                            ),
                          ),
                          const Text("Camera"),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await _pickImage(ImageSource.gallery);
                              await _handleLostData();
                            },
                            icon: const Icon(
                              Icons.image,
                              size: 60,
                              color: Colors.green,
                            ),
                          ),
                          const Text("Gallery"),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    //Cow Tag No
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green,
                            )
                        ),
                        child: TextFormField(
                          controller: tagController,
                          obscureText: false,
                          cursorColor: Colors.green,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'ID/Ear Tag Number'
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Tag Number is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Name
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green,
                            )
                        ),
                        child: TextFormField(
                          controller: nameController,
                          obscureText: false,
                          cursorColor: Colors.green,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Name'
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    //gender
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green,
                            )
                        ),
                        child: TextFormField(
                          controller: genderController,
                          obscureText: false,
                          cursorColor: Colors.green,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Gender'
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Gender is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                     const SizedBox(height: 10),
                     //Breed
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green,
                            )
                        ),
                        child: TextFormField(
                          controller: breedController,
                          obscureText: false,
                          cursorColor: Colors.green,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Breed'
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Breed is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                   const SizedBox(height: 10),
                   //Color/Markings
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green,
                            )
                        ),
                        child: TextFormField(
                          controller: colorController,
                          obscureText: false,
                          cursorColor: Colors.green,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Color/Markings'
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Color Markings required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                   //DATE OF Birth
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green,
                            )
                        ),
                        child: TextFormField(
                          controller: TextEditingController(text: DateFormat('y MMMM d').format(_selectedDate)),
                          readOnly: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Date of Birth',
                            suffixIcon: GestureDetector(
                              onTap: _selectDate,
                              child: const Icon(Icons.calendar_today),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter DOB/Purchase.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),





                  ],
                ),
              ),
            ),
            //DOB

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap:() {
                  if (_formKey.currentState!.validate()) {
                    _uploadImageToFirestore();
                  }
                },

                child: Container(
                  padding: const EdgeInsets.only(top:10 ,bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Register Cow',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}