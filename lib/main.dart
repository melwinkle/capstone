import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/register_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
      home: Splash(),
    ),
  );
}
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}
class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                Page1()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFFFF1F4),
        child:Image.asset('assets/images/lamberlogo.png'),
    );
  }
}
class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,
      body: Align(
        alignment: const Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 812.0,
          child: Column(
            children: <Widget>[

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
                          fontSize: 25.0,
                          color: Color(0xFFB23A48),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),


                  ],
                ),
              ),

              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Request for an ambulance',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 15.0,
                    color: Color(0xFFDB5461),
                  ),
                ),
              ),

              Container(
                width: 350.0,
                height: 250.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset('assets/images/midlogo.png'),
              ),


              Container(
                  width: 250.0,
                  height: 50.0,
                  margin: const EdgeInsets.all(25),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoute());
                      },
                      child: const Text('Sign In'),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),

                              ),
                          ),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFFDB5461)),
                      ),
                    ),
                  ),

              Container(
                  width: 250.0,
                  height: 50.0,
                  margin: const EdgeInsets.all(25),

                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoutes());
                      },
                      child: const Text('Create Account',
                        style: TextStyle(
                        color: Color(0xFFDB5461),

                      ),),
                      style: OutlinedButton.styleFrom(
                        side:  const BorderSide(
                          color: Color(0xFFDB5461),

                          ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                      ),
                    )
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
      home: SignIn(),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Register(),
    );
  }
}
