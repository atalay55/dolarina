
import 'package:flutter/material.dart';

import 'Entity.dart';
import 'Func.dart';

class ThemeWinner extends StatelessWidget {
  ThemeWinner({required this.entites});
  Func _func = new Func();
  List<Entity> entites;
  Entity? winner ;
  @override
  Widget build(BuildContext context) {


    return FutureBuilder< Map<String, dynamic> > (
      future: _func.fetchData() ,
      builder: (context, snapshot){

    if (snapshot.connectionState == ConnectionState.waiting) {

    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {

    return Center(child: Text('Veriler alınamadı'));
    }
    else if(snapshot.data ==null){
      return Text("sdad");
    }

    else {

      entites.forEach((element) {
        if( double.parse(element.value!).toString()==  _func.findClosestValue(entites,double.parse(snapshot.data!['USD']['satis']))){
         winner = element;
        }
      });
      return entites.isNotEmpty ?
        Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text("Kazanan kisi ${winner!.name} ve tahmini ${winner!.value}",style: TextStyle(fontSize: 20),)

          ],
        ),
      ):  Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

        Text("Bugün hiç tahmin yapılamıştır",style: TextStyle(fontSize: 20),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.sentiment_dissatisfied_outlined,size: 50,),
          )

        ],
        ),
        );
    }

      },);

  }
}

