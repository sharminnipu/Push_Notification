import 'dart:convert';

import 'package:push_notification_flutter/api_call.dart';

class DatabaseService{



  Future sendPushNotification(String receiverTokenFcm) async{

    var request = {
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'type': 'COMMENT',
        'callStatus':"1",
        'title':"hello test",
        'body':"today testing msg"
      },
      'to':receiverTokenFcm
     // 'registration_ids': ["$receiverTokenFcm","$senderTokenFcm"]
    };

    print(request);

    final response = await CallAPi().postPushNotification(request,'fcm/send');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
}