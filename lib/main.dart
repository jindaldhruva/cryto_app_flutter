import 'package:flutter/material.dart';
import 'price_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //new comment
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.redAccent,//change to blue 
          scaffoldBackgroundColor: Colors.white),
      home: PriceScreen(),
    );
  }
}
