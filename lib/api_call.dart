
import 'dart:convert';
import 'package:http/http.dart' as http;

class CallAPi{

  final String _firebaseUrl="https://fcm.googleapis.com/";
  final String serverKey="AAAAbWqTXQw:APA91bFvx12TS2kZOFANzdiPEyjkKQY9YhCxUJavcU6ZKYC0k3Rq9oGg2XKhRQl_8psEAKFzyJOrPRiCDPj31rMfYXz7tIYRiF4VICo1R6eX9e9iJRoW3m2sidqw28FH1JfPZxT3LV5q";

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