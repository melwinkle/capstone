import 'dart:async';

import 'dart:io';


import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
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
    Placemark place = placemarks[0];
    Address = '${place.street},${place.name},${place.country}';
    FullAddress='${place.street}, ${place.subLocality}, ${place.subLocality}, ${place
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

    Query query = ref.orderByChild("Customer_uid").equalTo(userid);

    DataSnapshot event = await query.get();

    return event.value;
  }


  Future<bool> payb(username,cmail,acc) async {
    var bool=false;
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
      bool=true;
      //you can send some data from the response to an API or use webhook to record the payment on a database
      _showMessage('Payment was successful!!!');
    }
    else {
      //the payment wasn't successsful or the user cancelled the payment
      _showMessage('Payment Failed!!!');
    }

    return bool;
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
  final plugin = PaystackPlugin();

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

    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      bottomNavigationBar:  Container(
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
      body:SmartRefresher(
      enablePullDown: false,
      enablePullUp: false,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView(
      children:[
        Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(

          height: 594.0,
          child: Column(
            children: <Widget>[

// Group: Group 32
              const Padding(padding: EdgeInsets.only(top:60.0)),
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
                                          onPressed: ()  {

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
                                                    lst[index]["Hospital_name"],
                                                    style: const TextStyle(
                                                      color: Color(0xFFDB5461),
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
                                                    style: const TextStyle(
                                                      color: Color(0xFFDB5461),
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

                                );

                              });
                        }
                        return CircularProgressIndicator();
                      })
              ),



            ],
          ),
        ),
      ),
      ])
    )
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


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color(0xFFDB5461)
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: ListView(
    children:[
      Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(

          height: 580.0,
          child: Column(
            children: <Widget>[


              Align(
                alignment: Alignment.center,
                child: Text( widget.todo["Hospital_name"],
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 20.0,
                    color: Color(0xFFDB5461),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Hospital will approve soon!',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 15.0,
                    color: Color(0xFFDB5461),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),


              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 350.0,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                          child:  const Text("Pick Up Time", style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color:Color( 0xFFDB5461)
                          ),),
                        ),
                        TextFormField(
                            initialValue: widget.todo["Pick_Up_Time"].toString(),
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
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                          child:  const Text("Request DateTime", style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color:Color( 0xFFDB5461)
                          ),),
                        ),
                        TextFormField(
                            initialValue: widget.todo["Request_DateTime"].toString(),
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

                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                          child:  const Text("Reason", style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color:Color( 0xFFDB5461)
                          ),),
                        ),
                        TextFormField(
                            initialValue: widget.todo["Reason"].toString(),
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
                                  MaterialStateProperty.all(Color(0xFFDB5461)),
                                ),
                              )),
                        )
                      ]),
                    ),
                  )),



            ],
          ),
        ),
      ),
    ])
    );
  }


  void _cancel(id,acc,username,email) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("requests/$id");


    try{

        await ref.update({
          "Status": "Cancel",
          });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  MyRequestPage()
          ),
        );

    }on Exception catch (e, s) {
      print(s);
    }

  }

}

class ConfirmAPage extends StatefulWidget {


  ConfirmAPage({Key? key, required this.todo, required this.locat}) : super(key: key);

  final todo;

  final locat;
  @override
  ConfirmA createState() {
    return  ConfirmA();
  }
}
class ConfirmA extends State<ConfirmAPage> {





  var gl;

  String publicKeyTest =
      'pk_test_ee1a5a462b6bc7c438af874774e763febc528369';
  final plugin = PaystackPlugin();
  String paym='';

  //used to generate a unique reference for payment
  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }
  pay(username,acc,cmail) async {
    final requestid=widget.todo["Request_id"].toString();
    DatabaseReference request = FirebaseDatabase.instance.ref("requests/$requestid");
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
      try {
        await request.update({
          "Payment_Status":"Paid"
        }

        );
        setState(() {
          paym="Paid";
        });

      }on Exception catch (e, s) {
        print(s);
      }

    }

  }

