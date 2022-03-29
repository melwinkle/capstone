import 'dart:async';

import 'dart:io';

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:lamber/pay_button.dart';
import 'map.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  final fb = FirebaseDatabase.instance.ref("requests").orderByChild("Customer_uid");
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


    locat.add(position.latitude);
    locat.add(position.longitude);
    GetAddressFromLatLong(position);

  }
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
      backgroundColor: const Color(0xFFEFDCDC),
      body:SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(

          height: 812.0,
          child: Column(
            children: <Widget>[

// Group: Group 32
              Padding(padding: const EdgeInsets.all(10.0)),
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
                                backloc();
                                if(lst[index]['Status']=="Pending"){
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.orange),
                                  );
                                  ems=ConfirmP(todo: lst[index]);



                                }else if(lst[index]['Status']=="Completed"){
                                  stat=Container(
                                    alignment: const Alignment(1.0, -0.4),
                                    child:
                                    Icon(Icons.shield,
                                        size: 15, color: Colors.green[500]),
                                  );
                                  ems=ConfirmFP(todo: lst[index]);
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
                                  ems=ConfirmAPage(todo: lst[index],locat:locat);
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
                                                      fontSize: 8.0,
                                                      overflow: TextOverflow.ellipsis
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              stat,

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
    ));
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

class ConfirmP extends StatefulWidget {


  const ConfirmP({Key? key,required this.todo}) : super(key: key);

  final todo;


  @override
  ConfirmPage createState() {
    return ConfirmPage();
  }
}
class ConfirmPage extends State<ConfirmP> {
  // In the constructor, require a Todo.
  // ConfirmPage({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  // final todo;


  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];

  int _currentIndex = 1;

  String publicKeyTest =
      'pk_test_ee1a5a462b6bc7c438af874774e763febc528369'; //pass in the public test key obtained from paystack dashboard here

  final plugin = PaystackPlugin();
  final userid=FirebaseAuth.instance.currentUser?.uid;
  final Account='';
  final mail='';
  @override
  void initState() {
    plugin.initialize(publicKey: publicKeyTest);
    super.initState();

  }
  void _showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //used to generate a unique reference for payment
  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }
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
        title: Text(widget.todo["Hospital_name"].toString()),
        backgroundColor: const Color(0xFFA34747),
      ),
      backgroundColor: const Color(0xFFEFDCDC),
      body: ListView(
    children:[Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(

          height: 580.0,
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
                          widget.todo["Hospital_name"].toString(),
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
                          "Pick Up Time:"+widget.todo["Pick_Up_Time"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          "Request:"+widget.todo["Request_DateTime"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),
                        ),
                        Text(
                          widget.todo["Reason"].toString(),
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
                                  _cancel(widget.todo["Request_id"].toString(),widget.todo["Hospital_Account"].toString(),widget.todo["Customer_Name"].toString(),widget.todo["Customer_Email"].toString());

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
    ])
    );
  }


  void _cancel(id,acc,username,email) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests/$id");
    var charge = Charge()
      ..amount = 2*100  //the money should be in kobo hence the need to multiply the value by 100
      ..reference = _getReference()
      ..putCustomField('username',
          username) //to pass extra parameters to be retrieved on the response from Paystack
      ..email = email
      ..currency="GHS"
      ..subAccount=acc;

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    try{
      if(response.status==true){
        await ref.update({
          "Status": "Cancel",
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  MyRequestPage()
          ),
        );
      }else{
        _showMessage('Payment Failed!!!');
      }
    }on Exception catch (e, s) {
      print(s);
    }

  }

}
class ConfirmAPage extends StatelessWidget {


  // In the constructor, require a Todo.
  ConfirmAPage({Key? key, required this.todo, required this.locat}) : super(key: key);

