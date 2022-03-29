import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
      title: 'Profile',
      home: MyUpgradePage(),
    );
  }
}

class MyUpgradePage extends StatefulWidget {
  const MyUpgradePage({Key? key}) : super(key: key);

  @override
  Upgradepage createState() => Upgradepage();
}

class Upgradepage extends State<MyUpgradePage> {
  bool valuefirst = false;
  bool valuesecond = false;
  int _currentIndex = 3;
  FirebaseAuth auth = FirebaseAuth.instance;
  final userid=FirebaseAuth.instance.currentUser?.uid;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Upgrade"),
        backgroundColor: const Color(0xFFA34747),
      ),
      backgroundColor: const Color(0xFFEFDCDC),
      body: ListView(
    children:[Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 570.0,
          child: Column(
            children: <Widget>[
// Group: Group 32

              const Spacer(flex: 2),

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

                    const Text('Upgrade your account for more access on Lamber',
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
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFA43247)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CheckboxListTile(
                              // secondary: const Icon(Icons.alarm),
                              checkColor: Colors.white,
                              activeColor: Colors.green,
                              title: const Text('Standard Package-Ghc 5/month',
                                  style: TextStyle(
                                    color: Color(0xFFa43247),
                                    fontWeight: FontWeight.w500,
                                  )),
                              subtitle: Text('Pay-as-you go, 2 Cancellations',
                                  style: TextStyle(
                                    color: Color(0xFFA43247),
                                  )),
                              value: this.valuefirst,
                              onChanged: (value) {
                                setState(() {
                                  this.valuefirst = value!;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFA43247)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CheckboxListTile(
                              // secondary: const Icon(Icons.alarm),
                              checkColor: Colors.white,
                              activeColor: Colors.green,
                              title: const Text('Premium Package-Ghc 15/month',
                                  style: TextStyle(
                                    color: Color(0xFFA43247),
                                    fontWeight: FontWeight.w500,
                                  )),
                              subtitle:
                                  Text('Unlmited Requests, 4 Cancellations',
                                      style: TextStyle(
                                        color: Color(0xFFA43247),
                                      )),
                              value: this.valuesecond,
                              onChanged: (value) {
                                setState(() {
                                  this.valuesecond = value!;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                          ),
                          Container(
                              child: ElevatedButton(
                            onPressed: () {
                              var val;
                              // Validate returns true if the form is valid, or false otherwise.
                                if(valuefirst){
                                  val="Standard Package";
                                }else if(valuesecond){
                                  val="Premium Package";
                                }

                                sig(val);
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              // Navigator.of(context).push(_createRoute());
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //    SnackBar(content: Text(val.toString())),
                              // );
                            },
                            child: const Text('Change subscription'),
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
    ])
    );
  }

  void sig(name) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/clients/$userid");
    await ref.update({
      "Package": name,
    });
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
    return const MaterialApp(
      home: SignIn(),
    );
  }
}
