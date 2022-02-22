import 'package:firebase_database/firebase_database.dart';

class Users {
  final String uid;
  final String email;
  final String phone;
  final String fname;
  final String lname;

  Users({required this.uid, required this.email, required this.phone, required this.fname, required this.lname});


  factory Users.fromRTDB(Map<String, dynamic> data){
    return Users(
        email: data["Email"] ,
        fname: data["FullName"],
        phone: data["Phone"],
      lname:data["Username"],
      uid: data["uid"],
    );
  }


}