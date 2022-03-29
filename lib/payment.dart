import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lamber/payment_options.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/request.dart';
import 'package:lamber/first_aid.dart';
import 'package:lamber/profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Payment',
      home: MyPaymentPage(),
    );
  }
}

class MyPaymentPage extends StatefulWidget {
  const MyPaymentPage({Key? key}) : super(key: key);

  @override
  Paymentpage createState() => Paymentpage();
}

class Paymentpage extends State<MyPaymentPage> {
  bool valuefirst = false;
  bool valuesecond = false;
  int _currentIndex = 3;

  _onTap() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            _children[_currentIndex])); // this has changed
  }

  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];
  final usid=FirebaseAuth.instance.currentUser;
  final userid=FirebaseAuth.instance.currentUser?.uid;
  final fb = FirebaseDatabase.instance.ref('users/clients').orderByKey();
  List<dynamic> lst = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Options"),
        backgroundColor: const Color(0xFFA34747),
      ),
      backgroundColor: const Color(0xFFEFDCDC),
      body: Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 812.0,
          child: Column(
            children: <Widget>[
// Group: Group 32

              const Spacer(flex: 10),

              Container(
                alignment: Alignment(-0.78, -0.04),
                width: 300.0,
                height: 500.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(children: [

                    const Text('Current payment option',
                        style: TextStyle(
                          color: Color(0xFFA43247),
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0,
                        )),
                    Padding(padding: const EdgeInsets.all(10.0)),
                    Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              child:FutureBuilder(
                                  future: fb.equalTo(userid!).get(),

                                  builder: (context, AsyncSnapshot snapshot) {

                                    if (snapshot.hasData) {
                                      lst.clear();
                                      Map<dynamic,dynamic> values = snapshot.data.value;

                                      values.forEach((key, values) {
                                        lst.add(values);
                                        print(values);

                                      });

                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: lst.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(

                                                child:  Container(
                                                decoration: BoxDecoration(
                                                border: Border.all(color: Color(0xFFA43247)),
                                            borderRadius: BorderRadius.circular(10),
                                            color: Color(0xFFA43247),
                                            ),
                                            child: CheckboxListTile(
                                            secondary: const Icon(Icons.money),
                                            checkColor: Colors.white,
                                            activeColor: Colors.green,
                                            title: Text(lst[index]["Card_number"],
                                            style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0,
                                            )),
                                            subtitle: Text('Expires '+lst[index]["Card_date"],
                                            style: TextStyle(
                                            color: Colors.white,
                                            )),
                                            value: this.valuefirst,
                                            onChanged: (value) {
                                            setState(() {
                                            this.valuefirst = value!;
                                            });
                                            },
                                            ),
                                            )
                                            );

                                          });
                                    }
                                    return CircularProgressIndicator();
                                  })
                          ),


                          Padding(
                            padding: const EdgeInsets.all(5.0),
                          ),
                          Container(
                              child: ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.

                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              Navigator.of(context).push(_createRoute());
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(content: Text('Processing Data')),
                              // );
                            },
                            child: const Text('Add Payment'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFA34747)),
                            ),
                          ))
                        ],
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(5.0)),
                  ]),
                ),
              ),

              Spacer(flex: 20),

            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyPaymentOPage(),
    );
  }
}
