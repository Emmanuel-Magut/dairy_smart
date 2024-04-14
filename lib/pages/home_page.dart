import 'package:dairy_smart/pages/user_image.dart';
import 'package:dairy_smart/pages/user_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      drawer:  Drawer(
        child: Column(
          children: [
            const DrawerHeader(child: Column(
              children: [
                UserImage(),
                SizedBox(height: 20),
                UserName(),
              ],
            )),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.home,
                        size: 30,
                          color: Colors.green,
                        ),
                        title: Text('D.A.S.H.B.O.A.R.D',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        ),
                      ),
                    ),
                    //PROFILE
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.account_circle,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text('My Profile',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    //USERS
                    GestureDetector(
                      onTap: (){},
                      child: const ListTile(
                        leading: Icon(Icons.supervised_user_circle_sharp,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text('Users',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    //ANIMALS
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.pets,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text('Dairy Cattles',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    //VACCINATIONS
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.vaccines_outlined,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text('Vaccinations',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    //INSEMINATIONS
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.animation,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text('Inseminations',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    //PRODUCTION MANAGEMENT
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child:  const ListTile(
                        leading: Icon(Icons.production_quantity_limits,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text('Milk Production',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    //FARM INVENTORY

                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.inventory,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text('Farm Inventory',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    //SUPPLIERS/CUSTOMERS
                    GestureDetector(
                      onTap: (){

                      },
                      child:  const ListTile(
                        leading: Icon(Icons.people_alt_rounded,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text('Suppliers/Customers',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    //FINANCES
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child:  const ListTile(
                        leading: Icon(Icons.monetization_on_rounded,
                          size: 30,
                          color: Colors.green,
                        ),
                        title: Text('Finances',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),


                 const SizedBox(height: 40),

                 const Divider(),
                GestureDetector(
                  onTap: signOut,
                  child: const ListTile(
                    leading: Icon(Icons.logout_rounded),
                    title: Text('Logout'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
