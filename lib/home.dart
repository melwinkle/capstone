import 'package:lamber/ambulances.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/request.dart';
import 'package:lamber/first_aid.dart';
import 'package:lamber/profile.dart';
import 'package:lamber/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Homepage',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Homepage createState() => Homepage();
}

class Homepage extends State<MyHomePage> {
  int _currentIndex = 0;

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
      backgroundColor: const Color(0xFFEFDCDC),
      body: Align(
        alignment: const Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 812.0,
          child: Column(
            children: <Widget>[
              const Spacer(flex: 30),
// Group: Group 32

              const Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'Emergency',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 30.0,
                    color: Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'Press and hold to send a message',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 15.0,
                    color: Color(0xFF807E7E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(flex: 15),
              Container(
                  width: 600.0,
                  height: 250.0,
                  margin: const EdgeInsets.all(25),
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRouter());
                      },
                      child: const Text(
                        'SOS',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF8E2525)),
                          shape: MaterialStateProperty.all(const CircleBorder(
                              side: BorderSide(
                                  width: 12, color: Color(0xFFCE9595))))),
                    ),
                  )),
              Container(
                  width: 250.0,
                  height: 50.0,
                  margin: EdgeInsets.all(25),
                  child: Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoute());
                        },
                        child: Row(
                          children: [
                            Column(
                              children: const [
                                Icon(Icons.location_on,
                                    size: 30, color: Color(0xFFA34747))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Current Address',
                                  style: TextStyle(
                                    color: Color(0xFFA34747),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '1 University Avenue, Berekuso',
                                  style: TextStyle(
                                    color: Color(0xFFA34747),
                                    fontSize: 12.0
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            width: 1.0,
                            color: Color(0xFFA34747),
                            style: BorderStyle.solid,
                          ),
                        )),
                  )),
              Spacer(flex: 20),
              Container(
                  width: 250.0,
                  height: 50.0,
                  margin: const EdgeInsets.all(25),
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoutes());
                      },
                      child: const Text(
                        'AVAILABLE AMBULANCES',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFA34747)),
                      ),
                    ),
                  )),
              Spacer(flex: 20),
              BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                backgroundColor: Color(0xFFFFFFFF),
                selectedItemColor: Color(0xFFA34747),
                unselectedItemColor: const Color(0xFFA34747).withOpacity(.60),
                selectedFontSize: 14,
                unselectedFontSize: 14,
                onTap: (value) {
                  // Respond to item press.
                  setState(() => _currentIndex = value);
                  _onTap();
                },
                items: const [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.home_filled),
                  ),
                  BottomNavigationBarItem(
                    label: 'Requests',
                    icon: Icon(Icons.receipt_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'First Aid',
                    icon: Icon(Icons.health_and_safety_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'Account',
                    icon: Icon(Icons.person_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void ver(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
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

Route _createRoutes() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page3(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route _createRouter() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page4(),
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

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyAmbulancePage(),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyLoaderPage(),
    );
  }
}
