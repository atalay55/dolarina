import 'package:dolarina/Func.dart';
import 'package:dolarina/ListtPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({required this.name});
  late String name;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool nameExits = false;
  Func func = new Func();
  @override
  void initState() {

    func.saatCek().then((value) => print(value));

  }
  FocusNode _focusNode = FocusNode();
  late String message="";


  TextEditingController _tahminCont = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();

    String currentHour ;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white12,
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Padding(
                  padding:  EdgeInsets.only(bottom: 50.0),
                  child: Text("Tahmin Giriniz" ,style:TextStyle(color: Colors.white) ,),
                ),
                Padding(
                  padding:  EdgeInsets.symmetric( horizontal: 20 ,vertical: 15),
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: _tahminCont,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Lütfen bir değer girin.';
                      }
                      if (double.tryParse(value ?? '') == null) {
                        return 'Geçerli bir ondalıklı sayı girin.';
                      }
                      return null;
                    },
                    onSaved: (value) {

                    },
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
                        fillColor: Colors.white,
                        labelText: "Tahmin"
                        ,labelStyle: TextStyle(color: Colors.white)

                    ),
                  ),
                ),
                FutureBuilder<String>
                  (future: func.saatCek(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Veriler alınamadı'));
                      }
                      else if (snapshot.data == null) {
                        return Center(child: Text('Veriler alınamadı'));
                      }
                      else {
                        print(snapshot.data!);
                        currentHour = snapshot.data!;
                        return Padding(
                          padding:  EdgeInsets.symmetric(vertical: 20.0),
                          child: ElevatedButton(style: ButtonStyle(   backgroundColor: MaterialStateProperty.all<Color>(Colors.pink)),
                              onPressed: ( 8 < int.parse(currentHour))? () {


                                setState(()  {
                                    func.getEntity().then((value) async => {
                                    value.forEach((element) {  if(element.name == widget.name){
                                      setState(() {
                                        nameExits =true;
                                      });

                                    }
                                    })
                                  });
                                  if (_formKey.currentState?.validate() ?? false) {
                                    _formKey.currentState?.save();
                                    if (int.parse(currentHour) > 16) {
                                      setState(() {
                                        message="Mevcut saat 12\'den büyüktür. Ekleme yapamazsın";
                                      });

                                    }else if(nameExits){

                                      setState(() {
                                        message=" kullanıcı bir kez ekleme yapabilir";
                                      });


                                    }
                                    else {
                                      setState(()  {
                                         func.addEntity(widget.name, _tahminCont.text).then((value) async =>{

                                         await  Navigator.push(context, MaterialPageRoute(builder: (context)=>ListPage()))

                                        });
                                      });

                                    }
                                  }
                                });

                              }:null, child: Text("Gönder")),

                        );
                      }
                    }),

                Padding(
                  padding: const EdgeInsets.only(top: 25.0,bottom: 30 ,left: 30),
                  child: Text(message,style: TextStyle(color: Colors.white, fontSize: 18),),
                ),
                ElevatedButton(style: ButtonStyle(   backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent)),onPressed: (){
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ListPage()));
                  });
                 },child: Text("Listeye Git"),)
              ],
            ),
          ),
        ),
      ),
    );

  }
}
