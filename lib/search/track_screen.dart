// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:custom_marker/marker_icon.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:co_op/screens/profile/AddressList.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart' as form;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/custom_dialog.dart';
import 'package:co_op/constants/date_time_picker.dart';
import 'package:co_op/screens/workout/workout_detail_page.dart';
import 'package:co_op/search/search.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import '../bottom_navigation_bar.dart';
import '../constants/constants.dart';
import '../constants/noInternet.dart';
import '../provider/dark_theme_provider.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng sourceLocation = LatLng(31.43873, 73.126844);
  static const LatLng destination = LatLng(31.432354, 73.121249);
  TextEditingController AddressController = TextEditingController();

  List<LatLng> polylineCoordinates = [];
  Set<Marker> _markers = {};
  String? mtoken = " ";
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<int> addresslist = [];
  bool locationCheck = false;
  bool alertLoader = false;
  int selected_address = -1;
  String pickedDate = '';
  String pickedTime = '';
  String pickedTimeApi = '';
  bool buttonLoader = false;
  bool _customTileExpandedSports = true;
  String latitude = '';
  String longitude = '';

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });

      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("user1").set({
      'token': token,
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    /*   print('asfgasfdgasgfdsgdfgdfgdfg');
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAzRcyCeA:APA91bEA4IpoUeQImdVaj43zfcccOr-OJttVcfDv6t8XP1f6HyVsJZ5MF1c_Y8yYKXeIkZx1479d0h4qJdW-vdgxpRmAeCHu1gp-WsBlOB-kHJ3UldAxA1i-7aeUBAhDNaWjqjrLgXRa',
        },
        body: jsonEncode(
          <String, dynamic>{
            /*  'notification': <String, dynamic>{
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
    } */
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

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
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

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    final double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = const TextSpan(
      text: '1',
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.width - tagWidth / 2 - textPainter.width / 2,
            tagWidth / 2 - textPainter.height / 2));

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await getImageFromPath(
        imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<dynamic> _onBackPressed(context) async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Exit',
      desc: 'Do you want to exit app',
      btnCancelOnPress: () {},
      btnCancelText: 'No',
      btnOkText: 'Yes',
      btnOkOnPress: () async {
        SystemNavigator.pop();
      },
    ).show();
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

  List<String> categoriesList = ['Sports', 'Jogging', 'Gym'];
  int filter = 0;

  double _userRating = 0.0;
  double _initialRating = 5.0;

  void _show(BuildContext ctx, index) {
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
                Navigator.pop(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ClipOval(
                    child: CachedNetworkImage(
                      height: 10.h,
                      width: 10.h,
                      fit: BoxFit.cover,
                      imageUrl:
                          'https://becktesting.site/workout-bud/public/storage/user/' +
                              getUsersList[index].image.toString(),
                      placeholder: (context,
                              url) => /* Icon(
                              Icons.person,
                              size: 100,
                            ), */
                          Image.asset(
                        'assets/images/profile.png',
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url,
                              error) => /* Icon(Icons
                            .person) */
                          Image.asset(
                        'assets/images/profile.png',
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(getUsersList[index].userName,
                        style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar(
                          initialRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 24,
                          ratingWidget: RatingWidget(
                              full:
                                  const Icon(Icons.star, color: secondaryColor),
                              half: const Icon(
                                Icons.star_half,
                                color: secondaryColor,
                              ),
                              empty: const Icon(
                                Icons.star_outline,
                                color: secondaryColor,
                              )),
                          onRatingUpdate: (value) {
                            setState(() {
                              _userRating = value;
                            });
                          }),
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          _initialRating != null
                              ? _userRating.toString()
                              : 'Rate it!',
                          style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: Text('Age  ${getUsersList[index].age}',
                        style: TextStyle(color: secondaryColor)),
                  ),
                  const SizedBox(
                    height: 0.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutDetail(
                                    getUsersList[index].id.toString()),
                              ));
                        },
                        child: Container(
                          height: 40,
                          width: 70.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            'See Profile',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      /*  const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final themeChange =
                                    Provider.of<DarkThemeProvider>(context);

                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      height: 52.h,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          height: 15.h,
                                                          width: 15.h,
                                                          fit: BoxFit.fill,
                                                          imageUrl:
                                                              'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                  getUsersList[
                                                                          index]
                                                                      .image
                                                                      .toString(),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            'assets/images/profile.png',
                                                            height: 70,
                                                            width: 70,
                                                            fit: BoxFit.fill,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            'assets/images/profile.png',
                                                            height: 70,
                                                            width: 70,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                    getUsersList[index]
                                                        .userName,
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline3),
                                                SizedBox(height: 10),
                                                Text('Pick your date and time',
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    DatePicker.showDatePicker(context,
                                                        showTitleActions: true,
                                                        minTime: DateTime(
                                                            2022, 10, 24),
                                                        maxTime: DateTime(
                                                            2024, 6, 7),
                                                        theme: const DatePickerTheme(
                                                            headerColor:
                                                                secondaryColor,
                                                            backgroundColor:
                                                                Colors.white,
                                                            itemStyle: TextStyle(
                                                                color:
                                                                    primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                            doneStyle: TextStyle(
                                                                color: Colors.white, fontSize: 16)),
                                                        onChanged: (date) {
                                                      final f = form.DateFormat(
                                                          "dd:mm:yyyy");
                                                      setState(() {
                                                        pickedDate = date
                                                            .toString()
                                                            .split(' ')[0];
                                                      });
                                                      print(
                                                          'change $date in time zone ' +
                                                              date.timeZoneOffset
                                                                  .inHours
                                                                  .toString());
                                                    }, onConfirm: (date) {
                                                      print('confirm $date');
                                                    },
                                                        currentTime: DateTime.now(),
                                                        locale: LocaleType.en);
                                                  },
                                                  child: Container(
                                                    height: 6.h,
                                                    width: 30.w,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: secondaryColor),
                                                    child: Center(
                                                      child: Text(
                                                        pickedDate != ''
                                                            ? pickedDate
                                                            : 'Pick Date',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      DatePicker.showTime12hPicker(
                                                          context,
                                                          showTitleActions:
                                                              true,
                                                          theme: DatePickerTheme(
                                                              headerColor:
                                                                  secondaryColor,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              itemStyle: TextStyle(
                                                                  color:
                                                                      primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                              doneStyle: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      16)),
                                                          onChanged: (time) {
                                                        final f =
                                                            form.DateFormat(
                                                                "hh:mm a");
                                                        final s =
                                                            form.DateFormat(
                                                                "HH:mm");

                                                        f.format(time);
                                                        setState(() {
                                                          pickedTime =
                                                              f.format(time);
                                                        });
                                                        pickedTimeApi =
                                                            s.format(time);
                                                      }, onConfirm: (time) {
                                                        print(pickedTime);
                                                        print('confirm $time');
                                                      },
                                                          currentTime:
                                                              DateTime.now());
                                                    },
                                                    child: Container(
                                                      height: 6.h,
                                                      width: 30.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              secondaryColor),
                                                      child: Center(
                                                        child: Text(
                                                          pickedTime != ''
                                                              ? pickedTime
                                                              : 'Pick Time',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 0, 20, 0),
                                                child: Column(
                                                  children: [
                                                    /*  Container(
                                  width: Get.width,
                                  child: Text(
                                    'Address#${index + 1}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ), */
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'This field is required';
                                                            }
                                                          },
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PlacePicker(
                                                                  apiKey:
                                                                      "AIzaSyBDOMNCVC2eacCxKYuRxIwCz4w-QjV_l5Y",
                                                                  onPlacePicked:
                                                                      (result) {
                                                                    print(result
                                                                        .geometry!
                                                                        .location);
                                                                    final tagName = result
                                                                        .formattedAddress
                                                                        .toString();
                                                                    print(result
                                                                        .formattedAddress);
                                                                    final split =
                                                                        tagName.split(
                                                                            ',');
                                                                    final Map<
                                                                            int,
                                                                            String>
                                                                        values =
                                                                        {
                                                                      for (int i =
                                                                              0;
                                                                          i < split.length;
                                                                          i++)
                                                                        i: split[i]
                                                                    };
                                                                    final value1 =
                                                                        values[
                                                                            0];
                                                                    final value2 =
                                                                        values[
                                                                            1];
                                                                    final value3 =
                                                                        values[
                                                                            2];
                                                                    final value4 =
                                                                        values[
                                                                            3];
                                                                    setState(
                                                                        () {
                                                                      AddressController
                                                                              .text =
                                                                          result
                                                                              .formattedAddress
                                                                              .toString();
                                                                      latitude = result
                                                                          .geometry!
                                                                          .location
                                                                          .lat
                                                                          .toString();
                                                                      longitude = result
                                                                          .geometry!
                                                                          .location
                                                                          .lng
                                                                          .toString();

                                                                      /*   if(value1!=null) {
                                              address.text = value1.toString();
                                            }
                                            if(value2!=null) {
                                              houseNo.text = value2.toString();
                                            }
                                            if(value3!=null) {
                                              city.text = value3.toString();
                                            } */
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  selectInitialPosition:
                                                                      true,
                                                                  autocompleteOnTrailingWhitespace:
                                                                      true,
                                                                  useCurrentLocation:
                                                                      true,
                                                                  initialPosition:
                                                                      LatLng(
                                                                          31.65465,
                                                                          31.35153),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          controller:
                                                              AddressController,
                                                          readOnly: true,
                                                          showCursor: false,
                                                          cursorColor:
                                                              Colors.grey,
                                                          textAlign:
                                                              TextAlign.start,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                            LengthLimitingTextInputFormatter(
                                                                15)
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        5),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              //<-- SEE HERE
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .red),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                            border:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .transparent,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                            prefixIcon: Icon(Icons
                                                                .location_on),
                                                            hintText:
                                                                'Select Meeting Point',
                                                            hintStyle: TextStyle(
                                                                color: themeChange
                                                                        .darkTheme
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .grey,
                                                                fontSize: 2.h,
                                                                fontFamily:
                                                                    'NeueMachina'),
                                                            filled: true,
                                                            fillColor: themeChange
                                                                    .darkTheme
                                                                ? Colors.white38
                                                                : Colors
                                                                    .black12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    /*  SizedBox(
                                                      height: 10,
                                                    ) */
                                                  ],
                                                ),
                                              ),
                                            ),
                                            /*   Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0, right: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text("Select Meeting Point",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2),
                                                  Icon(Icons
                                                      .location_searching_rounded)
                                                ],
                                              ),
                                            ), */
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 6.h,
                                              width: 70.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: primaryColor),
                                              child: InkWell(
                                                onTap: () async {
                                                  Map<String, dynamic> request =
                                                      {
                                                    /*    'requested_by_id':
                                                        profileInfo.id
                                                            .toString(), */
                                                    'requested_to_id':
                                                        getUsersList[index]
                                                            .id
                                                            .toString(),
                                                    'long': longitude,
                                                    'lat': latitude,
                                                    'meet_up_date': pickedDate,
                                                    'meet_up_time':
                                                        pickedTimeApi,
                                                  };
                                                  print(request);
                                                  bool status =
                                                      await DataApiService
                                                          .instance
                                                          .sendRequest(
                                                              request, context);
                                                  Navigator.pop(context);

                                                  /*    String name = 'user1';
                                                  String titleText =
                                                      'Alveria request you';
                                                  String bodyText = 'Request';

                                                  if (name != "") {
                                                    DocumentSnapshot snap =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "UserTokens")
                                                            .doc(name)
                                                            .get();

                                                    String token =
                                                        snap['token'];
                                                    print(token);

                                                    sendPushMessage(token,
                                                        titleText, bodyText);
                                                  } */

                                                  if (status) {
                                                    Fluttertoast.showToast(
                                                        msg: SnackMessage
                                                            .toString(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                    /*  Timer(
                                                        Duration(
                                                            milliseconds: 2),
                                                        () => GlobalSnackBar.show(
                                                            context,
                                                            SnackMessage
                                                                .toString())); */
                                                    /*   AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.SUCCES,
                                                      animType:
                                                          AnimType.BOTTOMSLIDE,
                                                      title: 'Request',
                                                      desc: SnackMessage,
                                                      btnOkOnPress: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ).show(); */
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg: SnackMessage
                                                            .toString(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                    /*  Timer(
                                                        Duration(
                                                            milliseconds: 2),
                                                        () => GlobalSnackBar.show(
                                                            context,
                                                            SnackMessage
                                                                .toString())); */
                                                    /*  AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.error,
                                                      animType:
                                                          AnimType.BOTTOMSLIDE,
                                                      title: 'Request',
                                                      desc: SnackMessage,
                                                      btnOkOnPress: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ).show(); */
                                                  }
                                                },
                                                child: Center(
                                                    child: Text("Send Request",
                                                        style: TextStyle(
                                                            fontSize: 2.1.h,
                                                            color:
                                                                Colors.white))),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              });

                          // customDialog(
                          //     context: context,
                          //     title: 'Request',
                          //     middleText: 'Please select time for request',
                          //     content: Column(
                          //         children:[
                          //           TextButton(
                          //             onPressed: () {
                          //               DatePicker.showDatePicker(context,
                          //                   showTitleActions: true,
                          //                   minTime: DateTime(2022, 10, 24),
                          //                   maxTime: DateTime(2024, 6, 7),
                          //                   theme: const DatePickerTheme(
                          //                       headerColor: secondaryColor,
                          //                       backgroundColor: Colors.blue,
                          //                       itemStyle: TextStyle(
                          //                           color: Colors.white,
                          //                           fontWeight: FontWeight.bold,
                          //                           fontSize: 18),
                          //                       doneStyle:
                          //                       TextStyle(color: Colors.white, fontSize: 16)),
                          //                   onChanged: (date) {
                          //                     setState((){
                          //                       pickedDate = date;
                          //                     });
                          //                     print('change $date in time zone ' +
                          //                         date.timeZoneOffset.inHours.toString());
                          //                   }, onConfirm: (date) {
                          //                     print('confirm $date');
                          //                   }, currentTime: DateTime.now(), locale: LocaleType.en);
                          //             },
                          //             child: Text(
                          //                 pickedDate!=null ? pickedDate.toString():'Pick Date',
                          //                 style: Theme.of(context).textTheme.bodyText2),
                          //           ),
                          //
                          //           Container(
                          //             height: 6.h,
                          //             width: 70.w,
                          //             decoration: BoxDecoration(
                          //                 borderRadius: BorderRadius.circular(20),
                          //                 color: primaryColor),
                          //             child: InkWell(
                          //               onTap: () {
                          //                 Navigator.pop(context);
                          //               },
                          //               child: Center(
                          //                   child: Text("Send Request",
                          //                       style: TextStyle(
                          //                           fontSize: 2.1.h, color: Colors.white))),
                          //             ),
                          //           ),
                          //         ]
                          //     ),
                          //     hasContent: true);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => CustomDialog(
                          //           context, "title", "", Container(), false)),
                          // );
                        },
                        child: Container(
                          height: 40,
                          width: 40.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text(
                            'Request',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ), */
                    ],
                  ),
                ],
              ),
            )));
  }

  void getCustomePolyPoints(sourceLt, sourceLo) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Your Google Map Key
      PointLatLng(sourceLt, sourceLo),
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

  List<Uint8List> resize = [];
  Set<Marker> markers = <Marker>{};
  resizeNetworkImage() async {
    var iconurl =
        "https://becktesting.site/workout-bud/public/storage/user/1667803800.jpg";
    var dataBytes;
    var request = await http.get(Uri.parse(iconurl));
    var bytes = await request.bodyBytes;
    //medium method
    final int targetWidth = 50;
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(iconurl);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    final Codec markerImageCodec = await instantiateImageCodec(
      markerImageBytes,
      targetWidth: targetWidth,
    );
    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();

    setState(() {
      dataBytes = bytes;
    });
  }

  LocationData? currentLocation;

  void getCurrentLocation() async {
    _markers.clear();
    final Uint8List markerIcon = await getBytesFromAsset(
      'assets/images/myloc.png',
      30,
    );
    /*  var iconurl =
        "https://becktesting.site/workout-bud/public/storage/user/1667803800.jpg";
    var dataBytes;
    var request = await http.get(Uri.parse(iconurl));
    var bytes = await request.bodyBytes; */
    //medium method
    /*  final int targetWidth = 50;
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(iconurl);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    final Codec markerImageCodec = await instantiateImageCodec(
      markerImageBytes,
      targetWidth: targetWidth,
    );
    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List(); */
    /*   List<Uint8List> bytes = [];
    for (int i = 0; i < getUsersList.length; i++) {
      if (getUsersList[i].image != null) {
        bytes.add((await NetworkAssetBundle(Uri.parse(
                    'https://becktesting.site/workout-bud/public/storage/user/' +
                        getUsersList[i].image.toString()))
                .load(
                    'https://becktesting.site/workout-bud/public/storage/user/' +
                        getUsersList[i].image.toString()))
            .buffer
            .asUint8List());
      } else {
        bytes.add(await getBytesFromAsset(
          'assets/images/myloc.png',
          30,
        ));
      }
    } */

    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
/* 
         if (locationCheck) {
          googleMapController.animateCamera(

            CameraUpdate.newCameraPosition(

              CameraPosition(
                
                zoom: 16.5,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!,
                ),
              ),
            ),
          );
        } else {
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 16.5,
                target: LatLng(
                    profileInfo.lat!.toDouble(), profileInfo.lng!.toDouble()),
              ),
            ),
          );
        }
 */
        if (mounted) {
          setState(() async {
            if (locationCheck) {
              _markers.add(Marker(
                  markerId: const MarkerId('Home'),
                  icon: BitmapDescriptor.fromBytes(markerIcon),
                  position:
                      LatLng(newLoc.latitude ?? 0.0, newLoc.longitude ?? 0.0)));
            } else {
              _markers.add(Marker(
                  markerId: const MarkerId('Home'),
                  icon: BitmapDescriptor.fromBytes(markerIcon),
                  position: LatLng(profileInfo.lat!.toDouble(),
                      profileInfo.lng!.toDouble())));
            }

            for (var i = 0; i < getUsersList.length; i++) {
              _markers.add(Marker(
                  onTap: () {
                    // polylineCoordinates.clear();
                    _show(context, i);

                    setState(() {});
                  },
                  markerId: MarkerId(getUsersList[i].id.toString()),
                  icon: getUsersList[i].image == null
                      ? BitmapDescriptor.defaultMarker
                      : await MarkerIcon.downloadResizePictureCircle(
                          'https://becktesting.site/workout-bud/public/storage/user/' +
                              getUsersList[i].image.toString(),
                          size: 70,
                          addBorder: true,
                          borderColor: Colors.white,
                          borderSize: 5),
                  /* BitmapDescriptor.fromBytes(resizedMarkerImageBytes), */
                  /*  BitmapDescriptor.fromBytes(
                    dataBytes.buffer.asUint8List(),
                  ), */
                  /* getUsersList[i].image == null
                      ? BitmapDescriptor.defaultMarker
                      : BitmapDescriptor.fromBytes(bytes[i],
                          size: ui.Size(5, 5)), */
                  position: LatLng(getUsersList[i].lat, getUsersList[i].long)));
            }
            setState(() {});
          });
        }
      },
    );
  }

  bool pageLoader = false;
  callapi() async {
    setState(() {
      pageLoader = true;
    });
    await DataApiService.instance.getUsers(context);
    await DataApiService.instance.getAddressList(context);

    setState(() {
      pageLoader = false;
    });
  }

  _showInterestDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.only(top: 8),
              title: Text("Select Your Interest"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      Map<String, dynamic> interestFilter = {
                        'ids': filterList.join(','),
                      };
                      print(interestFilter);
                      getUsersList.clear();
                      _markers.clear();
                      setState(
                        () {
                          buttonLoader = true;
                        },
                      );

                      await DataApiService.instance
                          .getUsersPreference(interestFilter, context);
                      getCurrentLocation();
                      setState(
                        () {
                          buttonLoader = false;
                        },
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      child: buttonLoader
                          ? spinkit
                          : const Text(
                              'Ok',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                )
              ],
              content: Container(
                height: 40.h,
                child: ListView.builder(
                  itemCount: getfilterList.length,
                  itemBuilder: (BuildContext context, int indexl) {
                    return ExpansionTile(
                      title: Text(getfilterList[indexl].title,
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      // subtitle: Text('Please choose your favourite sport'),
                      trailing: Icon(
                        _customTileExpandedSports
                            ? Icons.arrow_drop_down_circle
                            : Icons.arrow_drop_down,
                      ),
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  getfilterList[indexl].getSubCate!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  leading: Checkbox(
                                    onChanged: (x) {
                                      setState(() {
                                        if (filterList.contains(
                                            getfilterList[indexl]
                                                .getSubCate![index]
                                                .id
                                                .toString())) {
                                          filterList.remove(
                                              getfilterList[indexl]
                                                  .getSubCate![index]
                                                  .id
                                                  .toString());
                                        } else {
                                          filterList.add(getfilterList[indexl]
                                              .getSubCate![index]
                                              .id
                                              .toString());
                                        }
                                      });
                                      print(filterList);
                                    },
                                    activeColor: secondaryColor,
                                    value: filterList.contains(
                                        getfilterList[indexl]
                                            .getSubCate![index]
                                            .id
                                            .toString()),
                                  ),
                                  title: Transform.translate(
                                    offset: Offset(-26, 0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (filterList.contains(
                                              getfilterList[indexl]
                                                  .getSubCate![index]
                                                  .id
                                                  .toString())) {
                                            filterList.remove(
                                                getfilterList[indexl]
                                                    .getSubCate![index]
                                                    .id
                                                    .toString());
                                          } else {
                                            filterList.add(getfilterList[indexl]
                                                .getSubCate![index]
                                                .id
                                                .toString());
                                          }
                                        });
                                      },
                                      child: Text(
                                        getfilterList[indexl]
                                            .getSubCate![index]
                                            .title,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8.sp),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 3, crossAxisCount: 2),
                            ))
                      ],
                      initiallyExpanded: false,
                      onExpansionChanged: (bool expanded) {
                        setState(() => _customTileExpandedSports = expanded);
                      },
                    );
                  },
                ),
              ),
            );
          });
        });
  }

  _showdialog() async {
    // await Future.delayed(Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Text("Select Your Location"),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          buttonLoader = true;
                        });
                        getUsersList.clear();
                        await DataApiService.instance.getprofileinfo(context);
                        await DataApiService.instance.getUsers(context);

                        getCurrentLocation();
                        sourceLocation =
                            LatLng(profileInfo.lat!, profileInfo.lng!);

                        setState(() {
                          buttonLoader = false;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        child: buttonLoader
                            ? spinkit
                            : Text(
                                'Ok',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  )
                ],
                content: Container(
                  height: 40.h,
                  child: alertLoader
                      ? Container(height: 80.h, child: pageSpinkit)
                      : ListView.builder(
                          itemCount: getAddrList.length,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: Column(
                              children: [
                                index == 0
                                    ? ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: false,
                                        minLeadingWidth: 10,
                                        leading: SizedBox(
                                          width: 20,
                                          height: 70,
                                          child: Checkbox(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            onChanged: (x) async {
                                              setState(() {
                                                locationCheck = !locationCheck;

                                                addresslist.clear();
                                              });
                                            },
                                            activeColor: secondaryColor,
                                            value: locationCheck,
                                          ),
                                        ),
                                        title: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              locationCheck = !locationCheck;

                                              addresslist.clear();
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Current Location',
                                                          style: TextStyle(
                                                              fontSize: 13.sp),
                                                        ),
                                                        /*   Text(
                                          useraddr[index].useraddress.toString(),
                                          style: TextStyle(
                                              color: Colors.black.withOpacity(0.5),
                                              fontSize: 11.sp),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ), */
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  dense: false,
                                  minLeadingWidth: 10,
                                  leading: SizedBox(
                                    width: 20,
                                    height: 70,
                                    child: Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (x) async {
                                        _markers.clear();
                                        setState(() {
                                          locationCheck = false;
                                          if (addresslist.contains(
                                              getAddrList[index].id)) {
                                            addresslist
                                                .remove(getAddrList[index].id);
                                          } else {
                                            addresslist.clear();
                                            addresslist
                                                .add(getAddrList[index].id);
                                          }
                                          alertLoader = true;
                                        });
                                        Map<String, dynamic> update_address = {
                                          'lat':
                                              getAddrList[index].lat.toString(),
                                          'long': getAddrList[index]
                                              .long
                                              .toString(),
                                        };
                                        print(update_address);
                                        await DataApiService.instance
                                            .updateAddress(
                                                update_address, context);
                                        /*  await DataApiService.instance
                                        .getprofileinfo(context);
                                    sourceLocation = LatLng(
                                        profileInfo.lat!, profileInfo.lng!); */

                                        setState(() {
                                          alertLoader = false;
                                        });
                                        GlobalSnackBar.show(
                                            context, SnackMessage.toString());
                                      },
                                      activeColor: secondaryColor,
                                      value: addresslist
                                          .contains(getAddrList[index].id),
                                    ),
                                  ),
                                  title: InkWell(
                                    onTap: () async {
                                      _markers.clear();
                                      setState(() {
                                        locationCheck = false;
                                        if (addresslist
                                            .contains(getAddrList[index].id)) {
                                          addresslist
                                              .remove(getAddrList[index].id);
                                        } else {
                                          addresslist.clear();
                                          addresslist
                                              .add(getAddrList[index].id);
                                        }
                                        alertLoader = true;
                                      });
                                      Map<String, dynamic> updateAddress = {
                                        'lat':
                                            getAddrList[index].lat.toString(),
                                        'long':
                                            getAddrList[index].long.toString(),
                                      };
                                      print(updateAddress);
                                      await DataApiService.instance
                                          .updateAddress(
                                              updateAddress, context);
                                      /*  await DataApiService.instance
                                      .getprofileinfo(context);
                                  sourceLocation = LatLng(
                                      profileInfo.lat!, profileInfo.lng!); */

                                      setState(() {
                                        alertLoader = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    getAddrList[index]
                                                        .name
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13.sp),
                                                  ),
                                                  /*   Text(
                                              useraddr[index].useraddress.toString(),
                                              style: TextStyle(
                                                  color: Colors.black.withOpacity(0.5),
                                                  fontSize: 11.sp),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ), */
                                                ],
                                              ),
                                              Container(
                                                width: 45.w,
                                                child: Text(
                                                  getAddrList[index]
                                                      .locationName
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      fontSize: 11.sp),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ));
          });
        });
  }

  @override
  void initState() {
    // getPolyPoints();
    super.initState();
    filterList.clear();
    sourceLocation = LatLng(profileInfo.lat!, profileInfo.lng!);
    callapi();
    /* WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _showdialog();
    }); */

    getCurrentLocation();

    requestPermission();

    loadFCM();

    listenFCM();

    getToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed(context);
        if (result == null) {
          result = false;
        }
        return result;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(index: 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Track'),
          actions: [
            /*  InkWell(
              onTap: () {
                _showdialog();
              },
              child: Container(
                height: 25,
                width: 25,
                child: Image.asset(
                  'assets/icons/address.png',
                  color: secondaryColor,
                ),
              ),
            ), */
            Padding(
              padding: const EdgeInsets.only(right: 2.0, top: 2),
              child: InkWell(
                onTap: () {
                  _showInterestDialog();

                  setState(() {});
                },
                child: Stack(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.filter_alt_outlined,
                        size: 24,
                        color: secondaryColor,
                      ), /*  DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(border: InputBorder.none),
                          hint: Container(
                            width: 50,
                            child: const Text(
                              "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                  fontSize: 14),
                            ),
                          ),
                          elevation: 0,
                          // Initial Value
                          // value: dropdownvalue,
              
                          // Down Arrow Icon
                          icon: const Icon(
                            Icons.filter_alt_outlined,
                            size: 24,
                            color: secondaryColor,
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
                                    style: const TextStyle(
                                        fontSize: 14, color: secondaryColor),
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
                      ), */
                    ),
                    Positioned(
                      right: 1.2.h,
                      top: 7,
                      child: Container(
                          height: 15,
                          width: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            filterList.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        body: connected == false
            ? NoInternet(
                page: TrackScreen(),
              )
            : pageLoader
                ? Center(
                    child: pageSpinkit,
                  )
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: sourceLocation,
                      zoom: 15,
                    ),
                    markers: _markers,
                    /* {
            const Marker(
              markerId: MarkerId("source"),
              position: sourceLocation,
            ),
            const Marker(
              markerId: MarkerId("destination"),
              position: destination,
            ),
          }, */
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
                    zoomControlsEnabled: false,
                  ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showdialog();

              setState(() {});
            },
            child: Icon(Icons.location_on)),
      ),
    );
  }
}
