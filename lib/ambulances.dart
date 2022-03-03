
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lamber/users/book.dart';
import 'package:flutter/material.dart';
import 'package:lamber/home.dart';
import 'package:lamber/first_aid.dart';
import 'package:lamber/profile.dart';
import 'package:lamber/request.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';

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
      home: MyAmbulancePage(),
    );
  }
}

class MyAmbulancePage extends StatefulWidget {
  const MyAmbulancePage({Key? key}) : super(key: key);

  @override
  Ambulancepage createState() => Ambulancepage();
}

class Ambulancepage extends State<MyAmbulancePage> {
  int _currentIndex = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance.ref("hospital").orderByKey();
  String hospital='';
  List<dynamic> hos=[];
  List<dynamic> lst = [];
  final usersQuery = FirebaseDatabase.instance.ref("hospital");

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
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  String location = 'Null, Press Button';
  String Address = '';
  String FullAddress='';
  String Street='';
  List<dynamic> locati=[];
  String locat='';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }


  Future<void> GetAddressFromLatLong(Position position) async {



    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street},${place.name},${place.subLocality}\n${place.thoroughfare},${place.country}';
    FullAddress = '${place.street}, ${place.subLocality}, ${place.subLocality}, ${place
        .thoroughfare}, ${place.country}';
    Street='${place.street}';


    print("Add"+Address);

  }

  Future<void> backloc() async {
    Position position = await _getGeoLocationPosition();
    location =
    'Lat: ${position.latitude} , Long: ${position
        .longitude}';


    locati.add(position.latitude);
    locati.add(position.longitude);
    GetAddressFromLatLong(position);

  }
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
              Padding(padding: const EdgeInsets.all(30.0)),
// Group: Group 32

              // const Align(
              //   alignment: Alignment(-0.88, 0.0),
              //   child: Text(
              //     'Available Ambulances',
              //     style: TextStyle(
              //       fontFamily: 'Helvetica',
              //       fontSize: 25.0,
              //       color: Color(0xFFA34747),
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              // ),


              Container(
                height: 540,
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

                            backloc();

                            final langf=locati[0];

                            final longf=locati[1];

                            final hospl=lst[index]["Hospital_location"].toString().split(",");
                            final hosplang=double.parse(hospl[0]);
                            final hosplong=double.parse(hospl[1]);
                            double dis=calculateDistance(langf, longf, hosplang, hosplong);
                            return Container(

                              child:Flexible(
                                // to apply margin in the cross axis of the wrap
                                child:Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                        SizedBox(
                                              child: OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>  BookPage(todo: lst[index],add:Address,loca:locati),
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
                                                dis.toStringAsFixed(2)+"km away",
                                              style: const TextStyle(
                                              color: Color(0xFFA34747),
                                              fontSize: 10.0,
                                              ),
                                              ),
                                              ],
                                              ),
                                              Container(
                                              alignment: const Alignment(1.0, -0.4),
                                              child: const Icon(Icons.verified_user,
                                              size: 15, color: Colors.green),
                                              )
                                              ],
                                              ),
                                              style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              fixedSize: const Size(350, 80),
                                              )),
                            ),
                                      const Padding(padding: EdgeInsets.only(top: 10.0)),

  ]
                                )
                            )
                            );

                          });
                    }
                    return CircularProgressIndicator();
                  }),

              ),

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

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyBookPage(),
    );
  }
}


class BookPage extends StatelessWidget {
  // In the constructor, require a Todo.
  BookPage({Key? key, required this.todo, required this.add, required this.loca}) : super(key: key);

  // Declare a field that holds the Todo.

