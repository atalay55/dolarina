import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dolarina/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Func.dart';

class LoginPage extends StatefulWidget {


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Func _func = new Func();

  String? userName;
  TextEditingController _name = new TextEditingController();


  setUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
  }
  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('userName');
    return stringValue!;
  }


  @override
  void initState() {
    super.initState();
    getUserName().then((value) =>  _name.text=value);


  }






  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = FocusNode();
    String message = "";
    return Scaffold(

      // backgroundColor: Colors,
        body: FutureBuilder<Map<String, dynamic>>(future: _func.fetchData()
          , builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Hata: ${snapshot.error}');
            } else {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _focusNode.unfocus();
                },
                child: Center(
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: EdgeInsets.only(bottom: 50.0),
                        child: Text('Dolar Kuru: ${_func
                            .jsonData['USD']['satis']}',
                          style: TextStyle(color: Colors.black, fontSize: 15),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 50.0),
                        child: Text(
                          "Kullanıcı ismi", style: TextStyle(color: Colors
                            .white),),
                      ),


                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                            focusNode: _focusNode,
                            controller: _name,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: Colors.red),
                                    borderRadius: BorderRadius.circular(8.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: Colors.red),
                                    borderRadius: BorderRadius.circular(8.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: Colors.green),
                                    borderRadius: BorderRadius.circular(8.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(8.0)),

                                labelText: "Kullanıcı ismi"
                                ,
                                labelStyle: TextStyle(color: Colors.black)

                            ),
                            validator: (value) {


                            }
                        ),

                      ),
                      Text(message),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: ElevatedButton(style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.pink)),
                            onPressed: () {
                              print(_name.text);
                              if (userName == null) {
                                setUserName(_name.text);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(name: _name.text,)));


                              }
                              else {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(name: _name.text)));
                              }
                            }, child: Text("Gönder")),

                      ),Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Oyun dolar kurunu tahmin etme presibine dayalı olarak oynanmaktadır.Saat 12 ye kadar tek tahmin hakkınız bulunmaktadır."
                              "Saat 19 dan sonra kazanan kişi liste sayfasında gözükecektir.Saat 22 dan sonra veriler sıfırlanacak ve saat 8 de tekrardan oyun başlayacaktır"),
                        ),
                      ),

                      Padding(
                        padding:  EdgeInsets.only(top:25.0),
                        child: Text("İyi tahminler :)"),
                      ),
                    ],
                  ),
                ),
              );
            }
          },)
    );


  }
}

