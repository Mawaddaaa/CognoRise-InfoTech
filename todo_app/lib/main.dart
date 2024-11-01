// import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:first_app/shared/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'layout/home_layout.dart';



void main()
{
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    return  MaterialApp(
        theme: ThemeData(
          fontFamily: 'Jost',
        ),
      debugShowCheckedModeBanner: false,
      home :  HomeLayout()
    );
  }
}