getpay(){
  final rid=widget.todo["Payment_Status"];
  final user=widget.todo["Customer_Name"];
  final mail=widget.todo["Customer_Email"];
  final acc=widget.todo["Account"];

  if(rid=="Paid"){
    setState(() {
      paym="Paid";
    });
    gl=Text(paym,style: TextStyle(
        color:Color(0xFFDB5461),
    ),);
  }else{
    setState(() {
      paym="Pay";
    });
    gl=ElevatedButton(
        onPressed: (){
          pay(user,acc,mail);
        },
        child:Text(paym,style: TextStyle(color:Color(0xFFFFFFFF)),)
        ,
        style:ElevatedButton.styleFrom(
            padding:const EdgeInsets.all(10) ,
            primary: const Color(0xFFDB5461),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))
    );
  }

}




  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void initState() {
    plugin.initialize(publicKey: publicKeyTest);
    getpay();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final long=widget.locat[0];
    final longf=long;
    final lang=widget.locat[1];
    final langf=lang;


    final hospl=widget.todo["Hospital_location"].toString().split(",");
    final hosplang=double.parse(hospl[0]);
    final hosplong=double.parse(hospl[1]);
    double dis=calculateDistance(longf, langf, hosplang, hosplong);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:Align(
            alignment: Alignment.topRight,
            child: gl
        ),
        elevation: 0,
        toolbarHeight: 50,
        iconTheme: const IconThemeData(
            color: Color(0xFFDB5461)
        ),
      ),

        backgroundColor: const Color(0xFFFFFFFF),
      body:
      ListView(
    children:[
      Align(
        alignment: Alignment(0.01, 0.09),
        child: SizedBox(

          height: 520.0,
          child: Column(
            children: <Widget>[

              Align(
                alignment: Alignment.center,
                child:  Text(widget.todo["Hospital_name"], style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                    color:Color( 0xFFDB5461)
                ),),
              ),

              const Align(
                alignment: Alignment.center,
                child: Text(
                  'EMS are on their way!',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 15.0,
                    color: Color(0xFFDB5461),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),


              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,

                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                          child: Column(
                              children: [

                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                                  child:  const Text("Pick Up Time", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color:Color( 0xFFDB5461)
                                  ),),
                                ),
                                TextFormField(
                                    initialValue: widget.todo["Pick_Up_Time"].toString(),
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
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                                  child:  const Text("Request DateTime", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color:Color( 0xFFDB5461)
                                  ),),
                                ),
                                TextFormField(
                                    initialValue: widget.todo["Request_DateTime"].toString(),
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

                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                                  child:  const Text("Reason", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color:Color( 0xFFDB5461)
                                  ),),
                                ),
                                TextFormField(
                                    initialValue: widget.todo["Reason"].toString(),
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
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                                  child:  const Text("Distance", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color:Color( 0xFFDB5461)
                                  ),),
                                ),
                                TextFormField(
                                    initialValue: dis.toStringAsFixed(2) + " km away".toString(),
                                    style: const TextStyle(
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

                                Padding(padding: EdgeInsets.only(top:20),),
                                Container(
                                    width: 300,
                                    height: 60,
                                    
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Color(0xFFFFFFFF),
                                        border:Border.all(
                                            color: Color(0xFFDB5461),
                                            width: 1.0,
                                            style: BorderStyle.solid

                                        )

                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.only(top:5.0,bottom:10.0,left:10.0,right:10.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            FlutterPhoneDirectCaller.callNumber(widget.todo["Personnel_number"].toString());
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [

                                              Text(
                                                widget.todo["Personnel"].toString(),
                                                style: const TextStyle(
                                                  color: Color(0xFFDB5461),
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Icon(Icons.phone,color:Color(0xFFDB5461),size: 32.0,)
                                            ],
                                          ),style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                          elevation: 0
                                        ),

                                        ), )),
                            Container(
                              width: 200.0,
                              height: 50.0,
                              margin: EdgeInsets.only(top:15,bottom:8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  MapTrackPage(long: longf, lang:langf, tod:widget.todo),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'TRACK AMBULANCE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Color(0xFFDB5461)),
                                ),
                              ),
                            )
                          ])),
                    ),
                  )),






            ],
          ),
        ),
      ),
    ])
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

          height: 812.0,
          child: Column(
            children: <Widget>[



              Text(
                widget.todo["Hospital_name"].toString(),
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 20.0,
                  color: const Color(0xFFDB5461),
                ),
              ),




              Container(
                  alignment: Alignment(-0.78, -0.04),
                  width: 300.0,

                  child: SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                                  child:  const Text("Pick Up Time", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color:Color( 0xFFDB5461)
                                  ),),
                                ),
                                TextFormField(
                                    initialValue: widget.todo["Pick_Up_Time"].toString(),
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
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                                  child:  const Text("Personnel", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color:Color( 0xFFDB5461)
                                  ),),
                                ),
                                TextFormField(
                                    initialValue: widget.todo["Personnel"].toString(),
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
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                                  child:  const Text("Request DateTime", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color:Color( 0xFFDB5461)
                                  ),),
                                ),
                                TextFormField(
                                    initialValue: widget.todo["Request_DateTime"].toString(),
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
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                                  child:  const Text("Reason", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color:Color( 0xFFDB5461)
                                  ),),
                                ),
                                TextFormField(
                                    initialValue: widget.todo["Reason"].toString(),
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
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:5.0),
                                  child:  const Text("Total Trip Time", style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color:Color( 0xFFDB5461)
                                  ),),
                                ),
                                TextFormField(
                                    initialValue: "20 minutes",
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
                                Padding(padding: EdgeInsets.only( top: 10.0)),
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child:Text(
                                    "Rate the trip",
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontSize: 12.0,
                                      color: Color(0xFFDB5461),
                                    ),),
                                ),
                                Container(
                                    width: 300,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Color(0xFFFFFFFF),
                                      border: Border.all(
                                          color: Color(0xFFDB5461),
                                          width: 1.0,
                                          style: BorderStyle.solid

                                      )

                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: RatingBar.builder(
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
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

                          ]),
                        ),
                    ),
                  )),




              // Container(
              //   child: ElevatedButton(
              //     onPressed: () {
              //         payb(widget.todo['Username'], widget.todo['Email'],widget.todo["Account"]);
              //     },
              //     child: Text('Pay'),
              //     style: ButtonStyle(
              //       backgroundColor:
              //       MaterialStateProperty.all(Color(0xFFA34747)),
              //     ),
              //   ),
              // ),


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
class MapTrackPage extends StatefulWidget {


