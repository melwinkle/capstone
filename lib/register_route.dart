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
      body: ListView(
        children:[Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 580.0,
          child: Column(
            children: <Widget>[

          Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0)),
// Group: Group 32

              SizedBox(
                width: 200.0,
                height: 85.76,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Text(
                        'LAMBER EMS',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: const Color(0xFF830C0C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0)),
              Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'Verify your email',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 15.0,
                    color: const Color(0xFFA34747),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0)),
              Align(
                child: const MyCustomForm(),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0)),
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
                          'Sign In',
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

  final fullname = TextEditingController();
  final password = TextEditingController();
  final name = "users/ems/";
  final fb = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
              controller: fullname,
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
                  hintStyle: TextStyle(color: Colors.black87,fontSize: 12.0),
                  filled: true,
                  fillColor: Color(0xFFEFDCDC),
                  contentPadding: EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ))),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0)),
          TextFormField(
              controller: password,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
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
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Center(
              child: Container(
                width: 250,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      verify(fullname.text,password.text);
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.


                    }
                  },
                  child: const Text('Verify'),
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

  void verify(mail,pass) async{
    final ref = fb.reference();
    final refs=fb.ref('users/ems_temp').orderByChild("Email");
    final ems=refs.equalTo(mail);
    final dat=await ems.get();
    List<dynamic> lst = [];


    if(dat.exists){
      lst.clear();
      Map<dynamic,dynamic> values = dat.value as Map;

      values.forEach((key, values) {
        lst.add(values);


      });
    }

    final fl=lst[0]['First_name']+lst[0]['Last_name'];


    try {

      if(ems!=null){
        print(lst[0]);
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: mail,
            password: pass
        );
        String user=userCredential.user?.uid as String;

        Map<String, String> userData = {
          'Email':mail,
          'First_name':lst[0]['First_name'],
          'Last_name': lst[0]['Last_name'],
          'Number': lst[0]['Number'],
          'uid': user,
          'Role':lst[0]['Role'],
          'Online':'0',
          'Status':'Active',
          'Hospital':lst[0]['Hospital'],
          'Hospital_uid':lst[0]['Hospital_uid']
        };
        ref.child(name+user).set(userData);
        User? users = FirebaseAuth.instance.currentUser;

        if (users!= null && !users.emailVerified) {
          await users.sendEmailVerification();
        }
        fb.ref('users/ems_temp/$fl').remove();
        print(mail);
        Navigator.of(context).push(_createRoutes());

      }else{
        print("Email does not exist");
      }



    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
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

