import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
        children:[Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,

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
                  'Welcome Back',
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
                  padding: EdgeInsets.all(5.0)),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(25),

                child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(_createRoutes());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Not verified your account?', style: TextStyle(
                          color: Color(0xFFDB5461),
                          fontSize: 10,
                          fontWeight: FontWeight.normal,

                        ),),
                        Text(
                          ' Click here',
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
  final fb = FirebaseDatabase.instance;
  String emailText="";
  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
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
            controller: myController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          TextFormField(
              controller: password,
              obscureText: true,
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
                  hintStyle: const TextStyle(color:  Color(0xFFD87D8C),fontSize: 12.0),
                  filled: true,
                  fillColor: const Color(0xFFFFF1F4),
                  contentPadding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Align(
              alignment: Alignment.topRight,
              child: OutlinedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>   ForgotPassword(),
                      ),
                    );
                  } ,
                  child: const Text('Forgot Password?',
                      style: TextStyle(
                          color: Color(0xFFDB5461),
                          fontSize: 10.0,
                          fontWeight: FontWeight.normal
                      )),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 1.0,
                      color: Color(0xFFA34747),
                      style: BorderStyle.none,
                    ),
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
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
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),

                      ),
                    ),
                    backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFDB5461)),
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
      if(userCredential.user!=null ){
        User? user = FirebaseAuth.instance.currentUser;

        if (user!= null && user.emailVerified) {
          Navigator.of(context).push(_createRoute());
        }else{
          await user?.sendEmailVerification();
        }

      }
      else{
        print('User signed in');
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          emailText = 'No user found for that email.';


        });

      } else if (e.code == 'wrong-password') {
        setState(() {
          emailText = 'Wrong password provided for that user.';

        });

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

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page4(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

Route _createRoues() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>  const SignIn(),
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

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  final email = TextEditingController();
  final fb = FirebaseDatabase.instance;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            alignment: Alignment.center,
            width: 180,
            height: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Image.asset('assets/images/midlogo.png'),
          ),
          iconTheme: const IconThemeData(
              color: Color(0xFFDB5461)
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 100,
        ),

        body:  ListView(
            children:[
              Container(
                  color: Colors.white,
                  height: 812,
                  child:
                  Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),),
                          const Text("Forgot Password", style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                              color:Color( 0xFFDB5461)
                          ),),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),),
                          const Align(

                              alignment: Alignment.topLeft,

                              child: Padding(padding: EdgeInsets.all(5.0) ,child:Text(
                                'Provide your email',
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize: 10.0,
                                  color: Color(0xFFD87D8C),
                                ),
                              ), )
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),),
                          Align(
                            child: Form(
                              key: _formKey,
                              child: Column(

                                children: [
                                  TextFormField(
                                      controller: email,

                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter email';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.person),
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
                                    padding: const EdgeInsets.symmetric(vertical: 13.0),
                                    child: Center(
                                      child: SizedBox(
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
                                          child: const Text('Reset Password',style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.normal
                                          ),),
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
                            )
                            ,
                          ),

                        ],
                      )
                  )

              )
            ])


    );
  }
  void verify(mail) async{
    auth.sendPasswordResetEmail(email: mail).then((value) =>
        print("Email has been sent"));


  }

}