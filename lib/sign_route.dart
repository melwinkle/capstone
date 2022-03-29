import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:lamber/register_route.dart';
import 'package:lamber/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SignIn());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sign In',
      home: SignIn(),
    );
  }
}
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  SignInpage createState() => SignInpage();

}

class SignInpage extends State<SignIn> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children:[


        Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,

          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(2.0)),
// Group: Group 32

              SizedBox(
                width: 150.0,
                height: 85.76,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: const <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Text(
                        'LAMBER',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Color(0xFF830C0C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                  ],
                ),
              ),


              const Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 15.0,
                    color: Color(0xFFA34747),
                  ),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(25.0)),
              const Align(
                child: MyCustomForm(),
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0)),
              Container(
                  width: 200.0,
                  height: 40.0,
                  margin: EdgeInsets.all(25),
                  child: Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoutes());
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: Color(0xFFA34747),
                            style: BorderStyle.solid,
                          ),
                        )),
                  ))
            ],
          ),
        ),
      ),
    ]
      )
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



  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  final myController = TextEditingController();
  final password = TextEditingController();
  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: myController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.black87,fontSize: 12.0),
                  filled: true,
                  fillColor: Color(0xFFEFDCDC),
                  contentPadding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          TextFormField(
              controller: password,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black87,fontSize: 12.0),
                  filled: true,
                  fillColor: Color(0xFFEFDCDC),
                  contentPadding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ))),
         Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Align(
              alignment: const Alignment(1.0, 0.0),
              child: OutlinedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  Page5(),
                    ),
                  );
                } ,
                child: const Text('Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFFA34747),
                      fontSize: 15.0,
                    )),
              ),
            ),
          ),
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
                    sig(myController.text,password.text);

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //    SnackBar(content:  Text(myController.text+password.text)),
                      // );
                    }
                  },
                  child: const Text('Sign In'),
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

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }


  void sig(mail,pass) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mail,
          password:pass
      );
      if(userCredential.user!=null){

        if (userCredential.user!= null && userCredential.user!.emailVerified) {
          Navigator.of(context).push(_createRoute());
        }else{
          await userCredential.user!.sendEmailVerification();
        }

      }
      else{
        print('User signed in');
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }



}

Route _createRoutes() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page3(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route _createRoues() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>  Page6(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page4(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Register(),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}
class Page6 extends StatelessWidget {
  const Page6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignIn(),
    );
  }
}
class Page5 extends StatelessWidget {
  Page5({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  final email = TextEditingController();
  final fb = FirebaseDatabase.instance;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password"),
          backgroundColor: const Color(0xFFA34747),
        ),

        body: Align(
            child: Column(
              children: [

                const Align(
                  alignment: Alignment(-0.88, 0.0),
                  child: Text(
                    'Provide your email',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 20.0,
                      color: Color(0xFFA34747),
                    ),
                  ),
                ),

                Align(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                            controller: email,
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.black87),
                                filled: true,
                                fillColor: Color(0xFFEFDCDC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ))),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13.0)),


                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13.0),
                          child: Center(
                            child: Container(
                              width: 250,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    verify(email.text);
                                    Navigator.of(context).push(_createRoues());
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.


                                  }
                                },
                                child: const Text('Reset Password'),
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
                  )
                  ,
                ),

              ],
            )
        )


    );
  }
  void verify(mail) async{
    auth.sendPasswordResetEmail(email: mail).then((value) =>
        print("Email has been sent"));


  }

}