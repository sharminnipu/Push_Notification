import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget{
  @override
  _SecondState createState() =>_SecondState();


}
class _SecondState extends State<SecondPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    body: Center(
      child: Text(
        "hello Second page is here"
      ),
    ),

    );
  }



}