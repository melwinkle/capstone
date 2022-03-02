import 'package:lamber/request_confirm.dart';
import 'package:lamber/request_accepted.dart';
import 'package:lamber/request_final.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/first_aid.dart';
import 'package:lamber/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'map.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Requests',
      home: MyRequestPage(),
    );
  }
}

class MyRequestPage extends StatefulWidget {
  const MyRequestPage({Key? key}) : super(key: key);

  @override
  Requestpage createState() => Requestpage();
}

class Requestpage extends State<MyRequestPage> {
  int _currentIndex = 1;
  FirebaseAuth auth = FirebaseAuth.instance;
  final userid=FirebaseAuth.instance.currentUser?.uid;
  final fb = FirebaseDatabase.instance.ref("requests").orderByChild("Customer_uid");
  String hospital='';
  List<dynamic> hos=[];
  List<dynamic> lst = [];


  showData () async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests");

    Query query = ref.orderByChild("Customer_uid").equalTo(userid);

    DataSnapshot event = await query.get();

    print(event.value.toString());
    return event.value;
  }

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
              Padding(padding: const EdgeInsets.all(30.0)),
              const Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'All Requests',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                height: 600,
                  child:FutureBuilder(
                      future:showData(),

                      builder: (context, AsyncSnapshot snapshot) {

                        if (snapshot.hasData) {
                          lst.clear();
                          Map<dynamic, dynamic> values = snapshot.data;

                          values.forEach((key, values) {
                            // lst.add(values);
                            lst.add(values);


                          });


                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: lst.length,
                              itemBuilder: (BuildContext context, int index) {
                                var stat;
                                var ems;

                                if(lst[index]['Status']=="Pending"){
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.orange),
                                  );
                                  ems=ConfirmPage(todo: lst[index]);



                                }else if(lst[index]['Status']=="Completed"){
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.green[500]),
                                  );
                                  ems=ConfirmFPage(todo: lst[index]);
                                }else if(lst[index]['Status']=="Cancel"){
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.red),
                                  );
                                  ems=CancelPage(todo: lst[index]);
                                }else{
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.lightGreen),
                                  );
                                  ems=ConfirmAPage(todo: lst[index]);
                                };
                                return Container(

                                    child: Flexible(



                                    child: Column(
                                        children: [

                                          Padding(padding: const EdgeInsets.all(5.0)),
                                Container(
                                    alignment: Alignment(-0.78, -0.04),
                                    width: 300.0,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: SizedBox(
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>  ems,
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                            SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Image.asset('assets/images/ambulance.jpg'),
                                          ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    lst[index]["Hospital_name"],
                                                    style: const TextStyle(
                                                      color: Color(0xFFA34747),
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: const [
                                                      Icon(Icons.star,
                                                          size: 12, color: Colors.yellow),
                                                      Icon(Icons.star,
                                                          size: 12, color: Colors.yellow),
                                                      Icon(Icons.star,
                                                          size: 12, color: Colors.yellow),
                                                      Icon(Icons.star,
                                                          size: 12, color: Colors.yellow),
                                                      Icon(Icons.star,
                                                          size: 12, color: Colors.yellow)
                                                    ],
                                                  ),
                                                  Text(
                                                    lst[index]["Request_DateTime"],
                                                    style: TextStyle(
                                                      color: Color(0xFFA34747),
                                                      fontSize: 10.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              stat
                                            ],
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            fixedSize: const Size(350, 80),
                                          )),
                                    )),
                                        ])
                                )
                                );

                              });
                        }
                        return CircularProgressIndicator();
                      })
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




class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyConfirmPage(),
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

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyConfirmFPage(),
    );
  }
}