  const MapTrackPage({Key? key,required this.lang, required this.long, this.tod}) : super(key: key);

  final lang;
  final long;
  final tod;


  @override
  MapTrack createState() {
    return MapTrack();
  }
}

class MapTrack extends State<MapTrackPage>{

  late GoogleMapController mapController;

  // final LatLng _center = LatLng(todo,lons);



  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  var status;
  String stat='';

@override
  void initState() {
    // TODO: implement initState
  setState(() {
    stat=widget.tod["Status"].toString();
    status=Column(
      children: [
        Row(
          children: const [
            Icon(Icons.car_repair,
                size: 24, color: Colors.blueGrey),


            Text("EMS yet to leave hospital",style: TextStyle(
                fontSize: 10.0,
                color:Color( 0xFFDB5461),
                fontWeight: FontWeight.w500
            ),),

          ],),
        Row(
          children: const [
            Icon(Icons.car_repair,
                size: 24, color: Colors.blueGrey),


            Text("EMS has left the hospital",style: TextStyle(
                fontSize: 10.0,
                color:Color( 0xFFDB5461),
                fontWeight: FontWeight.w500
            ),),

          ],),
        Row(
          children: const [
            Icon(Icons.car_repair,
                size: 24, color: Colors.blueGrey),


            Text("EMS is arrving soon",style: TextStyle(
                fontSize: 10.0,
                color:Color( 0xFFDB5461),
                fontWeight: FontWeight.w500
            ),),


          ],),
        Row(
          children: const [
            Icon(Icons.car_repair,
                size: 24, color: Colors.blueGrey),


            Text("EMS has arrived at your location",style: TextStyle(
                fontSize: 10.0,
                color:Color( 0xFFDB5461),
                fontWeight: FontWeight.w500
            ),),


          ],),
        Row(
          children: const [
            Icon(Icons.car_repair,
                size: 24, color: Colors.blueGrey),


            Text("EMS has started trip to hospital",style: TextStyle(
                fontSize: 10.0,
                color:Color( 0xFFDB5461),
                fontWeight: FontWeight.w500
            ),),


          ],),
        Row(
          children: const [
            Icon(Icons.car_repair,
                size: 24, color: Colors.blueGrey),


            Text("EMS has ended trip",style: TextStyle(
                fontSize: 10.0,
                color:Color( 0xFFDB5461),
                fontWeight: FontWeight.w500
            ),),


          ],),

      ],
    );
  });

super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final longf=widget.long;
    final langf=widget.lang;
    final LatLng _center = LatLng(longf,langf);


    final hospl=widget.tod["Hospital_location"].toString().split(",");
    final hosplang=double.parse(hospl[0]);
    final hosplong=double.parse(hospl[1]);

    return  Scaffold(
      backgroundColor: const Color(0xFFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
            color: Color(0xFFDB5461)
        ),
      ),
      body:ListView(
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
                  alignment: Alignment.topLeft,
                  width: 300.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color:  Color(0xFFDB5461),


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
                            sourceName: widget.tod["Hospital_name"].toString(),
                            driverName: widget.tod["Personnel"].toString(),
                            onTapDriverMarker: (currentLocation) {
                            print("Driver is currently at $currentLocation");
                            },
                            totalTimeCallback: (time) => print(time),
                            totalDistanceCallback: (distance) => print(distance),
                            ),
                        ),
                      ))),
                      const Padding(
                      padding: EdgeInsets.all(5.0),),
    ListView.builder(
    shrinkWrap: true,
    itemCount: 1,
    itemBuilder: (BuildContext context, int index) {

      if(stat=="Ongoing"){

          status=Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS yet to leave hospital",style: TextStyle(
                      fontSize: 15.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.blueGrey),


                  Text("EMS has left the hospital",style: TextStyle(
                      fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w300
                  ),),

                ],),

              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.blueGrey),


                  Text("EMS has arrived at your location",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.blueGrey),


                  Text("EMS has started trip to hospital",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.blueGrey),


                  Text("EMS has ended trip",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w300
                  ),),


                ],),

            ],
          );

      }
      else if(stat=="Started"){


          status=Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.green),


                  Text("EMS yet to leave hospital",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has left the hospital",style: TextStyle(
                       fontSize: 15.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w500
                  ),),

                ],),

              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.blueGrey),


                  Text("EMS has arrived at your location",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.blueGrey),


                  Text("EMS has started trip to hospital",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.blueGrey),


                  Text("EMS has ended trip",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w300
                  ),),


                ],),

            ],
          );

      }
      else if(stat=="Arrived"){


          status=Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.green),


                  Text("EMS yet to leave hospital",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w500
                  ),),

                ],),
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.green),


                  Text("EMS has left the hospital",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w500
                  ),),

                ],),

              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 32, color: Colors.green),


                  Text("EMS has arrived at your location",style: TextStyle(
                       fontSize: 15.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w500
                  ),),


                ],),
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.blueGrey),


                  Text("EMS has started trip to hospital",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w300
                  ),),


                ],),
              Row(
                children: const [
                  Icon(Icons.car_repair,
                      size: 24, color: Colors.blueGrey),


                  Text("EMS has ended trip",style: TextStyle(
                       fontSize: 10.0,
                      color:Color( 0xFFDB5461),
                      fontWeight: FontWeight.w300
                  ),),


                ],),

            ],
          );


      }
      else if(stat=="Trip"){


            status=Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.car_repair,
                        size: 24, color: Colors.green),


                    Text("EMS yet to leave hospital",style: TextStyle(
                        fontSize: 10.0,
                        color:Color( 0xFFDB5461),
                        fontWeight: FontWeight.w500
                    ),),

                  ],),
                Row(
                  children: const [
                    Icon(Icons.car_repair,
                        size: 24, color: Colors.green),


                    Text("EMS has left the hospital",style: TextStyle(
                        fontSize: 10.0,
                        color:Color( 0xFFDB5461),
                        fontWeight: FontWeight.w500
                    ),),

                  ],),
                Row(
                  children: const [
                    Icon(Icons.car_repair,
                        size: 24, color: Colors.green),


                    Text("EMS is arrving soon",style: TextStyle(
                        fontSize: 10.0,
                        color:Color( 0xFFDB5461),
                        fontWeight: FontWeight.w500
                    ),),


                  ],),
                Row(
                  children: const [
                    Icon(Icons.car_repair,
                        size: 24, color: Colors.green),


                    Text("EMS has arrived at your location",style: TextStyle(
                         fontSize: 10.0,
                        color:Color( 0xFFDB5461),
                        fontWeight: FontWeight.w500
                    ),),


                  ],),
                Row(
                  children: const [
                    Icon(Icons.car_repair,
                        size: 32, color: Colors.green),


                    Text("EMS has started trip to hospital",style: TextStyle(
                        fontSize: 15.0,
                        color:Color( 0xFFDB5461),
                        fontWeight: FontWeight.w500
                    ),),


                  ],),
                Row(
                  children: const [
                    Icon(Icons.car_repair,
                        size: 24, color: Colors.blueGrey),


                    Text("EMS has ended trip",style: TextStyle(
                        fontSize: 10.0,
                        color:Color( 0xFFDB5461),
                        fontWeight: FontWeight.w500
                    ),),


                  ],),

              ],
            );
      }
      else if(stat=="Completed"){


              status=Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.car_repair,
                          size: 24, color: Colors.green),


                      Text("EMS yet to leave hospital",style: TextStyle(
                          fontSize: 10.0,
                          color:Color( 0xFFDB5461),
                          fontWeight: FontWeight.w500
                      ),),

                    ],),
                  Row(
                    children: const [
                      Icon(Icons.car_repair,
                          size: 24, color: Colors.green),


                      Text("EMS has left the hospital",style: TextStyle(
                          fontSize: 10.0,
                          color:Color( 0xFFDB5461),
                          fontWeight: FontWeight.w500
                      ),),

                    ],),
                  Row(
                    children: const [
                      Icon(Icons.car_repair,
                          size: 24, color: Colors.blueGrey),


                      Text("EMS is arrving soon",style: TextStyle(
                          fontSize: 10.0,
                          color:Color( 0xFFDB5461),
                          fontWeight: FontWeight.w500
                      ),),


                    ],),
                  Row(
                    children: const [
                      Icon(Icons.car_repair,
                          size: 24, color: Colors.green),


                      Text("EMS has arrived at your location",style: TextStyle(
                          fontSize: 10.0,
                          color:Color( 0xFFDB5461),
                          fontWeight: FontWeight.w500
                      ),),


                    ],),
                  Row(
                    children: const [
                      Icon(Icons.car_repair,
                          size: 24, color: Colors.green),


                      Text("EMS has started trip to hospital",style: TextStyle(
                          fontSize: 10.0,
                          color:Color( 0xFFDB5461),
                          fontWeight: FontWeight.w500
                      ),),


                    ],),
                  Row(
                    children: const [
                      Icon(Icons.car_repair,
                          size: 32, color: Colors.green),


                      Text("EMS has ended trip",style: TextStyle(
                           fontSize: 15.0,
                          color:Color( 0xFFDB5461),
                          fontWeight: FontWeight.w500
                      ),),


                    ],),

                ],
              );

      }


      return Container(
        child:
        status
      );
    })

            ],
          ),



])




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
width: 310,
          height: 812.0,
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Request Cancelled',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 20.0,
                    color: Color(0xFFDB5461),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:10.0),
                child:  const Text("Pick Up Time", style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color:Color( 0xFFDB5461)
                ),),
              ),
              TextFormField(
                initialValue: todo["Pick_Up_Time"].toString(),
                  style: TextStyle(
                      fontSize: 12.0
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: const Color(0xFFFFF1F4),
                      contentPadding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ))),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:10.0),
                child:  const Text("Request DateTime", style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color:Color( 0xFFDB5461)
                ),),
              ),
              TextFormField(
                  initialValue: todo["Request_DateTime"].toString(),
                  style: TextStyle(
                      fontSize: 12.0
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: const Color(0xFFFFF1F4),
                      contentPadding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ))),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(bottom: 5.0,left:5.0,right:5.0,top:10.0),
                child:  const Text("Notes", style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color:Color( 0xFFDB5461)
                ),),
              ),
              TextFormField(
                  initialValue: todo["Reason"].toString(),
                  style: TextStyle(
                    fontSize: 12.0
                  ),
                  readOnly: true,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: const Color(0xFFFFF1F4),
                      contentPadding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ))),




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