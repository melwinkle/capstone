import 'package:lamber/account.dart';
import 'package:lamber/payment.dart';
import 'package:lamber/upgrade.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/request.dart';
import 'package:lamber/first_aid.dart';
import 'package:lamber/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Profile',
      home: MyProfilePage(),
    );
  }
}

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  Profilepage createState() => Profilepage();
}

class Profilepage extends State<MyProfilePage> {
  int _currentIndex = 2;

  _onTap() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            _children[_currentIndex])); // this has changed
  }

  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFDCDC),
      body: Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(

          height: 812.0,
          child: Column(
            children: <Widget>[

              Padding(padding: const EdgeInsets.all(30.0)),

              const Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(flex: 15),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SizedBox(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoute());
                        },
                        child: Row(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.account_circle,
                                    size: 32, color: Color(0xFFA34747))),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Profile",
                                style: const TextStyle(
                                  color: Color(0xFFA34747),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: const Size(350, 80),
                        )),
                  )),



              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SizedBox(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoute());
                        },
                        child: Row(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.help_center_rounded,
                                    size: 32, color: Color(0xFFA34747))),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: const Text(
                                'Help Center',
                                style: TextStyle(
                                  color: Color(0xFFA34747),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: const Size(350, 80),
                        )),
                  )),
              Spacer(flex: 20),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SizedBox(
                    child: OutlinedButton(
                        onPressed: () {
                          log();
                          Navigator.of(context).push(_createRout());
                        },
                        child: Row(
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.logout,
                                    size: 32, color: Color(0xFFFFFFFF))),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: const Text(
                                'LOGOUT',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFFA34747),
                          fixedSize: const Size(350, 80),
                        )),
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
                    icon: Icon(Icons.home_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'Requests',
                    icon: Icon(Icons.receipt_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'Account',
                    icon: Icon(Icons.person),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void log() async{
    await FirebaseAuth.instance.signOut();
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

Route _createRout() {

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page5(),
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
    return const Scaffold(

      body: MyAccountPage(),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyUpgradePage(),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyPaymentPage(),
    );
  }
}


class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Page1(),
    );
  }
}
