import 'dart:ffi';


import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lamber/users/request_confirm.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:lamber/request_final.dart';
import 'package:flutter/material.dart';
import 'package:lamber/sign_route.dart';
import 'package:lamber/home.dart';
import 'package:lamber/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final fb = FirebaseDatabase.instance.ref("requests").orderByChild("Personnel_uid");
  String hospital='';
  List<dynamic> hos=[];
  List<dynamic> lst = [];
  String Address = '';
  String FullAddress='';
  String Street='';
  String location='';
  List<dynamic> locat=[];
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

    Placemark place = placemarks[0];
    Address = '${place.street},${place.name},${place.subLocality}\n${place.thoroughfare},${place.country}';
    FullAddress = '${place.street}, ${place.subLocality}, ${place.subLocality}, ${place
        .thoroughfare}, ${place.country}';
    Street='${place.street}';



  }

  Future<void> backloc() async {
    Position position = await _getGeoLocationPosition();
    location =
    'Lat: ${position.latitude} , Long: ${position
        .longitude}';


    locat.add(position.latitude);
    locat.add(position.longitude);
    GetAddressFromLatLong(position);

  }
  showData () async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests");

    Query query = ref.orderByChild("Personnel_uid").equalTo(userid);

    DataSnapshot event = await query.get();


    return event.value;
  }

  getaudio(id) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageUrl =
        await storageRef.child("audio/$id/temp.wav").getDownloadURL();
    return imageUrl;
  }

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

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    const MyRequestPage();
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      bottomNavigationBar:   Container(
          margin: const EdgeInsets.only(top:59,left:0,right:0,bottom:0),
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
      ),
      body: SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child:ListView(
      children:[Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(
    height: 600,

          child: Column(
            children: <Widget>[

              const Padding(padding: EdgeInsets.only(top:60.0,bottom:0.0)),
              const Align(

                alignment: Alignment.topLeft,
                child: Text(
                  'All Requests',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 20.0,
                    color: Color(0xFFDB5461),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                height: 420,
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
                          lst.sort((a, b) => b["Request_DateTime"].compareTo(a["Request_DateTime"]));


                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: lst.length,
                              itemBuilder: (BuildContext context, int index) {
                                var stat;
                                var ems;
                                backloc();
                                final hospl=lst[index]["Hospital_location"].toString().split(",");
                                final hosplang=double.parse(hospl[0]);
                                final hosplong=double.parse(hospl[1]);
                                if(lst[index]['Status']=="Pending"){
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.orange),
                                  );
                                  ems= MapPage(long: hosplong, lang:hosplang, tod:lst[index]);



                                }else if(lst[index]['Status']=="Completed"){
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.green[500]),
                                  );
                                  ems=MapPage(long: hosplong, lang:hosplang, tod:lst[index]);
                                }else if(lst[index]['Status']=="Cancel"){
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.red),
                                  );
                                  ems=MapPage(long: hosplong, lang:hosplang, tod:lst[index]);
                                }else{
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.lightGreen),
                                  );
                                  ems=MapPage(long: hosplong, lang:hosplang, tod:lst[index]);
                                };
                                return Container(





                                    child: Column(
                                        children: [

                                          Padding(padding: const EdgeInsets.all(5.0)),
                                Container(
                                    alignment: Alignment(-0.78, -0.04),
                                    width: 310.0,
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
                                            child: Image.asset('assets/images/midlogos.png'),
                                          ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "#"+lst[index]["Request_id"],
                                                    style: const TextStyle(
                                                      color: Color(0xFFDB5461),
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 15.0
                                                    ),
                                                  ),
                                                  Text(
                                                    lst[index]["Customer_Name"],
                                                    style: const TextStyle(
                                                      color: Color(0xFFDB5461),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10.0,
                                                    ),
                                                  ),

                                                  Text(
                                                    lst[index]["Request_DateTime"],
                                                    style: TextStyle(
                                                      color: Color(0xFFDB5461),
                                                      fontSize: 8.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              stat,

                                            ],
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Color(0xFFFFF1F4),
                                            fixedSize: const Size(350, 75),
                                            side: const BorderSide(
                                              width: 1.0,
                                              color: Color(0xFFDB5461),
                                              style: BorderStyle.solid,
                                            ),
                                          )),
                                    )),
                                        ])
                                )
                                ;

                              });
                        }
                        return Container(
                            child: Text("No Requests",style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 15.0,
                              color: Color(0xFFA34747),
                              fontWeight: FontWeight.w500,
                            )),
                        );
                      })
              ),



            ],
          ),
        ),
      ),
    ]))
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



