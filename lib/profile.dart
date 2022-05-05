import 'package:lamber/account.dart';
import 'package:lamber/users/payment.dart';
import 'package:lamber/users/upgrade.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/request.dart';
import 'package:lamber/users/first_aid.dart';
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
      backgroundColor: const Color(0xFFFFFFFF),
      bottomNavigationBar:  Container(
          margin: const EdgeInsets.only(top:50,left:0,right:0,bottom:0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child:ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),

            ),

            child:BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              backgroundColor: Color(0xFFDB5461),
              selectedItemColor: Color(0xFFFFFFFF),
              unselectedItemColor: const Color(0xFFFFFFFF).withOpacity(.60),
              selectedFontSize: 14,
              unselectedFontSize: 12,


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
                  label: 'Account',
                  icon: Icon(Icons.person_outlined),
                ),
              ],
            ),

          )
      ),
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
                    color: Color(0xFFDB5461),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(10.0)),
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
                                    size: 32, color: Color(0xFFDB5461))),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Profile",
                                style: const TextStyle(
                                  color: Color(0xFFDB5461),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: const Size(350, 50),
                        )),
                  )),


              Container(
                  alignment: Alignment(-0.78, -0.04),
                  margin: EdgeInsets.only(top:2.0),
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
                                    size: 32, color: Color(0xFFDB5461))),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: const Text(
                                'Help Center',
                                style: TextStyle(
                                  color: Color(0xFFDB5461),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: const Size(350, 50),
                        )),
                  )),

              Container(
                  alignment: Alignment(-0.78, -0.04),
                  margin: EdgeInsets.only(top:46.0,bottom:50),
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
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Color(0xFFDB5461),
                          fixedSize: const Size(350, 50),
                        )),
                  )),


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




class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: MyAccountPage(),
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
