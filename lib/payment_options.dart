import 'package:lamber/payment_card.dart';
import 'package:lamber/payment_momo.dart';
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
      home: MyPaymentOPage(),
    );
  }
}

class MyPaymentOPage extends StatefulWidget {
  const MyPaymentOPage({Key? key}) : super(key: key);

  @override
  PaymentOpage createState() => PaymentOpage();
}

class PaymentOpage extends State<MyPaymentOPage> {
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
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Add a Payment Method',
                        style: TextStyle(
                          color: Color(0xFFA43247),
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    const Text('Select a Payment method',
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
                              width: 300.0,
                              height: 80.0,
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
                                child: const Text('Pay Via Card'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFA34747)),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                          ),
                          Container(
                              width: 300.0,
                              height: 80.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.

                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  Navigator.of(context).push(_createRoutes());
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(content: Text('Processing Data')),
                                  // );
                                },
                                child: const Text('Pay Via Mobile Money'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFA34747)),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(5.0)),
                  ]),
                ),
              ),

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

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPaymentCPage(),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPaymentMPage(),
    );
  }
}
