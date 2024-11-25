import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class topBar extends AppBar{
  Widget build(BuildContext context) {
    return
      Center( child: AppBar(
        shape: Border(
            bottom: BorderSide(
                color: Colors.teal.shade700,
                width: 2
            )
        ),
        backgroundColor: Colors.teal.shade700,
        title:
        Column(
          children:[
            Text('Headlines News', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Read Top News Today'),
          ],
        ),
      ),);
  }
}