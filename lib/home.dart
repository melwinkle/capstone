
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:lamber/users/ambulances.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/request.dart';

import 'package:lamber/profile.dart';

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
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
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
    const MyProfilePage(),
  ];

  String location = 'Null, Press Button';
  String Address = '';
  String FullAddress='';
  String Street='';
  String locat='';
  String FullName='';
  List<dynamic> lst = [];
  List<dynamic> hosp = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  final userid=FirebaseAuth.instance.currentUser?.uid;
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

      Address = '${place.street},${place.name},${place.country}';
      FullAddress='${place.street}, ${place.subLocality}, ${place.subLocality}, ${place
          .thoroughfare}, ${place.country}';
      Street='${place.street}';




String address='${place.street},${place.name},${place.subLocality}\n${place.thoroughfare},${place.country}';

return address;
  }


  showData () async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests");

    Query query = ref.orderByChild("Personnel_uid").equalTo(userid);



    DataSnapshot event = await query.get();



    return event.value;
  }

  Future<String>GetProfile() async {
    final userid=FirebaseAuth.instance.currentUser?.uid;
    final fb = FirebaseDatabase.instance.ref('users/ems/$userid');
    final snapshot = await fb.get();
    if (snapshot.exists) {
      Map<dynamic,dynamic> values = snapshot.value as Map<dynamic, dynamic>;

      values.forEach((key, value) {
        if(key=="First_name"){
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

    GetProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    GetAddressFromLatLong();
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      bottomNavigationBar:  Container(

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
                  label: 'Account',
                  icon: Icon(Icons.person_outlined),
                ),
              ],
            ),

          )
      ) ,
      body: Align(
        alignment: const Alignment(0.01, 0.09),
        child: SizedBox(
          height: 812.0,
          child: Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top:30.0,bottom:30.0)),
          Align(

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
              )),

              FutureBuilder(
                future: GetAddressFromLatLong(),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasError) return Text('${snapshot.error}');
                  if (snapshot.hasData) {
                    return  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index)  {




                        return Container(

                            margin:EdgeInsets.only(left: 5.0, top: 0.0, bottom: 5.0,right: 5.0,),

                              child: OutlinedButton(
                                  onPressed: ()  {

                                  }


                                  ,
                                  child: Row(

                                    children: [
                                  Column(
                                  children: const [
                                  Padding(padding:EdgeInsets.only (top:5),
                                  child:
                                  Icon(Icons.location_on,
                                      size: 24, color: Color(0xFFFFFFFF))
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
                                                  color: Color(0xFFFFFFFF),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Helvetica"
                                              ),
                                            ),
                                          ),

                                          Padding(padding:const EdgeInsets.only (top:2,bottom:2),
                                            child:Text(
                                              Address,
                                              style: const TextStyle(
                                                color: Color(0xFFFFFFFF),
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
                                    fixedSize: const Size(250, 50),
                                    backgroundColor: Color(0xFFDB5461),

                                  )),
                            );
                      });
                  }
                  return Container(

                      margin:EdgeInsets.only(left: 5.0, top: 2.0, bottom: 5.0,right: 5.0,),

                        child: OutlinedButton(
                            onPressed: ()  {

                            }


                            ,
                            child: Row(

                              children: [
                                Column(
                                  children: const [
                                    Padding(padding:EdgeInsets.only (top:5),
                                        child:
                                        Icon(Icons.location_on,
                                            size: 24, color: Color(0xFFDB5461))
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Padding(padding:EdgeInsets.only (top:2,bottom:1),
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

                                    Padding(padding:EdgeInsets.only (top:2,bottom:2),
                                      child:Text(
                                        "No Location",
                                        style: TextStyle(
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
                            style:OutlinedButton.styleFrom(
                              fixedSize: const Size(250, 55),
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                width: 1.0,
                                color: Color(0xFFDB5461),
                                style: BorderStyle.solid,
                              ),
                            )),
                      );
                },
              ),
              const Padding(padding: EdgeInsets.all(10.0),),
              FutureBuilder(
                  future:showData(),

                  builder: (context, AsyncSnapshot snapshot) {

                    if (snapshot.hasData) {
                      lst.clear();
                      Map<dynamic, dynamic> values = snapshot.data;

                      values.forEach((key, values) {
                        // lst.add(values);
                        lst.add(values);


                      });
                     int rat=0;
                      int tot=0;
                      lst.forEach((element) {
                        if(element["Rating"]==null){
                          tot=0;
                        }else{
                          tot=int.parse(element["Rating"].toString());
                        }
                        rat+=tot;

                      });

                      return Container(
                          width:400,
                          margin:EdgeInsets.only(top: 5.0, bottom: 1.0),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(

                                onPressed: () {  },
                                child: Column(
                                  children: [
                                    Icon(Icons.receipt,color: Color(0xFFDB5461),),
                                    Text(
                                        "TOTAL REQUESTS",style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xFFDB5461)
                                    ),

                                    ),
                                    Text(
                                        lst.length.toString(),style: TextStyle(
                                       color: Color(0xFFDB5461)
                                    ),

                                    )
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 40),
                                    fixedSize: const Size(150, 145), primary: Color(0xFFFFFFFF),
                                  side: const BorderSide(
                                    width: 1.0,
                                    color: Color(0xFFDB5461),
                                    style: BorderStyle.solid,

                                  ),),


                              ),
                              ElevatedButton(

                                onPressed: () {  },
                                child: Column(
                                  children: [
                                    Icon(Icons.star,color: Color(0xFFDB5461),),
                                    const Text(
                                        "AVERAGE RATING",style:TextStyle(
                                        fontSize: 12.0,
                                      color: Color(0xFFDB5461),
                                    )

                                    ),
                                    Text(
                                        rat.toString(),style: const TextStyle(
                                      color: Color(0xFFDB5461),
                                    ),
                                    )
                                  ],
                                ),style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 40),
                                  fixedSize: const Size(150, 145), primary: Color(0xFFFFFFFF),
                                side: const BorderSide(
                                  width: 1.0,
                                  color: Color(0xFFDB5461),
                                  style: BorderStyle.solid,
                                ),
                              ),
                              )

                            ],
                          )
                      );
                    }
                    return Container(
                        width:400,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(

                              onPressed: () {  },
                              child: Column(
                                children: [
                                  Icon(Icons.receipt),
                                  Text(
                                      "TOTAL REQUESTS",style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontSize: 8.0,

                                    fontWeight: FontWeight.w500,

                                  )

                                  ),
                                  Text(
                                      "0"

                                  )
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 40),
                                  fixedSize: const Size(150, 140), primary: Color(0xFFDB5461)),
                            ),
                            ElevatedButton(

                              onPressed: () {  },
                              child: Column(
                                children: [
                                  Icon(Icons.star),
                                  Text(
                                      "AVERAGE RATING",style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontSize: 8.0,

                                    fontWeight: FontWeight.w500,

                                  )

                                  ),
                                  Text(
                                      "0.0"
                                  )
                                ],
                              ),style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 40),
                                fixedSize: const Size(150, 140), primary: Color(0xFFDB5461)),
                            )

                          ],
                        )
                    );
                  }),

