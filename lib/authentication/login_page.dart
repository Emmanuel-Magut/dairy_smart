import 'package:dairy_smart/authentication/tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'change_password.dart';


class LoginPage extends StatefulWidget{

  const  LoginPage({super.key,

  });
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true; // Added variable to track password visibility
  void SignUserIn() async {
    //loading circle
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),

      );
    },
    );
      final authService = Provider.of<AuthService>(context, listen: false);

    //Sign user in

    try {
      await authService.signInWithEmailandPassword(
         emailController.text,
         passwordController.text,
      );
      Navigator.pop(context);
    }  catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:Text(
            e.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          ),

      );
      Navigator.pop(context);
    }

  }
  //error message
  void showErrorMessage(String message){
    showDialog(context: context, builder:(context){
      return AlertDialog(
        backgroundColor: Colors.brown,
        title:Column(
          children: [
            const Icon(Icons.warning,
              size: 40,
            ),
            const SizedBox(height:10),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    });
  }




  @override

  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height:50),
                const Icon(Icons.lock,
                  color: Colors.green,
                  size:100,
                ),
                const SizedBox(height:50),

                const Text('Hello, Welcome Back!',
                  style:TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    //backgroundColor: Colors.green[900],
                  ),
                ),
                const SizedBox(height:20),
                Form(
                    key: _formKey,
                    child: Column(
                  children: [
                    //user name
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
                          controller: emailController,
                          obscureText: false,
                          cursorColor: Colors.green,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Email'
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Oops! email is required';
                            }
                            // Regular expression for email validation
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height:30),
                    //password
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
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            suffixIcon: IconButton( // Changed to suffixIcon
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword; // Toggling password visibility
                                });
                              },
                              icon: Icon(Icons.remove_red_eye_outlined),
                            ),
                            prefixIcon: Icon(Icons.key),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Password',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Oops! password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least six characters long';
                            }
                            return null;
                          },

                        ),
                      ),
                    ),

                  ],
                )),
                const SizedBox(height:25),
                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.end ,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordPage())
                          );
                        },
                        child: const Text('Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                //button
                 GestureDetector(
                   onTap: (){
                     if (_formKey.currentState!.validate()){
                       SignUserIn();
                     }
                   },
                   child: Container(
                     padding: const EdgeInsets.only(left: 20,right: 20,top: 12,bottom: 12),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(12),
                       color: Colors.green,
                     ),
                       child: Text('Login',
                       style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                       ),
                       ),
                   ),
                 ),
                const SizedBox(height:25),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(child: Divider(
                        thickness: 1.5,
                        color: Colors.green,
                      ),
                      ),
                      SizedBox(width:8,),
                      Text('or login with',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          // backgroundColor: Colors.green[900],
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(width:8),
                      Expanded(child: Divider(
                        thickness: 1.5,
                        color: Colors.green,
                      )),

                    ],
                  ),
                ),
                const SizedBox(height:25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTile(
                      onTap: ()=> {},
                      filePath: ('lib/images/google.png'),
                    ),
                    SizedBox(width: 10),
                    MyTile(
                      onTap:(){},
                      filePath: ('lib/images/apple.png'),
                    ),


                  ],
                ),
                SizedBox(height:25),
                //not a member? Register now!

              ],
            ),
          ),
        ),
      ),
    );
  }
}