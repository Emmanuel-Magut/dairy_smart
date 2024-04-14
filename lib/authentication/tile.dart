import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  final Function()? onTap;
  final filePath;
  const MyTile({
    required this.filePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color:Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(filePath,
          height:48,
        ),
      ),
    );


  }
}