class ConfirmPage extends StatelessWidget {
  // In the constructor, require a Todo.
  ConfirmPage({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  final todo;


  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];

  int _currentIndex = 1;


  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.

    _onTap() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
          _children[_currentIndex])); // this has changed
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(todo["Hospital_name"].toString()),
        backgroundColor: const Color(0xFFA34747),
      ),
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
                  'Hospital will approve soon!',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: const Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Spacer(flex: 2),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 350.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        Text(
                          todo["Hospital_name"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 20.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow)
                          ],
                        ),
                        Padding(padding: const EdgeInsets.all(20.0)),

                        Text(
                          "Pick Up Time:"+todo["Pick_Up_Time"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "Request:"+todo["Request_DateTime"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "No notes",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        const Spacer(flex: 3),
                        Container(
                          child: Center(
                            child: LinearProgressIndicator(
                              value: 50,
                              semanticsLabel: 'Request confirmation',
                              minHeight: 10.0,
                              color: Color(0xFF064457),
                            ),
                          ),
                        ),
                        Container(
                          width: 100.0,
                          height: 50.0,
                          margin: EdgeInsets.all(20),
                          child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _cancel(todo["Request_id"].toString());

                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFB53A24)),
                                ),
                              )),
                        )
                      ]),
                    ),
                  )),

              Spacer(flex: 20),

            ],
          ),
        ),
      ),
    );
  }
  void _cancel(id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests/$id");
    await ref.update({
      "Status": "Cancel",
    });
  }

}
class ConfirmAPage extends StatelessWidget {
  // In the constructor, require a Todo.
  ConfirmAPage({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  final todo;

  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];

  int _currentIndex = 1;


  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.

    _onTap() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
          _children[_currentIndex])); // this has changed
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(todo["Hospital_name"].toString()),
        backgroundColor: const Color(0xFFA34747),
      ),
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
                  'EMS are on their way!',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: const Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Spacer(flex: 2),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                          child: Column(children: [
                            Text(
                              todo["Hospital_name"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 20.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              todo["Vehicle_Registration"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.star, size: 12, color: Colors.yellow),
                                Icon(Icons.star, size: 12, color: Colors.yellow),
                                Icon(Icons.star, size: 12, color: Colors.yellow),
                                Icon(Icons.star, size: 12, color: Colors.yellow),
                                Icon(Icons.star, size: 12, color: Colors.yellow)
                              ],
                            ),
                            Padding(padding: const EdgeInsets.all(3.0)),
                            Text(
                              todo["Destination"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              todo["Pick_Up_Time"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              todo["Request_DateTime"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              todo["Reason"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              "15 minutes",
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Container(
                              width: 200.0,
                              height: 50.0,
                              margin: EdgeInsets.all(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(_track());
                                },
                                child: const Text(
                                  'TRACK AMBULANCE',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFA43247)),
                                ),
                              ),
                            )
                          ])),
                    ),
                  )),

              Spacer(flex: 10),
              Container(
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFFA43247),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'assets/images/ambulance.jpg'),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                todo["Personnel"].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(_call());
                                },
                                child: Icon(Icons.phone),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF064457)),
                                ),
                              )
                            ],
                          )
                        ],
                      ))),

              Spacer(flex: 20),

            ],
          ),
        ),
      ),
    );
  }


  Route _track() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const MapPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  Route _call() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Phone(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

}
class ConfirmFPage extends StatelessWidget {
  // In the constructor, require a Todo.
  ConfirmFPage({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  final todo;

  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];

  int _currentIndex = 1;


  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.

    _onTap() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
          _children[_currentIndex])); // this has changed
    }
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
                  'Request #124',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: const Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Spacer(flex: 2),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Column(children: [
                            Text(
                              todo["Hospital_name"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 20.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              todo["Vehicle_Registration"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.star,
                                    size: 12, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12, color: Colors.yellow),
                                Icon(Icons.star,
                                    size: 12, color: Colors.yellow),
                                Icon(Icons.star, size: 12, color: Colors.yellow)
                              ],
                            ),
                            Padding(padding: const EdgeInsets.all(3.0)),
                            Text(
                              todo["Destination"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              todo["Pick_Up_Time"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              todo["Request_DateTime"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              "No notes",
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              "Total Trip time of 20 minutes",
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                          ]),
                        )),
                  )),

              Spacer(flex: 10),
              Container(
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFFA43247),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'assets/images/ambulance.jpg'),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                todo["Personnel"].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(_call());
                                },
                                child: Icon(Icons.phone),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF064457)),
                                ),
                              )
                            ],
                          )
                        ],
                      ))),

              Spacer(flex: 20),

            ],
          ),
        ),
      ),
    );
  }
  Route _call() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Phone(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

}
class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyRequestPage(),
    );
  }
}
class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyMapPage(),
    );
  }
}

class Phone extends StatelessWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignIn(),
    );
  }
}
class CancelPage extends StatelessWidget {
  // In the constructor, require a Todo.
  CancelPage({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  final todo;


  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];

  int _currentIndex = 1;


  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.

    _onTap() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
          _children[_currentIndex])); // this has changed
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(todo["Hospital_name"].toString()),
        backgroundColor: const Color(0xFFA34747),
      ),
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
                  'Request Cancelled',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
                    color: const Color(0xFFA34747),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Spacer(flex: 2),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 350.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        Text(
                          todo["Hospital_name"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 20.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow),
                            Icon(Icons.star, size: 12, color: Colors.yellow)
                          ],
                        ),
                        Padding(padding: const EdgeInsets.all(20.0)),

                        Text(
                          "Pick Up Time:"+todo["Pick_Up_Time"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "Request:"+todo["Request_DateTime"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "No notes",
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        const Spacer(flex: 3),



                      ]),
                    ),
                  )),

              Spacer(flex: 20),

            ],
          ),
        ),
      ),
    );
  }
  void _cancel(id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests/$id");
    await ref.update({
      "Status": "Cancel",
    });
  }

}