class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyConfirmFPage(),
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


class MapPage extends StatefulWidget {

  MapPage({Key? key, required this.lang, required this.long, this.tod}) : super(key: key);
  final lang;
final long;
final tod;
  @override
  MapTrackPage createState() => MapTrackPage();
}
class MapTrackPage extends State<MapPage> {
//   MapTrackPage({Key? key, required this.lang, required this.long, this.tod}) : super(key: key);
// final lang;
// final long;
// final tod;

  late GoogleMapController mapController;

  // final LatLng _center = LatLng(todo,lons);

  String status="";

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()


   MapTrackPage();
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if(widget.tod["Status"]=="Ongoing"){
        status="Start Trip";
      }
      else if (widget.tod["Status"]=="Started"){
        status="Arrived";
      }
      else if (widget.tod["Status"]=="Arrived"){
        status="Start Trip";
      }
      else if(widget.tod["Status"]=="Trip"){
        status="End Trip";
      }

    });
  }
  String times='';
  String distances='';
  @override
  Widget build(BuildContext context) {
    final longf=widget.long;
    final langf=widget.lang;
    final LatLng _center = LatLng(longf,langf);




    final hospl=widget.tod["Customer_location"].toString().split(",");
    final hosplang=double.parse(hospl[0]);
    final hosplong=double.parse(hospl[1]);

    return  Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color(0xFFDB5461)
        ),
      ),
      body:SmartRefresher(
      enablePullDown: true,
    enablePullUp: true,
    header: const WaterDropHeader(),
    controller: _refreshController,
    onRefresh: _onRefresh,
    onLoading: _onLoading,
    child:ListView(
      children:[

          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child:  Text(widget.tod["Hospital_name"].toString(), style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                    color:Color( 0xFFDB5461)
                ),),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,
                  height: 240.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFDB5461),
                  ),
                  child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: GoogleMapsWidget(
                            apiKey: "AIzaSyCaG0u5EfOCiQTSWQyEia2HBbhl3wxcB-g",
                            sourceLatLng: LatLng(langf,longf),
                            destinationLatLng: LatLng(hosplang, hosplong),


                            routeWidth: 2,
                            sourceMarkerIconInfo: const MarkerIconInfo(
                            assetPath:"assets/images/hospital.png",
                              assetMarkerSize: Size.square(50),
                            ),
                            destinationMarkerIconInfo: const MarkerIconInfo(
                            assetPath: "assets/images/home.png",
                              assetMarkerSize: Size.square(50),
                            ),
                            driverMarkerIconInfo: const MarkerIconInfo(
                            assetPath: "assets/images/car.png",
                            assetMarkerSize: Size.square(20),
                            ),
                            // mock stream
                            driverCoordinatesStream: Stream.periodic(
                            Duration(milliseconds: 1000),
                            (i) => LatLng(
                              langf ,
                              longf ,
                            ),
                            ),
                            sourceName: widget.tod["Hospital_name"].toString(),
                            driverName: widget.tod["Personnel"].toString(),
                            onTapDriverMarker: (currentLocation) {
                            print("Driver is currently at $currentLocation");
                            },
                            totalTimeCallback: (time) => setState(() {
                              times=time!;
                            }),
                            totalDistanceCallback: (distance) => setState(() {
                              distances=distance!;
                            })
                            ),
                        ),
                      ))),
                      const Padding(
                      padding: EdgeInsets.all(2.0),),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,
                  height: 170.0,
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
                              widget.tod["Customer_Name"].toString(),
                              style: const TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 20.0,
                                color: Color(0xFFDB5461),
                              ),
                            ),
                            Text(
                              times+" away",
                              style: const TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: Color(0xFFDB5461),
                              ),
                            ),
                            Text(
                              "Distance:"+distances,
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFDB5461),
                              ),
                            ),


                            Text(
                             "Time:"+ widget.tod["Pick_Up_Time"].toString(),
                              style: const TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 12.0,
                                color: Color(0xFFDB5461),
                              ),
                            ),
                            Text(
                              "Date:"+widget.tod["Request_DateTime"].toString(),
                              style: const TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 12.0,
                                color: Color(0xFFDB5461),
                              ),
                            ),

                            ElevatedButton(
                              onPressed: () async {
                                FlutterPhoneDirectCaller.callNumber(widget.tod["Customer_Number"]);
                              },
                              child: Text(
                                  "Call"
                              ),style: ElevatedButton.styleFrom(
                                primary: Color(0xFFDB5461)),
                            ),

                          ])),
                    ),
                  ),
              ),


              const Padding(padding: EdgeInsets.all(3.0)),
    ListView.builder(
    shrinkWrap: true,
    itemCount: 1,
    itemBuilder: (BuildContext context, int index) {
      var ongoing;
      if(widget.tod["Status"]=="Ongoing"){
        ongoing=  ElevatedButton(

          onPressed: () {
            var bol=tripupdate(widget.tod["Request_id"].toString(),"Started");
            if(bol==true){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   MapPage(long: widget.long, lang:widget.lang, tod:widget.tod),
                ),
              );

            }

          },
          child: Text(
              status

          ),style: ElevatedButton.styleFrom(
             primary: Color(0xFFDB5461)),

          );
      }
      else if(widget.tod["Status"]=="Started"){
        ongoing=ElevatedButton(

          onPressed: () {
            var bol=tripupdate(widget.tod["Request_id"].toString(),"Arrived");
            if(bol==true){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   MapPage(long: widget.long, lang:widget.lang,tod:widget.tod),
                ),
              );

            }
          },
          child: Text(
              status

          ),style: ElevatedButton.styleFrom(
             primary: Color(0xFFDB5461)),

        );

      }
      else if(widget.tod["Status"]=="Arrived"){
        ongoing=ElevatedButton(

          onPressed: () {
            var bol=tripupdate(widget.tod["Request_id"].toString(),"Trip");
            if(bol==true){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   MapPage(long: widget.long, lang:widget.lang, tod:widget.tod),
                ),
              );

            }
          },
          child: Text(
              status

          ),style: ElevatedButton.styleFrom(
            primary:Color(0xFFDB5461)),

        );

      }
      else if(widget.tod["Status"]=="Trip"){
        ongoing=ElevatedButton(

          onPressed: () {
            var bol=tripupdate(widget.tod["Request_id"].toString(),"Completed");
            if(bol==true){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>   MapPage(long:widget.long, lang:widget.lang, tod:widget.tod),
                ),
              );

            }
          },
          child: Text(
              status

          ),style: ElevatedButton.styleFrom(
             primary:Color(0xFFDB5461),fixedSize: Size(200,50)),

        );

      }
      else if(widget.tod["Status"]=="Completed"){
        String rate=widget.tod["Rating"].toString();

        ongoing= ElevatedButton(

          onPressed: () {  },
          child: Column(
            children:  [
              const Icon(Icons.star),
              const Text(
                  "RATING"

              ),
              Text(
                  rate

              )
            ],
          ),style: ElevatedButton.styleFrom(

           primary: Color(0xFFDB5461),fixedSize: Size(300,50)),

        );



      }



      return Container(
        width: 300,
        child:ongoing
      );
    })

            ],
          ),






])
      )
    );
  }


  Future<bool> tripupdate(id,statuse) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests/$id");
    var bol=false;

    try {
      if(statuse=="Started"){

        final time=DateFormat("EEEEE MMM dd yyyy HH:mm:ss a").format(DateTime.now());
        await ref.update({
          "Status": statuse,
          "Trip":time
        });
        setState(() {
          status="Arrived";
        });
      }
      else if(statuse=="Arrived"){

        final time=DateFormat("EEEEE MMM dd yyyy HH:mm:ss a").format(DateTime.now());
        await ref.update({
          "Status": statuse,
          "Pick_Up_Arrival":time
        });
        setState(() {
          status="Start Trip";
        });
      }
      else if(statuse=="Trip"){
        final time=DateFormat("EEEEE MMM dd yyyy HH:mm:ss a").format(DateTime.now());
        await ref.update({
          "Status": statuse,
          "Trip_Started":time
        });
        setState(() {
          status="End Trip";
        });
      }
      else if(statuse=="Completed"){
        final time=DateFormat("EEEEE MMM dd yyyy HH:mm:ss a").format(DateTime.now());
        await ref.update({
          "Status": statuse,
          "Arrival":time
        });
        setState(() {
          status="Completed";
        });
      }

      bol=true;



    } on Exception catch (e, s) {
      print(s);
    }
    return bol;

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