Padding(padding: EdgeInsets.only(bottom:15.0),),


              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Assigned Request',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 15.0,
                    color: Color(0xFFDB5461),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              FutureBuilder(
                  future:showData(),

                  builder: (context, AsyncSnapshot snapshot) {

                    if (snapshot.hasData) {
                      lst.clear();
                      Map<dynamic, dynamic> values = snapshot.data;

                      values.forEach((key, values) {
                        // lst.add(values);
                        if(values["Status"]=="Ongoing"){
                          lst.add(values);
                        }




                      });

                      var tot;
                      var hosplong;
                      var hosplang;
                      var index;
var com;
                      if(lst.isNotEmpty){
                        lst.forEach((element) {
                          if(element["Status"]=="Ongoing"){
                            tot=element["Request_id"].toString();
                            final hospl=element["Hospital_location"].toString().split(",");
                            hosplang=double.parse(hospl[0]);
                            hosplong=double.parse(hospl[1]);
                            // hosp.add(element);
                            index=0;
                            hosp.insert(index, element);



                          }


                        });
                        return Container(
                            width: 320.0,
                            height: 92.0,
                           margin: EdgeInsets.only(top:10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child:SizedBox(
                                child:DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(color: Color(0xFFDB5461))
                                    ),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Assigned Request for #"+tot.toString(),style: const TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontSize: 12.0,
                                          color: Color(0xFFDB5461),
                                          fontWeight: FontWeight.w300,

                                        )),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            OutlinedButton(

                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => MapPage(long: hosplong, lang:hosplang, tod:hosp[index]),
                                                  ),
                                                );

                                              },
                                              child: const Text(
                                                  "VIEW REQUEST",
                                                  style: TextStyle(
                                                    fontFamily: 'Helvetica',
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  )

                                              ),
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: Color(0xFFDB5461),
                                                side: BorderSide(
                                                  width: 1.0,
                                                  color: Color(0xFFDB5461),
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                            ),


                                          ],

                                        )
                                      ],
                                    )
                                )

                            )
                        );
                      }else{
                        return Container(
                            width: 300.0,
                            height: 55.0,
                            margin: EdgeInsets.only(top:22.0,bottom: 25.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child:SizedBox(
                                child:DecoratedBox(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.0),
                                        border: Border.all(color: Color(0xFFDB5461))
                                    ),
                                    child:Column(

                                      children: const [
                                        Center(
                                          child: Text("No Assigned Requests",style: TextStyle(
                                            fontFamily: 'Helvetica',
                                            fontSize: 15.0,
                                            color: Color(0xFFDB5461),
                                            fontWeight: FontWeight.w300,

                                          )),
                                        )


                                      ],
                                    )
                                )

                            )
                        );
                      }




                    }
                    return Container(
                        width: 300.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child:SizedBox(
                            child:DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: Color(0xFFA34747))
                                ),
                                child:Column(
                                  children: [
                                    Center(
                                      child: Text("No Assigned Requests",style: TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontSize: 15.0,
                                        color: Color(0xFFA34747),
                                        fontWeight: FontWeight.w300,

                                      )),
                                    )


                                  ],
                                )
                            )

                        )
                    );
                  }),







              Padding(padding: EdgeInsets.all(20.0),),




            ],
          ),
        ),
      ),
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
    Map<dynamic, dynamic> values = event.value as Map<dynamic, dynamic>;
    values.forEach((key, value) {
      username = value['FullName'].toString();
      phone = value['Phone'].toString();
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
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
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

              const Align(
                alignment: Alignment(-0.88, 0.0),
                child: Text(
                  'Please wait as we connect you to a hospital',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25.0,
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
                  ),
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

                    child: OutlinedButton(
                        onPressed: () {
                          cancel(widget.todo.toString());
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
                  ),

              Spacer(flex: 20),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> approv(id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests");
    Query query = ref.orderByKey().equalTo(id);
    DataSnapshot event = await query.get();



    Map<dynamic, dynamic> values = event.value as Map<dynamic, dynamic>;

    values.forEach((key, value) {
      if(value['Status']=="Ongoing"){

        Navigator.of(context).push(_createRouter());

      }
    });

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