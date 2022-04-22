import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notification_flutter/second_page.dart';
import 'package:push_notification_flutter/service.dart';
import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';


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
        channelKey: 'call_channel',
        title: '${message.data['title']}',
        body: '${message.data['body']}',
        largeIcon: "https://www.thetrendspotter.net/wp-content/uploads/2016/03/Best-Beard-Styles-men.jpg",
        locked: true,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: true,
        groupKey:'category_tests' ,
        category: NotificationCategory.Call,
        displayOnForeground: true,

      ),
      actionButtons: [
        NotificationActionButton(
          key: 'accept',
          label: 'Accept',
          color:Colors.green
        ),
        NotificationActionButton(
          isDangerousOption: true,
          autoDismissible: true,
          key: 'reject',
          label: 'Reject',
        ),
      ],
    /*  actionButtons: [
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
      ]  */)  ;



  //AwesomeNotifications().createNotificationFromJsonData(message.data);
}


/*Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');

  if(
  !AwesomeStringUtils.isNullOrEmpty(message.data['title'], considerWhiteSpaceAsEmpty: true) ||
      !AwesomeStringUtils.isNullOrEmpty(message.data['body'], considerWhiteSpaceAsEmpty: true)
  ){
    print('message also contained a notification: ${message.data}');

    String imageUrl;
    imageUrl ??= "https://www.thetrendspotter.net/wp-content/uploads/2016/03/Best-Beard-Styles-men.jpg";
    imageUrl ??= message.notification.apple?.imageUrl;

    Map<String, dynamic> notificationAdapter = {
      NOTIFICATION_CHANNEL_KEY: 'call_channel',
      NOTIFICATION_ID:
      message.data[NOTIFICATION_CONTENT][NOTIFICATION_ID] ??
          message.messageId ??
               1233,
        //  Random().nextInt(2147483647),
      NOTIFICATION_TITLE:
      message.data[NOTIFICATION_CONTENT][NOTIFICATION_TITLE] ??
          message.data['title'],
      NOTIFICATION_BODY:
      message.data[NOTIFICATION_CONTENT][NOTIFICATION_BODY] ??
          message.data['body'] ,
      NOTIFICATION_LAYOUT:
      AwesomeStringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
      NOTIFICATION_BIG_PICTURE: imageUrl
    };

    AwesomeNotifications().createNotificationFromJsonData(notificationAdapter);
  }
  else {
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  }
}  */


 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AwesomeNotifications().initialize(
      'resource://drawable/app_center_logo',
      [
      /*  NotificationChannel(
          channelKey: 'key1',
          channelName: 'Proto Coders Points',
          channelDescription: 'Notification example',
          defaultColor: Color(0xFF9050DD),
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          channelShowBadge: true,
          vibrationPattern: highVibrationPattern,
          importance: NotificationImportance.High,

        )  */

        NotificationChannel(
            channelGroupKey: 'category_tests',
            channelKey: 'call_channel',
            channelName: 'Calls Channel',
            channelDescription: 'Channel with call ringtone',
            defaultColor: Color(0xFF9D50DD),
            importance: NotificationImportance.Max,
            criticalAlerts: true,
            ledColor: Colors.white,
            channelShowBadge: true,
            locked: true,),
           // defaultRingtoneType: DefaultRingtoneType.Ringtone),

      ],
      channelGroups: [
      NotificationChannelGroup(channelGroupkey: 'category_tests', channelGroupName: 'Category tests'),
   ],
      );
  runApp(MyApp());
}
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}
// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

void onStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "Updated at ${DateTime.now()}",
      );
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
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

  var receiverTokenFcm="c9Doj8FPRcmpf62LRMK11Y:APA91bH3AjiXEyjQ-WIlCDZpZpsgfr1ADTcvrR6bja-N5iragBtlT8KLQUdnN1THXfpAfnen10QvD-TbPru-irZK-fpYFiCiU5SQN1zXPduhqm85IyzZ9LjQIIMgemfmTWu_sX4oOw32";
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
          (receivedNotification) {
        if (receivedNotification.buttonKeyPressed == "accept") {
          print("answer is here");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SecondPage()));
        } else if (receivedNotification.buttonKeyPressed == "reject") {
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
  String text = "Stop Service";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:Column
        (
          children: [

          ElevatedButton(
             onPressed: () async{
           await _databaseService.sendPushNotification(receiverTokenFcm);
            //notify();
          },
          child: Icon(Icons.circle_notifications),
        ),

            StreamBuilder<Map<String, dynamic>>(
              stream: FlutterBackgroundService().on('update'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data;
                String device = data["device"];
                DateTime date = DateTime.tryParse(data["current_date"]);
                return Column(
                  children: [
                    Text(device ?? 'Unknown'),
                    Text(date.toString()),
                  ],
                );
              },
            ),
            ElevatedButton(
              child: const Text("Foreground Mode"),
              onPressed: () {
                FlutterBackgroundService().invoke("setAsForeground");
              },
            ),
            ElevatedButton(
              child: const Text("Background Mode"),
              onPressed: () {
                FlutterBackgroundService().invoke("setAsBackground");
              },
            ),
            ElevatedButton(
              child: Text(text),
              onPressed: () async {
                final service = FlutterBackgroundService();
                var isRunning = await service.isRunning();
                if (isRunning) {
                  service.invoke("stopService");
                } else {
                  service.startService();
                }

                if (!isRunning) {
                  text = 'Stop Service';
                } else {
                  text = 'Start Service';
                }
                setState(() {});
              },
            ),
    ])
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
       // autoCancel: true

      ),
      NotificationActionButton(
        key: 'Answer',
        label: "Answer",
        buttonType: ActionButtonType.Default
      )
    ]);



  }


}