  // Declare a field that holds the Todo.
  final todo;

final locat;



  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];

  int _currentIndex = 1;



  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    final long=locat[0];
    final longf=long;
    final lang=locat[1];
    final langf=lang;


    final hospl=todo["Hospital_location"].toString().split(",");
    final hosplang=double.parse(hospl[0]);
    final hosplong=double.parse(hospl[1]);
    double dis=calculateDistance(longf, langf, hosplang, hosplong);

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
      body:ListView(
    children:[Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(

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
                              dis.toStringAsFixed(2) + " km away",
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            Container(
                              width: 200.0,
                              height: 50.0,
                              margin: EdgeInsets.all(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  MapTrackPage(long: longf, lang:langf, tod:todo),
                                    ),
                                  );
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
    ])
    );
  }


  // Route _track() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => const MapTrackPage(),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       return child;
  //     },
  //   );
  // }

  Route _call() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Phone(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

}




class ConfirmFP extends StatefulWidget {


  const ConfirmFP({Key? key,required this.todo}) : super(key: key);

  final todo;


  @override
  ConfirmFPage createState() {
    return ConfirmFPage();
  }
}
class ConfirmFPage extends State<ConfirmFP> {
  // In the constructor, require a Todo.
  // ConfirmFPage({Key? key, required this.todo}) : super(key: key);

  // Declare a field that holds the Todo.
  // final todo;

  final List<Widget> _children = [
    const MyHomePage(),
    const MyRequestPage(),
    const MyAidPage(),
    const MyProfilePage(),
  ];

  int _currentIndex = 1;

  late final _ratingController;
  late double _rating;

  double _userRating = 3.0;
  int _ratingBarMode = 1;
  double _initialRating = 2.0;

  String publicKeyTest =
      'pk_test_ee1a5a462b6bc7c438af874774e763febc528369'; //pass in the public test key obtained from paystack dashboard here

  final plugin = PaystackPlugin();

  void _showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //used to generate a unique reference for payment
  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }
  @override
  void initState() {
    plugin.initialize(publicKey: publicKeyTest);
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
    super.initState();
  }

  IconData? _selectedIcon;
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
        title: Text(widget.todo["Hospital_name"].toString()),
        backgroundColor: const Color(0xFFA34747),
      ),
      backgroundColor: const Color(0xFFEFDCDC),
      body: Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(

          height: 812.0,
          child: Column(
            children: <Widget>[
              const Spacer(flex: 5),
// Group: Group 32



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
                              widget.todo["Hospital_name"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 20.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              widget.todo["Vehicle_Registration"].toString(),
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
                              widget.todo["Destination"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              widget.todo["Pick_Up_Time"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              widget.todo["Request_DateTime"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              widget.todo["Reason"].toString(),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                            Text(
                              "Total Trip time:20 minutes",
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 15.0,
                                color: const Color(0xFFA34747),
                              ),
                            ),
                      Text(
                          "Personnel:"+widget.todo["Personnel"].toString(),
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15.0,
                            color: const Color(0xFFA34747),
                          ),),
                          ]),
                        )),
                  )),

              Spacer(flex: 10),
              Text(
                "RATE THE TRIP",
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 20.0,
                  color: const Color(0xFFA34747),
                ),),
              Container(
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFFA43247),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          rate(widget.todo["Request_id"],rating);
                          print(rating);
                        },
                      ),


                      )),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                      payb(widget.todo['Username'], widget.todo['Email'],widget.todo["Account"]);
                  },
                  child: Text('Pay'),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xFFA34747)),
                  ),
                ),
              ),
              Spacer(flex: 20),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> rate(id,rating) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests/$id");
    try {
      await ref.update({
        "Rating":rating
      });
    } on Exception catch (e, s) {
      print(s);
    }


  }

  Future<void> payb(username,cmail,acc) async {
    var charge = Charge()
      ..amount = 2*100  //the money should be in kobo hence the need to multiply the value by 100
      ..reference = _getReference()
      ..putCustomField('username',
          username) //to pass extra parameters to be retrieved on the response from Paystack
      ..email = cmail
      ..currency="GHS"
      ..subAccount=acc;

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );


    if (response.status == true) {
      //you can send some data from the response to an API or use webhook to record the payment on a database
      _showMessage('Payment was successful!!!');
    }
    else {
      //the payment wasn't successsful or the user cancelled the payment
      _showMessage('Payment Failed!!!');
    }
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
class MapTrackPage extends StatelessWidget {
  MapTrackPage({Key? key, required this.lang, required this.long, this.tod}) : super(key: key);
final lang;
final long;
final tod;

