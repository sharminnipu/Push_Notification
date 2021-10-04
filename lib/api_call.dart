
import 'dart:convert';
import 'package:http/http.dart' as http;

class CallAPi{

  final String _firebaseUrl="https://fcm.googleapis.com/";
  final String serverKey="YOUR SERVER KEY";


  postPushNotification(data,apiUrl) async {



    var fullUrl=_firebaseUrl+apiUrl;
    var url = Uri.parse('$fullUrl');
    return await http.post(url,
        body:jsonEncode(data),
        headers:firebaseHeader());

  }


  firebaseHeader() =>{
    "Content-Type": "application/json",
    "Authorization":"key=${serverKey}",

  };
}