  final todo;
  final add;
  final loca;
  final userid=FirebaseAuth.instance.currentUser?.uid;
  final fb = FirebaseDatabase.instance.ref('users/clients').orderByKey();
  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];
  showData () async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/clients");

    Query query = ref.orderByKey().equalTo("$userid");

    DataSnapshot event = await query.get();

    return event.value;
  }
  int _currentIndex = 0;


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

              Padding(padding: const EdgeInsets.all(5.0)),


              Padding(padding: const EdgeInsets.all(5.0)),
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
                      child: Column(children:  [

                        Padding(padding: EdgeInsets.all(8.0)),
                         MyCustomForm(todo: todo,add:add,loca:loca),
                    
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
class MyCustomForm extends StatefulWidget {


  const MyCustomForm({Key? key,required this.todo, required this.add, required this.loca}) : super(key: key);

  final todo;

  final add;
final loca;
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  final _formKey = GlobalKey<FormState>();
  TextEditingController timeinput = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController snotes = TextEditingController();





  Widget build(BuildContext context) {
    final hosp=widget.todo["Hospital_name"].toString();
    final hospid=widget.todo["uid"].toString();

    final loc=widget.add;

    final locs=widget.loca[0].toString()+","+widget.loca[1].toString();
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment(-0.88, 0.00),
            width: 300,
            child: TextFormField(
              controller: timeinput,
              // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_clock),
                    hintText: 'Pick Up Time',
                    hintStyle: TextStyle(color: Color(0xFFA34247)),
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    prefixIconColor: Color(0xFFA34247),
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),readOnly: true,  //set it true, so that user will not able to edit text
              onTap: () async {
                TimeOfDay? pickedTime =  await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );

                if(pickedTime != null ){
                  print(pickedTime.format(context));   //output 10:51 PM
                  DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                  //converting to DateTime so that we can further format on different pattern.
                  print(parsedTime); //output 1970-01-01 22:53:00.000
                  String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                  print(formattedTime); //output 14:59:00
                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                  setState(() {
                    timeinput.text = formattedTime; //set the value of text field.
                  });
                }else{
                  print("Time is not selected");
                }
              },),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
          ),


          TextFormField(
              controller: snotes,
            // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter notes';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Special Notes eg emergency type',
                  hintStyle: TextStyle(color: Color(0xFFA34247)),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  prefixIconColor: Color(0xFFA34247),
                  isDense: true, // Added this
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
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
                      // Navigator.of(context).push(_createRouter());
                      sendrequest(timeinput.text,snotes.text,loc,hosp,hospid,locs);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //    SnackBar(content: Text(timeinput.text+location.text+snotes.text)),
                      // );
                    }
                  },
                  child: Text('Book'),
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

  Future<void> sendrequest(pick,notes,location,hosp,hospid,locs) async {

    final userid=FirebaseAuth.instance.currentUser?.uid;

    DatabaseReference ref = FirebaseDatabase.instance.ref("users/clients");
    Query query = ref.orderByKey().equalTo(userid);
    DataSnapshot event = await query.get();
    var username;
    var phone;


    Map<dynamic, dynamic> values = event.value as Map<dynamic, dynamic>;

    values.forEach((key, value) {
      username=value['FullName'].toString();
      phone=value['Phone'].toString();
    });
    final time=DateFormat("EEEEE MMM dd yyyy HH:mm:ss a").format(DateTime.now());
    final times=DateFormat("MMddyyyyHHmm").format(DateTime.now());
    final requestid=username.toString().substring(0,3).trim()+hosp.toString().substring(0,3).trim()+times.toString();

    DatabaseReference request = FirebaseDatabase.instance.ref("requests/$requestid");


    try {
      await request.set({
        "Customer_Name": username,
        "Customer_Number": phone,
        "Customer_uid": userid,
        "Customer_location": locs,
        "Destination":location,
        "Pick_Up_Time":pick,
        "Reason":notes,
        "Request_DateTime":time,
        "Request_Type":"Specific",
        "Status":"Pending",
        "Hospital_name":hosp,
        "Hospital_uid":hospid,
        "Request_id":requestid,


      });
      Navigator.of(context).push(_requestsent());
    } on Exception catch (e, s) {
      print(s);
    }

    print (requestid+","+userid!+","+username+","+phone+","+time+","+location+","+notes+","+hosp+","+hospid);


  }

}

Route _requestsent() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Request(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

class Request extends StatelessWidget {
  const Request({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyRequestPage(),
    );
  }
}