  late GoogleMapController mapController;

  // final LatLng _center = LatLng(todo,lons);



  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }



  @override
  Widget build(BuildContext context) {
    final longf=long;
    final langf=lang;
    final LatLng _center = LatLng(longf,langf);


    final hospl=tod["Hospital_location"].toString().split(",");
    final hosplang=double.parse(hospl[0]);
    final hosplong=double.parse(hospl[1]);

    return  Scaffold(
      backgroundColor: const Color(0xFFEFDCDC),
      appBar: AppBar(
        title: Text(tod["Hospital_name"].toString()),
        backgroundColor: const Color(0xFFA34747),
      ),
      body:

          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),),
              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 450.0,
                  height: 350.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: GoogleMapsWidget(
                            apiKey: "AIzaSyCaG0u5EfOCiQTSWQyEia2HBbhl3wxcB-g",
                            sourceLatLng: LatLng(hosplang, hosplong),
                            destinationLatLng: LatLng(longf, langf),


                            routeWidth: 2,
                            sourceMarkerIconInfo: MarkerIconInfo(
                            assetPath:"assets/images/hospital.png",
                            ),
                            destinationMarkerIconInfo: MarkerIconInfo(
                            assetPath: "assets/images/home.png",
                            ),
                            driverMarkerIconInfo: MarkerIconInfo(
                            assetPath: "assets/images/car.png",
                            assetMarkerSize: Size.square(125),
                            ),
                            // mock stream
                            driverCoordinatesStream: Stream.periodic(
                            Duration(milliseconds: 1000),
                            (i) => LatLng(
                              hosplang + i / 20000,
                              hosplong - i / 20000,
                            ),
                            ),
                            sourceName: tod["Hospital_name"].toString(),
                            driverName: tod["Personnel"].toString(),
                            onTapDriverMarker: (currentLocation) {
                            print("Driver is currently at $currentLocation");
                            },
                            totalTimeCallback: (time) => print(time),
                            totalDistanceCallback: (distance) => print(distance),
                            ),
                        ),
                      ))),
                      Padding(
                      padding: const EdgeInsets.all(5.0),),
    ListView.builder(
    shrinkWrap: true,
    itemCount: 1,
    itemBuilder: (BuildContext context, int index) {
      var ongoing;
      if(tod["Status"]=="Ongoing"){
        ongoing= Column(
            children: [
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS yet to leave hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has left the hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS is arrving soon",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has arrived at your location",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has started trip to hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has ended trip",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),

            ],
          );
      }
      else if(tod["Status"]=="Started"){
        ongoing=Column(
            children: [
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS yet to leave hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has left the hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS is arrving soon",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has arrived at your location",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has started trip to hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has ended trip",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),

            ],
          );

      }
      else if(tod["Status"]=="Arrived"){
        ongoing=Column(
            children: [
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS yet to leave hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has left the hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS is arrving soon",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has arrived at your location",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has started trip to hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has ended trip",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),

            ],
          );

      }
      else if(tod["Status"]=="Trip"){
        ongoing=Column(
            children: [
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS yet to leave hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has left the hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS is arrving soon",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has arrived at your location",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has started trip to hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS has ended trip",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),


                ],),

            ],
          );

      }
      else if(tod["Status"]=="Completed"){
        ongoing=Column(
            children: [
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS yet to leave hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has left the hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.blueGrey),


                  Text("EMS is arrving soon",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has arrived at your location",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has started trip to hospital",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),


                ],),
              Row(
                children: [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has ended trip",style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFFA34747),
                      fontWeight: FontWeight.w500
                  ),),


                ],),

            ],
          );

      }


      return Container(
        child:ongoing
      );
    })

            ],
          ),








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