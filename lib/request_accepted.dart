import 'package:lamber/map.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/first_aid.dart';
import 'package:lamber/profile.dart';
import 'package:lamber/request.dart';
import 'package:lamber/map.dart';



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book',
      home: MyConfirmAPage(),
    );
  }
}

class MyConfirmAPage extends StatefulWidget {
  const MyConfirmAPage({Key? key}) : super(key: key);

  @override
  ConfirmApage createState() => ConfirmApage();
}

class ConfirmApage extends State<MyConfirmAPage> {
  int _currentIndex = 1;

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
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 812.0,
          child: Column(
            children: <Widget>[
              const Spacer(flex: 5),
// Group: Group 32

              Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'EMS are on their way!',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: const Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Spacer(flex: 2),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                          child: Column(children: [
                        Text(
                          "Berekuso Clinic",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 20.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "Vehicle Registration: GN 1934-19",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow)
                          ],
                        ),
                        Padding(padding: const EdgeInsets.all(3.0)),
                        Text(
                          "1 Berekuso Avenue",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "12:00-12:30 PM",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "21st January 2022",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "No notes",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "15 minutes",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Container(
                          width: 200.0,
                          height: 50.0,
                          margin: EdgeInsets.all(20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(_track());
                            },
                            child: const Text(
                              'TRACK AMBULANCE',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFA43247)),
                            ),
                          ),
                        )
                      ])),
                    ),
                  )),

              Spacer(flex: 10),
              Container(
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFFA43247),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'assets/images/ambulance.jpg'),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Patricia Komla",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(_call());
                                },
                                child: Icon(Icons.phone),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF064457)),
                                ),
                              )
                            ],
                          )
                        ],
                      ))),

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
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route _track() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route _call() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page3(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route _createRouter() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page3(),
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
      home: MyMapPage(),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignIn(),
    );
  }
}
