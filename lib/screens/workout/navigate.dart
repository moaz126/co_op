import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

import '../../constants/constants.dart';

class NavigateScreen extends StatefulWidget {
  const NavigateScreen({super.key});

  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static LatLng sourceLocation =
      LatLng(profileInfo.lat!.toDouble(), profileInfo.lng!.toDouble());
  static const LatLng destination = LatLng(31.432354, 73.121249);
  List<LatLng> polylineCoordinates = [];
  String? mtoken = " ";
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Set<Marker> _markers = {};
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  /* late File file;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  } */

  Future<BitmapDescriptor> convertImageFileToCustomBitmapDescriptor(
      File imageFile,
      {int size = 70,
      bool addBorder = true,
      Color borderColor = Colors.red,
      double borderSize = 10,
      String title = 'Hello',
      Color titleColor = Colors.red,
      Color titleBackgroundColor = Colors.black}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double radius = size / 2;

    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        Radius.circular(100)));

    /*  clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10),
        Radius.circular(100))); */
    canvas.clipPath(clipPath);

    //paintImage
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    if (addBorder) {
      //draw Border
      paint..color = borderColor;
      paint..style = PaintingStyle.stroke;
      paint..strokeWidth = borderSize;
      canvas.drawCircle(Offset(radius, radius), radius, paint);
    }



    //convert canvas as PNG bytes
    final _image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    File imageFile = File(imagePath);

    Uint8List imageBytes = imageFile.readAsBytesSync();

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("user1").set({
      'token': token,
    });
  }

  void _show(BuildContext ctx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) => Container(
            width: 300,
            height: 250,
            decoration: BoxDecoration(
                color: Colors.white54, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                /*   Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Request()),
                ); */
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: '',
                      placeholder: (context,
                              url) => /* Icon(
                              Icons.person,
                              size: 100,
                            ), */
                          Image.asset(
                        'assets/images/profile.png',
                        height: 70,
                        width: 70,
                        fit: BoxFit.fill,
                      ),
                      errorWidget: (context, url,
                              error) => /* Icon(Icons
                            .person) */
                          Image.asset(
                        'assets/images/profile.png',
                        height: 70,
                        width: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    child: Text('John Wick'),
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: Text('Age  25'),
                  ),
                  SizedBox(
                    height: 0.0,
                  ),
                  InkWell(
                    onTap: () async {
                      print('click');
                      // showNotification();
                      String name = 'user2';
                      String titleText = 'user1 request you';
                      String bodyText = 'Request';

                      if (name != "") {
                        DocumentSnapshot snap = await FirebaseFirestore.instance
                            .collection("UserTokens")
                            .doc(name)
                            .get();

                        String token = snap['token'];
                        print(token);

                        sendPushMessage(token, titleText, bodyText);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 130,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Request',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });

      saveToken(token!);
    });
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);


      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  showNotification() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
            'high_importance_channel', 'High Importance Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: "@mipmap/ic_launcher");
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await FlutterLocalNotificationsPlugin().show(123, "Request",
        "Request accepted successfully", platformChannelSpecifics,
        payload: 'data');
  }

  void getCustomePolyPoints(sourceLt, sourceLo) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Your Google Map Key
      PointLatLng(sourceLt, sourceLo), avoidFerries: true, avoidHighways: true,
      PointLatLng(users.request[0].lat, users.request[0].long),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  void getSecongCustomePolyPoints(sourceLt, sourceLo) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Your Google Map Key
      PointLatLng(sourceLt, sourceLo),
      PointLatLng(users.request[0].lat, users.request[0].long),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  LocationData? currentLocation;
  void getCurrentLocation() async {
    // await selectFile();
    final Uint8List markerIcon = await getBytesFromAsset(
      'assets/images/myloc.png',
      30,
    );
    final Uint8List markerGym = await getBytesFromAsset(
      'assets/images/fitness.png',
      70,
    );

    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) async {
        currentLocation = newLoc;


        setState(() {
          _markers.add(Marker(
              onTap: () {
                polylineCoordinates.clear();
                getCustomePolyPoints(profileInfo.lat, profileInfo.lng);
              },
              markerId: MarkerId('Home'),
              icon: BitmapDescriptor.fromBytes(markerIcon),
              position: LatLng(
                  profileInfo.lat!.toDouble(), profileInfo.lng!.toDouble())));

          _markers.add(Marker(
              onTap: () {
                polylineCoordinates.clear();

                setState(() {});
              },
              markerId: MarkerId('new4'),
              icon: BitmapDescriptor.fromBytes(markerGym),
              position: LatLng(users.request[0].lat, users.request[0].long)));

          _markers.add(Marker(
              onTap: () {
                polylineCoordinates.clear();
                print('click');
                getCustomePolyPoints(users.userData!.lat, users.userData!.long);

                setState(() {});
              },
              markerId: MarkerId('new5'),
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(users.userData!.lat, users.userData!.long)));
        });
      },
    );
  }

  void sendPushMessage(String token, String body, String title) async {
    print('asfgasfdgasgfdsgdfgdfgdfg');
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAFNWJAV4:APA91bE6tho0JZElp7fHQ0bRO3efr7rz8Uu435KkZtnt158FkXRqUu892s2YOKBPL48l-CTJjpzIq6qTOaTYTaZy5uUO29-3NIuMeGQEhUpygGie5uu_-XD6xq73bj30iPPsAsm3CTwG',
        },
        body: jsonEncode(
          <String, dynamic>{
            /*   'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            }, */
            'priority': 'high',
            "to": "_some_fcm_token_",
            'data': <String, dynamic>{
              'title': title,
              'body': body,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "type": "post_like",
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  List<String> categoriesList = ['Sports', 'Jogging', 'Gym'];
  int filter = 0;

  @override
  void initState() {
    // getPolyPoints();
    filter = 0;

    getCurrentLocation();

    getCustomePolyPoints(profileInfo.lat, profileInfo.lng);
    getSecongCustomePolyPoints(users.userData!.lat, users.userData!.long);

    // FirebaseMessaging.instance.subscribeToTopic("Animal");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Gym'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              height: 30,
              width: 70,
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(border: InputBorder.none),
                  hint: Container(
                      width: 50,
                      child: Text(
                        'Filter',
                        style: TextStyle(fontSize: 15),
                      )),
                  elevation: 0,
                  // Initial Value
                  // value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 15,
                    color: Colors.black,
                  ),

                  // Array list of items
                  items: categoriesList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Container(
                          width: 50,
                          child: Text(
                            items,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 10),
                          )),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      print(newValue);
                      if (newValue.toString() == 'Sports') {
                        filter = 1;
                      } else if (newValue.toString() == 'jogging') {
                        filter = 2;
                      } else if (newValue.toString() == 'Gym') {
                        filter = 3;
                      }
                      _markers.clear();
                      getCurrentLocation();

                      // dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),

        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target:
              LatLng(profileInfo.lat!.toDouble(), profileInfo.lng!.toDouble()),
          zoom: 13.5,
        ),
        markers: _markers,

        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: const Color(0xFF7B61FF),
            width: 6,
          ),
        },
      ),
    );
  }
}
