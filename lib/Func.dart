import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'Entity.dart';

class Func{

  Map<String, dynamic> jsonData = {};

  FirebaseFirestore fire = FirebaseFirestore.instance;
  Future<List<Entity>> getEntity() async {
    late List<Entity> entites = [];
    entites.clear();
    await fire.collection("Guess")
        .get()
        .then((QuerySnapshot q) {
      q.docs.forEach((element) {
        entites.add(Entity(name: element["name"] ,value: element["guess"]));
      });
    });
    return entites;
  }
  Future<void> addEntity(String name ,String value) async {
    late List<Entity> entites = [];
    entites.clear();
    await FirebaseFirestore.instance
        .collection("Guess").add(
        {
          'name': name,
          'guess': value,
        }

    );

  }

  Future<String> saatCek() async {
    String _saat = '';
    try {
      final response = await http.get(Uri.parse('https://worldtimeapi.org/api/ip'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final saateks = data['datetime'];

          _saat = saateks.substring(11, 19);


      } else {
        print("_saat");
          _saat = 'Hata';

      }
    } catch (e) {

      print(e);
        _saat = 'Hata';

    }

    return _saat.split(":")[0];
  }


  Future<Map<String,dynamic>> fetchData() async {
    var url = 'https://api.genelpara.com/embed/para-birimleri.json';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {

        jsonData = await json.decode(response.body);
    }

    return jsonData;
  }

  void resetData(int time) async {

    if (time >=22 || time<6 ) {
      QuerySnapshot querySnapshot = await fire
          .collection('Guess')
          .get()
          .catchError((error) {
        print('Sıfırlama işlemi başarısız oldu: $error');
      });

      WriteBatch batch = fire.batch();
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });

      await batch.commit().then((value) {
        print('Veriler sıfırlandı.');
      }).catchError((error) {
        print('Sıfırlama işlemi başarısız oldu: $error');
      });
    } else {
      print('Henüz verileri sıfırlama zamanı değil.');
    }
  }

  String findClosestValue(List<Entity> values, double targetValue) {
    double closestValue = double.parse(values[0].value!);
    double minDifference = (double.parse(values[0].value!) - targetValue).abs();

    for (int i = 1; i < values.length; i++) {
      double difference = (double.parse(values[i].value!) - targetValue).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestValue = double.parse(values[i].value!);
      }
    }

    return closestValue.toString();
  }

}