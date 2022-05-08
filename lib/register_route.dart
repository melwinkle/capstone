import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Payment',
      home: Register(),
    );
  }
}
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Registerpage createState() => Registerpage();

}
class Registerpage extends State<Register> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:ListView(
          children:[
            Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 800.0,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(2.0)),
// Group: Group 32

              Container(
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset('assets/images/midlogo.png'),
              ),



              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Create an Account',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 15.0,
                      color: Color(0xFFDB5461),
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),


              const Padding(
                  padding: EdgeInsets.all(5.0)),
              const Align(
                child: MyCustomForm(),
              ),
              const Padding(
                  padding: EdgeInsets.all(2.0)),
              Container(
                  width: 200.0,
                  height: 30.0,
                  margin: EdgeInsets.all(25),

                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoutes());
                        },
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Have an account?', style: TextStyle(
                              color: Color(0xFFDB5461),
                              fontSize: 10,
                              fontWeight: FontWeight.normal,

                            ),),
                            Text(
                              ' Sign In',
                              style: TextStyle(
                                  color: Color(0xFFDB5461),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            width: 1.0,
                            color: Color(0xFFA34747),
                            style: BorderStyle.none,
                          ),
                        )),
                  )
            ],
          ),
        ),
      ),
    ])
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
  FirebaseAuth auth = FirebaseAuth.instance;
  final myController = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final fullname = TextEditingController();
  final phone = TextEditingController();
  final name = "users/clients/";
  final fb = FirebaseDatabase.instance;
  String emailText='';
  @override
  Widget build(BuildContext context) {

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emailText,style: const TextStyle(
              color: Colors.red,fontSize: 12.0,fontWeight:FontWeight.bold
          ),),
          TextFormField(
              controller: fullname,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name(s)';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Full Name',
                  hintStyle: TextStyle(color: const Color(0xFFD87D8C),fontSize: 12.0),
                  filled: true,
                  fillColor: const Color(0xFFFFF1F4),
                  contentPadding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ))),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          TextFormField(
              controller: myController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: const Color(0xFFD87D8C),fontSize: 12.0),
                  filled: true,
                  fillColor: const Color(0xFFFFF1F4),
                  contentPadding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          TextFormField(
              controller: phone,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                if (value.trim().length < 10) {
                  return 'Phone number must be 10 characters';
                }
                if (value.trim().length > 10) {
                  return 'Phone number must be 10 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(color: const Color(0xFFD87D8C),fontSize: 12.0),
                  filled: true,
                  fillColor: const Color(0xFFFFF1F4),
                  contentPadding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          TextFormField(
              controller: password,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (value.trim().length < 6) {
                  return 'Password must be at least 6 characters in length';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: const Color(0xFFD87D8C),fontSize: 12.0),
                  filled: true,
                  fillColor: const Color(0xFFFFF1F4),
                  contentPadding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Container(
                width: 250,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      reg(myController.text, password.text);
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      Navigator.of(context).push(_createRoutes());

                    }
                  },
                  child: const Text('Register'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFDB5461)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void reg(mail,pass) async{
    final ref = fb.reference();
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: mail,
          password: pass
      );
      String user=userCredential.user?.uid as String;
      Map<String, String> userData = {
        'Email':mail,
        'FullName': fullname.text,
        'Phone': phone.text,
        'uid': user
      };
      ref.child(name+user).set(userData);
      User? users = FirebaseAuth.instance.currentUser;

      if (users!= null && !users.emailVerified) {
        await users.sendEmailVerification();
        showAlertDialog(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          emailText="Password too weak";
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          emailText="The account already exists for that email.";
        });
      }
    } catch (e) {
      print(e);
    }
  }
  void showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).push(_createRoutes());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Verification Email"),
      content: Text("Check your email to verfiy your account!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

Route _createRoutes() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Pages(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignIn(),
    );
  }
}

class Pages extends StatelessWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page1(),
    );
  }
}

