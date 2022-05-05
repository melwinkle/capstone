import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:lamber/ambulances.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/request.dart';
import 'package:lamber/first_aid.dart';
import 'package:lamber/profile.dart';
import 'package:lamber/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
void main() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Homepage',
      home: MyHomePage(),
        debugShowCheckedModeBanner:false
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Homepage createState() => Homepage();
}

class Homepage extends State<MyHomePage> {
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

  String location = 'Null, Press Button';
  String Address = '';
  String FullAddress='';
  String Street='';
  String locat='';
  String FullName='';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }


  Future<String> GetAddressFromLatLong() async {
    Position position = await _getGeoLocationPosition();
    location =
    'Lat: ${position.latitude} , Long: ${position
        .longitude}';
    locat='${position.latitude},${position
        .longitude}';
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      Address = '${place.street},${place.name},${place.country}';
      FullAddress='${place.street}, ${place.subLocality}, ${place.subLocality}, ${place
    .thoroughfare}, ${place.country}';
Street='${place.street}';

    });

String address='${place.street},${place.name},${place.subLocality}\n${place.thoroughfare},${place.country}';
return address;
  }

  Future<String>GetProfile() async {
    final userid=FirebaseAuth.instance.currentUser?.uid;
    final fb = FirebaseDatabase.instance.ref('users/clients/$userid');
    final snapshot = await fb.get();
    if (snapshot.exists) {
      Map<dynamic,dynamic> values = snapshot.value as Map<dynamic, dynamic>;

      values.forEach((key, value) {
        if(key=="FullName"){
          setState(() {
            FullName = value;


          });
        }

      });
    } else {
      setState(() {
        FullName = "User";


      });
    }

    return FullName;

  }
  @override
  void initState() {
    // TODO: implement initState
    GetAddressFromLatLong();
    GetProfile();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      bottomNavigationBar: Container(
          margin: const EdgeInsets.only(top:42,left:0,right:0,bottom:0),
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
      body: ListView(
        children: [
      Align(
        alignment: const Alignment(0.01, 0.09),
        child: SizedBox(
          height: 570.0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:10.0, bottom:5, left:5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                    Text("Hi,"+FullName,style:const TextStyle(
                      fontFamily:'Helvetica',
                      color: Color(0xFFDB5461),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                    )),
                    const Icon(Icons.waving_hand_rounded,color:Colors.amber)
                  ],
                ),
                ),



               const Padding(
                 padding: EdgeInsets.only(left: 5.0, top: 2.0, bottom: 1.0),
                 child: Align(
                   alignment: Alignment.topLeft,
                   child: Text(
                     'Emergency Situation?',
                     style: TextStyle(
                       fontFamily: 'Helvetica',
                       fontSize: 16.0,
                       color: Color(0xFFDB5461),
                       fontWeight: FontWeight.w500,
                     ),
                   ),
                 ),
               ),

              const Padding(
                padding: EdgeInsets.only(left: 5.0, top: 1.0, bottom: 1.0),
                child:Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Press the button below',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 12.0,
                      color: Color(0xFFFFC3C7),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),



              Container(
                  width: 600.0,
                  height: 200.0,
                  margin: const EdgeInsets.only(top:20,left:25,right:25),

                    child: ElevatedButton(
                      onPressed: () {
                        sosrequest(Address,locat);
                      },
                      child: const Text(
                        'SOS',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFDB5461)),
                          shape: MaterialStateProperty.all(const CircleBorder(
                              side: BorderSide(
                                  width: 12, color: Color(0xFFFFC3C7))))),

                  )),

              Container(

                margin: const EdgeInsets.all(25),
                child: OutlinedButton(
                    onPressed: ()  {
                    }
                    ,
                    child: Row(
                      children: [
                        Column(
                          children: const [
                    Padding(padding:EdgeInsets.only (top:10),
                  child:
                            Icon(Icons.location_on,
                                size: 24, color: Color(0xFFDB5461))
                    )
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding:EdgeInsets.only (top:2,bottom:1),
                              child:
                            Text(
                              'Current Address',
                              style: TextStyle(
                                color: Color(0xFFDB5461),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Helvetica"
                              ),
                            ),
                            ),

                            Padding(padding:const EdgeInsets.only (top:2,bottom:2),
                                child:Text(
                                  Address,
                                  style: const TextStyle(
                                    color: Color(0xFFDB5461),
                                    fontSize: 10.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            )

                          ],
                        ),
                      ],
                    ),
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(300, 50),
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        width: 1.0,
                        color: Color(0xFFDB5461),
                        style: BorderStyle.solid,
                      ),
                    )),
              ),



              Container(
                  width: 270.0,
                  height: 50.0,
                  margin: const EdgeInsets.only(top:5,bottom:8),

                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  MyAmbulancePage(),
                          ),
                        );
                      },
                      child: const Text(
                        'AVAILABLE AMBULANCES',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 10.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xFFDB5461)),
                      ),
                    ),
                  ),





            ],
          ),
        ),
      ),
    ])
    );
  }

  void ver() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }


  Future<void> sosrequest(String street, String locat) async {
    final userid = FirebaseAuth.instance.currentUser?.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/clients");
    Query query = ref.orderByKey().equalTo(userid);
    DataSnapshot event = await query.get();
    var username;
    var phone;
    var cmail;
    Map<dynamic, dynamic> values = event.value as Map<dynamic, dynamic>;
    values.forEach((key, value) {
      username = value['FullName'].toString();
      phone = value['Phone'].toString();
      cmail=value['Email'].toString();
    });
    final time = DateFormat("EEEEE MMM dd yyyy HH:mm:ss a").format(
        DateTime.now());
    final times = DateFormat("MMddyyyyHHmm").format(DateTime.now());
    final pick = DateFormat("HH:mm:ss a").format(DateTime.now());
    final requestid = username.toString().substring(0, 3).trim() + "Gen" + times.toString();
    DatabaseReference request = FirebaseDatabase.instance.ref(
        "requests/$requestid");
    try {
      await request.set({
        "Customer_Name": username,
        "Customer_Number": phone,
        "Customer_uid": userid,
        "Customer_location":locat,
        "Destination": street,
        "Pick_Up_Time": pick,
        "Request_DateTime": time,
        "Request_Type": "General",
        "Status": "Pending",
        "Request_id": requestid,
        "Customer_Email":cmail,
        "Payment_Status":"Not Paid",
        "Reason":"Emergency"
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoaderPage(todo: requestid),
        ),
      );
    } on Exception catch (e, s) {
      print(s);
    }

    print(
        requestid + "," + userid! + "," + username + "," + phone + "," + time);
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

Route _createRouter() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Page4(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}



class Page2 extends StatelessWidget{
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Ambulances'),
        backgroundColor: Color(0xFFA34747),
      ),
      body: MyAmbulancePage(),
    );
  }
}


