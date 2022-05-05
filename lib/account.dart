
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/request.dart';
import 'package:lamber/users/first_aid.dart';
import 'package:lamber/profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      title: 'Profile',
      home: MyAccountPage(),
    );
  }
}

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);



  @override
  Accountpage createState() => Accountpage();
}

class Accountpage extends State<MyAccountPage> {
  int _currentIndex = 3;
  FirebaseAuth auth = FirebaseAuth.instance;
  final userid=FirebaseAuth.instance.currentUser?.uid;
  final fb = FirebaseDatabase.instance.ref('users/ems').orderByKey();
  List<dynamic> lst = [];


  final _formKey = GlobalKey<FormState>();
  final fullname = TextEditingController();
  final lastname = TextEditingController();
  @override
  void initState(){

  }










  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color(0xFFDB5461)
        ),
      ),
      body: Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 812.0,
          child: Column(
            children: <Widget>[
// Group: Group 32

              const Align(
                alignment: Alignment.center,
                child:  Text("My Details", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                    color:Color( 0xFFDB5461)
                ),),
              ),
              Container(
                  child:FutureBuilder(
                      future: fb.equalTo(userid!).get(),

                      builder: (context, AsyncSnapshot snapshot) {

                        if (snapshot.hasData) {
                          lst.clear();
                         Map<dynamic,dynamic> values = snapshot.data.value;

                          values.forEach((key, values) {
                            lst.add(values);


                          });

                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: lst.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(

                                    child: Form(
                                    key: _formKey,
                                    child:Column(
                                        children: [

                                          Padding(padding: const EdgeInsets.all(5.0)),
                                          Container(
                                            child: const Text(
                                              "First Name",
                                              style: TextStyle(
                                                color: Color(0xFFDB5461),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                            alignment: Alignment.topLeft,
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.all(2.0)),


                                          TextFormField(
                                              initialValue: lst[index]["First_name"].toString(),
                                              style: TextStyle(
                                                  fontSize: 10.0
                                              ),
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(Icons.lock),
                                                  filled: true,
                                                  fillColor: const Color(0xFFFFF1F4),
                                                  contentPadding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    borderSide: BorderSide.none,
                                                  ))),

                                          Padding(
                                              padding: const EdgeInsets.all(5.0)),
                                          Container(
                                            child: const Text(
                                              "Last Name",
                                              style: TextStyle(
                                                color: Color(0xFFDB5461),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                            alignment: Alignment.topLeft,
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.all(5.0)),


                                          TextFormField(
                                              initialValue: lst[index]["Last_name"].toString(),
                                              style: TextStyle(
                                                  fontSize: 10.0
                                              ),
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(Icons.lock),
                                                  filled: true,
                                                  fillColor: const Color(0xFFFFF1F4),
                                                  contentPadding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    borderSide: BorderSide.none,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(5.0)),
                                          Container(
                                            child: const Text(
                                              "Email",
                                              style: TextStyle(
                                                color: Color(0xFFDB5461),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.0,

                                              ),
                                            ),
                                            alignment: Alignment.topLeft,
                                          ),
                                          TextFormField(
                                              initialValue: lst[index]["Email"].toString(),
                                              style: TextStyle(
                                                  fontSize: 10.0
                                              ),
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(Icons.lock),
                                                  filled: true,
                                                  fillColor: const Color(0xFFFFF1F4),
                                                  contentPadding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    borderSide: BorderSide.none,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(5.0)),
                                          Container(
                                            child: const Text(
                                              "Phone Number",
                                              style: TextStyle(
                                                color: Color(0xFFDB5461),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                            alignment: Alignment.topLeft,
                                          ),
                                          TextFormField(
                                              initialValue: lst[index]["Number"].toString(),
                                              style: TextStyle(
                                                  fontSize: 10.0
                                              ),
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(Icons.lock),
                                                  filled: true,
                                                  fillColor: const Color(0xFFFFF1F4),
                                                  contentPadding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    borderSide: BorderSide.none,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(5.0)),
                                          Container(
                                            child: const Text(
                                              "Role",
                                              style: TextStyle(
                                                color: Color(0xFFDB5461),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                            alignment: Alignment.topLeft,
                                          ),
                                          TextFormField(
                                              initialValue: lst[index]["Role"].toString(),
                                              style: TextStyle(
                                                  fontSize: 10.0
                                              ),
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  prefixIcon: const Icon(Icons.lock),
                                                  filled: true,
                                                  fillColor: const Color(0xFFFFF1F4),
                                                  contentPadding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    borderSide: BorderSide.none,
                                                  ))),
                                          Padding(
                                              padding: const EdgeInsets.all(20.0)),

                                        ])
                                ));

                              });
                        }
                        return CircularProgressIndicator();
                      })
              ),
              


              Spacer(flex: 20),

            ],
          ),
        ),
      ),
    );
  }

  void sig(name,lname) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/ems/$userid");
    await ref.update({
      "First_name": name,
      "Last_name":lname
    });
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
    return const MaterialApp(
      home: SignIn(),
    );
  }
}
