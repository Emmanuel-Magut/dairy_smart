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
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Column(
              children: [
                Icon(Icons.account_circle,
                size: 40,
                ),
              ],
            )),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('DASHBOARD'),
                    ),
                  ],
                ),

                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('DASHBOARD'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
