import 'package:lamber/request_confirm.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/first_aid.dart';
import 'package:lamber/profile.dart';
import 'package:lamber/request.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book',
      home: MyBookPage(),
    );
  }
}

class MyBookPage extends StatefulWidget {
  const MyBookPage({Key? key}) : super(key: key);

  @override
  Bookpage createState() => Bookpage();
}

class Bookpage extends State<MyBookPage> {
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
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 812.0,
          child: Column(
            children: <Widget>[
              const Spacer(flex: 10),
// Group: Group 32

              Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'Book Ambulance',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: const Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Spacer(flex: 5),
            SizedBox(
              width: 300.0,
              height: 120.0,
              child: Image.asset('assets/images/ambulance.jpg'),
            ),
              Spacer(flex: 2),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,
                  height: 320.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        Text(
                          "Berekuso Clinic",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 20.0,
                            color: const Color(0xFFA34747),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Padding(padding: const EdgeInsets.all(5.0)),
                        const MyCustomForm(),
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

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment(-0.88, 0.00),
            width: 300,
            child: TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_clock),
                    hintText: 'Pick Up Time',
                    hintStyle: TextStyle(color: Color(0xFFA34247)),
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    prefixIconColor: Color(0xFFA34247),
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter location';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Location',
                  hintStyle: TextStyle(color: Color(0xFFA34247)),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  prefixIconColor: Color(0xFFA34247),
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter notes';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Special Notes eg emergency type',
                  hintStyle: TextStyle(color: Color(0xFFA34247)),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  prefixIconColor: Color(0xFFA34247),
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Container(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      Navigator.of(context).push(_createRouter());
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );
                    }
                  },
                  child: const Text('BOOK'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFA34747)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
