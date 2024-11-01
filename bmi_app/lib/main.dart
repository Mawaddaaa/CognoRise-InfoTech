// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'modules/bmi_results/bmi_result_screen.dart';
import 'modules/bmi/bmi_screen.dart';


void main()
{
  runApp(const MyApp());

}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home : BmiScreen()
    );
  }
}