class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyRequestPage(),
    );
  }
}


class LoaderPage extends StatefulWidget {
  final todo;
  const LoaderPage({Key? key,required this.todo}) : super(key: key);

  @override
  Loader createState() {
    return Loader();
  }
}

class Loader extends State<LoaderPage> with TickerProviderStateMixin {


  // Declare a field that holds the Todo.


  late AnimationController controller;

  String status='';

  Future<void> approv(id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests");
    Query query = ref.orderByKey().equalTo(id);
    DataSnapshot event = await query.get();



    Map<dynamic, dynamic> values = event.value as Map<dynamic, dynamic>;

    values.forEach((key, value) {
      setState(() {
        status=value['Status'];
      });
      if(status=="Ongoing"){
        Navigator.of(context).push(_createRouter());
      }

    });

  }
  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {
        status="Pending";
      });
    });
    controller.repeat(reverse: true);

    super.initState();

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFFD87D8C),
      body: Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
          width: 304.0,
          height: 812.0,
          child: Column(
            children: <Widget>[
              const Spacer(flex: 30),
// Group: Group 32

              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Please wait as a hospital approves',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 15.0,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Click on the button below',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 10.0,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(flex: 15),
              Container(
                  width: 600.0,
                  height: 250.0,
                  margin: EdgeInsets.all(25),

                    child: ElevatedButton(
                      onPressed: () {
                        approv(widget.todo.toString());

                      },
                      child: const Text(
                        'SOS',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFDB5461),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFFFFFF)),
                          shape: MaterialStateProperty.all(const CircleBorder(
                              side: BorderSide(
                                  width: 12, color: Color(0xFFEFDFDF))))),
                    ),
                  ),
              Container(
                child: Center(
                  child: LinearProgressIndicator(
                    value: controller.value,
                    semanticsLabel: 'SOS request confirmation',
                    minHeight: 10.0,
                    color: Color(0xFFDB5461),
                  ),
                ),
              ),
              Container(
                  width: 250.0,
                  height: 50.0,
                  margin: EdgeInsets.all(25),

                    child: OutlinedButton(
                        onPressed: () {
                          cancel(widget.todo.toString());
                        },
                        child: const Text(
                          'CANCEL REQUEST',
                          style: TextStyle(
                            color: Color(0xFFDB5461),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            width: 2.0,
                            color: Color(0xFFDB5461),
                            style: BorderStyle.solid,
                          ),
                        )),
                  ),

              Spacer(flex: 20),
            ],
          ),
        ),
      ),
    );
  }





  Future<void> cancel(id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests/$id");
    try {
      await ref.update({
        "Status": "Cancel",
        "Hospital_name":"Cancelled",
        "Hospital_location":"Cancelled"
      });
      Navigator.of(context).push(_createRouter());
    } on Exception catch (e, s) {
      print(s);
    }


  }
}


class MapTest extends StatelessWidget{
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(5.760386449204086, -0.2198346862775333);

  MapTest({Key? key}) : super(key: key);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      );
  }

}