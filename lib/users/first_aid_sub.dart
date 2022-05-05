import 'package:lamber/users/request_confirm.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/users/first_aid.dart';
import 'package:lamber/profile.dart';
import 'package:lamber/request.dart';



class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.todo}) : super(key: key);

  final todo;
  // Declare a field that holds the Todo.


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book',
      home: MyFirstPage(),
    );
  }
}

class MyFirstPage extends StatefulWidget {
  const MyFirstPage({Key? key}) : super(key: key);

  @override
  Firstpage createState() => Firstpage();
}

class Firstpage extends State<MyFirstPage> {
  int _currentIndex = 2;


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
                  "todo[""].toString()",
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: const Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
         
              Container(
                width: 300.0,
                height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('assets/images/ambulance.jpg'),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              Spacer(flex: 2),
              Container(
                  alignment: Alignment.topLeft,
                  width: 300.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        Icon(Icons.verified_user, color: Colors.green),
                        Text(
                          " Reviewed",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 12.0,
                            color: const Color(0xFFA34747),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'todo["Description"].toString(),',
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 12.0,
                            color: const Color(0xFFA34747),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(padding: const EdgeInsets.all(5.0)),
                      ]),
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
      home: SignIn(),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyConfirmPage(),
    );
  }
}
