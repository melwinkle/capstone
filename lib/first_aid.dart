import 'package:lamber/first_aid_sub.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/request.dart';
import 'package:lamber/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      title: 'First Aid',
      home: MyAidPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyAidPage extends StatefulWidget {
  const MyAidPage({Key? key}) : super(key: key);

  @override
  Aidpage createState() => Aidpage();
}

class Aidpage extends State<MyAidPage> {
  int _currentIndex = 2;
  // FirebaseAuth auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance.ref("first_aid").orderByKey();
  List<dynamic> lst = [];

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
      backgroundColor: const Color(0xFFFFFFFF),
      bottomNavigationBar:   Container(
          margin: const EdgeInsets.only(top:37,left:0,right:0,bottom:0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child:ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),

            ),

            child:BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              backgroundColor: Color(0xFFDB5461),
              selectedItemColor: Color(0xFFFFFFFF),
              unselectedItemColor: const Color(0xFFFFFFFF).withOpacity(.60),
              selectedFontSize: 14,
              unselectedFontSize: 12,


              onTap: (value) {
                // Respond to item press.
                setState(() => _currentIndex = value);
                _onTap();
              },
              items: const [
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(Icons.home_filled),
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

          )
      ),
      body:  ListView(
          children:[
            Align(
        alignment: Alignment(0.01, 0.09),
        child:
      SizedBox(

          height: 575.0,
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 5.0)),
// Group: Group 32
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'First Aid',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 20.0,
                    color: Color(0xFFDB5461),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),




              Container(
                padding: EdgeInsets.only(top:25.0),
             height: 545,
                child:FutureBuilder(
                    future: fb.get(),

                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        lst.clear();
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        values.forEach((key, values) {
                          lst.add(values);
                        });
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: lst.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(


                                  //

                                // to apply margin in the cross axis of the wrap
                                  child:Column(

                                      children: <Widget>[
                                        SizedBox(
                                          width: 300,
                                          child: OutlinedButton(
                                              onPressed: () {
                                                // Navigator.of(context).push(_createRoute());
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>  DetailScreen(todo: lst[index]),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,

                                                children: [
                                                  Column(

                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        alignment:Alignment.center,

                                                        child: Icon(Icons.healing,
                                                            size: 32,
                                                            color: Color(0xFFF0E6D7E)),
                                                      ),

                                                      Text(
                                                        lst[index]["Name"],
                                                        style: TextStyle(
                                                          color: Color(0xFFDB5461),
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: Color(0xFFFFF1F4),
                                                fixedSize: const Size(350, 95),
                                                side:BorderSide(
                                                  color: Color(0xFFDB5461),
                                                  width: 1.0,
                                                  style: BorderStyle.solid

                                                )
                                              )),
                                        ),
                                        const Padding(padding: EdgeInsets.only(top: 10.0)),

                                      ]
                                  )

                              );

                            });
                      }
                      return CircularProgressIndicator();
                    }),
                ),



            ],
          ),
        ),

      ),
          ])
    );
  }
}





class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  DetailScreen({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  final todo;

  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];

  int _currentIndex = 2;


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
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
              color: Color(0xFFDB5461)
          ),
        ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          // width: 304.0,
          // height: 812.0,
          child: Column(
            children: <Widget>[
              Container(

                child:  Icon(Icons.healing, color: Color(0xFFF0E6D7E),size: 128.0,),
              ),

              Padding(padding: const EdgeInsets.all(5.0)),
              Align(
                alignment: Alignment.center,
                child:  Text(todo["Name"].toString(), style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                    color:Color( 0xFFDB5461)
                ),),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  width: 300.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        Icon(Icons.verified_user, color: Colors.green),
                        Text(
                          todo["Description"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 12.0,
                            color: const Color( 0xFFDB5461),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(padding: const EdgeInsets.all(5.0)),
                      ]),
                    ),
                  )),



            ],
          ),
        ),
      ),
    );
  }
}