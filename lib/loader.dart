import 'package:lamber/ambulances.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/request.dart';
import 'package:lamber/first_aid.dart';
import 'package:lamber/profile.dart';
import 'package:lamber/home.dart';
import 'package:lamber/request_accepted.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Homepage',
      home: MyLoaderPage(),
    );
  }
}

class MyLoaderPage extends StatefulWidget {
  const MyLoaderPage({Key? key}) : super(key: key);

  @override
  Loaderpage createState() => Loaderpage();
}

class Loaderpage extends State<MyLoaderPage> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
      backgroundColor: const Color(0xFFA34747),
      body: Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 812.0,
          child: Column(
            children: <Widget>[
              const Spacer(flex: 30),
// Group: Group 32

              Align(
                alignment: const Alignment(-0.88, 0.0),
                child: Text(
                  'Please wait as we connect you to a hospital',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: const Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(flex: 15),
              Container(
                  width: 600.0,
                  height: 250.0,
                  margin: EdgeInsets.all(25),
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(_createRoutes());
                      },
                      child: const Text(
                        'SOS',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF810C0C),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFFFFFF)),
                          shape: MaterialStateProperty.all(const CircleBorder(
                              side: BorderSide(
                                  width: 12, color: Color(0xFFEFDFDF))))),
                    ),
                  )),
              Container(
                child: Center(
                  child: LinearProgressIndicator(
                    value: controller.value,
                    semanticsLabel: 'SOS request confirmation',
                    minHeight: 10.0,
                    color: Color(0xFF064457),
                  ),
                ),
              ),
              Container(
                  width: 250.0,
                  height: 50.0,
                  margin: EdgeInsets.all(25),
                  child: Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoute());
                        },
                        child: const Text(
                          'CANCEL REQUEST',
                          style: TextStyle(
                            color: Color(0xFFA34747),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            width: 2.0,
                            color: Color(0xFFA34747),
                            style: BorderStyle.solid,
                          ),
                        )),
                  )),

              Spacer(flex: 20),
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
      home: MyHomePage(),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyConfirmAPage(),
    );
  }
}
