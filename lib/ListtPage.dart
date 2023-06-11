import 'dart:math';

import 'package:dolarina/ThemeWinner.dart';
import 'package:flutter/material.dart';
import 'Entity.dart';
import 'Func.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Entity> data = [];

  DateTime currentTime = DateTime.now();
  Func _func = new Func();

  Map<String, dynamic> dolars = new Map<String, dynamic>();
  String dolar = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Color> colorList = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.deepPurple,
      Colors.pink,
      Colors.lime,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepOrange,
      Colors.indigoAccent,
      Colors.pinkAccent,
      Colors.limeAccent,
      Colors.tealAccent,
      Colors.amberAccent,
      Colors.cyanAccent,
    ];



    return Scaffold(
        body: FutureBuilder<List<Entity>>(
      future: _func.getEntity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Veriler alınamadı'));
        } else {
          data = snapshot.data!;

         return  FutureBuilder<String>(
              future: _func.saatCek(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Veriler alınamadı'));
                } else if (snapshot.data == null) {
                  return Center(child: Text('Veriler alınamadı'));
                } else {

                  print(snapshot.data!);
                  print(data);
                  if (int.parse(snapshot.data!) >= 19 && int.parse(snapshot.data!)< 22) {
                    return ThemeWinner(entites: data);
                  }
                  if(int.parse(snapshot.data!) >= 22 ){
                    _func.resetData(int.parse(snapshot.data!));
                  }
                  return data.isNotEmpty
                      ? Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Center(
                                child: Container(
                                  width: 500,
                                  color: colorList[index],
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Text(
                                            data[index].name!,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child:
                                          Text("Tahmin: ${data[index].value!} \$",
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  )
                      : int.parse(snapshot.data!) > 22
                      ?
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  "Saat 8 den sonra tekrar tahminde bulununuz ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              "Lütfen tahminde bulununuz ",
                              style:
                              TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 25,
                            ),
                            child: Icon(
                              Icons.sentiment_very_dissatisfied_outlined,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Lütfen Tahminde Bulunuz",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25, left: 25.0),
                        child: Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          size: 50,
                        ),
                      ),
                    ],
                  );
                }
              });

        }

      },
    ));
  }
}
