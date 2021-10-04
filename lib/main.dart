import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notification_flutter/second_page.dart';
import 'package:push_notification_flutter/service.dart';


//background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
 /* final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  navigatorKey.currentState.pushNamed('/second_page');  */
  print("Handling a background message: ${message.data}");

 // Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage()));

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: '${message.data['title']}',
        body: '${message.data['body']}',
        largeIcon: "https://www.thetrendspotter.net/wp-content/uploads/2016/03/Best-Beard-Styles-men.jpg",
        locked: true,
        autoCancel: true,

      ),
      actionButtons: [
        NotificationActionButton(
            key: 'Decline',
            label: "Decline",
            autoCancel: true

        ),
        NotificationActionButton(
            key: 'Answer',
            label: "Answer",
            buttonType: ActionButtonType.Default
        )
      ]);



  //AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'key1',
          channelName: 'Proto Coders Points',
          channelDescription: 'Notification example',
          defaultColor: Color(0xFF9050DD),
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          importance: NotificationImportance.Max,

        )

      ]
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: key,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DatabaseService _databaseService=DatabaseService();
  FirebaseMessaging _fcm=FirebaseMessaging.instance;

  var receiverTokenFcm="RECEIVER TOKEN";
  var senderTokenFCM="";

@override
  void initState()  {
  super.initState();
  _fcm.getToken().then((value) =>{
    setState(() {

      senderTokenFCM=value;

      print("DEVICE token:$senderTokenFCM");

    })

  });



  AwesomeNotifications().actionStream.listen(
          (receivedNotification){
            if(receivedNotification.buttonKeyPressed=="Answer"){
          print("answer is here");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondPage()));

        }
            print(receivedNotification);
          }
  );

/*  _fcm.configure(
   onLaunch: (Map<String, dynamic>message) async{
     print("Message from fireabse:$message");
    // notify();

   },
    onMessage:(Map<String, dynamic>message) async{
      print("Message from fireabse:$message");
    },
    onResume: (Map<String, dynamic>message) async{
      print("Message from fireabse:$message");
    },

  );
  _fcm.requestNotificationPermissions(
    const IosNotificationSettings(sound: true,alert: true,badge: true));  */

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
           await _databaseService.sendPushNotification(receiverTokenFcm);
            //notify();
          },
          child: Icon(Icons.circle_notifications),
        )
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  void notify() async{
  await  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'key1',
        title: 'this title',
        body: 'this is body',
        largeIcon: "https://www.thetrendspotter.net/wp-content/uploads/2016/03/Best-Beard-Styles-men.jpg",
        locked: true,
      ),
      actionButtons: [
      NotificationActionButton(
        key: 'Decline',
        label: "Decline",
      autoCancel: true

      ),
      NotificationActionButton(
        key: 'Answer',
        label: "Answer",
        buttonType: ActionButtonType.Default
      )
    ]);



  }


}
