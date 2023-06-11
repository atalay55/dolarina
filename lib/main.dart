import 'package:dolarina/Func.dart';
import 'package:dolarina/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());


}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Dolarına',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(



      ),
      home:  LoginPage()
    );
  }
}

