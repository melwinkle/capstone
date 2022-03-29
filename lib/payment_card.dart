import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lamber/payment.dart';
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
      home: MyPaymentCPage(),
    );
  }
}

class MyPaymentCPage extends StatefulWidget {
  const MyPaymentCPage({Key? key}) : super(key: key);

  @override
  PaymentCpage createState() => PaymentCpage();
}

class PaymentCpage extends State<MyPaymentCPage> {
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
      appBar: AppBar(
        title: Text("Add Card"),
        backgroundColor: const Color(0xFFA34747),
      ),
      backgroundColor: const Color(0xFFEFDCDC),
      body: ListView(
    children:[Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 560.0,
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
                        'Add Card',
                        style: TextStyle(
                          color: Color(0xFFA43247),
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(10.0)),
                    Container(
                      child: const MyCustomForm(),
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
    return Scaffold(
      body: MyPaymentPage(),
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

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final cardname = TextEditingController();
  final cardnumber= TextEditingController();
  final date = TextEditingController();
  final pin = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
              // The validator receives the text that the user has entered.
            controller: cardname,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name on card';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Card Name',
                  hintStyle: TextStyle(color: Colors.black87,fontSize: 12.0),
                  filled: true,
                  fillColor: Color(0xFFEFDCDC),
                  contentPadding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          TextFormField(
              // The validator receives the text that the user has entered.
              controller: cardnumber,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Card number';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Card number',
                  hintStyle: TextStyle(color: Colors.black87,fontSize: 12.0),
                  filled: true,
                  fillColor: Color(0xFFEFDCDC),
                  contentPadding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          TextFormField(
              controller: date,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter expiry date';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Expiry Date',
                  hintStyle: TextStyle(color: Colors.black87,fontSize: 12.0),
                  filled: true,
                  fillColor: Color(0xFFEFDCDC),
                  contentPadding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          TextFormField(
              // The validator receives the text that the user has entered.
              controller: pin,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter CVV';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'CVV',
                  hintStyle: TextStyle(color: Colors.black87,fontSize: 12.0),
                  filled: true,
                  fillColor: Color(0xFFEFDCDC),
                  contentPadding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
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
                      cardet(cardname.text,cardnumber.text,date.text,pin.text);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );
                    }
                  },
                  child: const Text('SAVE'),
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

  Future<void> cardet(name, number, date, pin) async {
    final userid=FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference request = FirebaseDatabase.instance.ref("users/clients/$userid");

    try {

        await request.update({
          "Card_Name": name,
          "Card_number": number,
          "Card_date": date,
          "Card_pin": pin,



        });

        Navigator.of(context).push(_createRoute());


    } on Exception catch (e, s) {
      print(s);
    }

  }
}
