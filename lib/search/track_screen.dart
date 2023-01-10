// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:custom_marker/marker_icon.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/custom_dialog.dart';
import 'package:co_op/screens/workout/workout_detail_page.dart';

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
                      AbsorbPointer(
                        absorbing: true,
                        child: RatingBar(
                            initialRating: getUsersList[index].rating,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 24,
                            ratingWidget: RatingWidget(
                                full: const Icon(Icons.star,
                                    color: secondaryColor),
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
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          getUsersList[index].rating.toString(),
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
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: 56.h,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Select Your Interest"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
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
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: getfilterList[indexl]
                                              .getSubCate!
                                              .length,
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
                                                              .getSubCate![
                                                                  index]
                                                              .id
                                                              .toString());
                                                    } else {
                                                      filterList.add(
                                                          getfilterList[indexl]
                                                              .getSubCate![
                                                                  index]
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
                                                              .getSubCate![
                                                                  index]
                                                              .id
                                                              .toString())) {
                                                        filterList.remove(
                                                            getfilterList[
                                                                    indexl]
                                                                .getSubCate![
                                                                    index]
                                                                .id
                                                                .toString());
                                                      } else {
                                                        filterList.add(
                                                            getfilterList[
                                                                    indexl]
                                                                .getSubCate![
                                                                    index]
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 8.sp),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 3,
                                                  crossAxisCount: 2),
                                        ))
                                  ],
                                  initiallyExpanded: false,
                                  onExpansionChanged: (bool expanded) {
                                    setState(() =>
                                        _customTileExpandedSports = expanded);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
                    ),
                  ],
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
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                height: 56.h,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Select Your Location"),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 40.h,
                            child: alertLoader
                                ? Container(height: 80.h, child: pageSpinkit)
                                : ListView.builder(
                                    itemCount: getAddrList.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3),
                                      child: Column(
                                        children: [
                                          index == 0
                                              ? ListTile(
                                                  contentPadding:
                                                      EdgeInsets.zero,
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
                                                          locationCheck =
                                                              !locationCheck;

                                                          addresslist.clear();
                                                        });
                                                      },
                                                      activeColor:
                                                          secondaryColor,
                                                      value: locationCheck,
                                                    ),
                                                  ),
                                                  title: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        locationCheck =
                                                            !locationCheck;

                                                        addresslist.clear();
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Current Location',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13.sp),
                                                                  ),

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
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                onChanged: (x) async {
                                                  _markers.clear();
                                                  setState(() {
                                                    locationCheck = false;
                                                    if (addresslist.contains(
                                                        getAddrList[index]
                                                            .id)) {
                                                      addresslist.remove(
                                                          getAddrList[index]
                                                              .id);
                                                    } else {
                                                      addresslist.clear();
                                                      addresslist.add(
                                                          getAddrList[index]
                                                              .id);
                                                    }
                                                    alertLoader = true;
                                                  });
                                                  Map<String, dynamic>
                                                      update_address = {
                                                    'lat': getAddrList[index]
                                                        .lat
                                                        .toString(),
                                                    'long': getAddrList[index]
                                                        .long
                                                        .toString(),
                                                  };
                                                  print(update_address);
                                                  await DataApiService.instance
                                                      .updateAddress(
                                                          update_address,
                                                          context);


                                                  setState(() {
                                                    alertLoader = false;
                                                  });
                                                  GlobalSnackBar.show(context,
                                                      SnackMessage.toString());
                                                },
                                                activeColor: secondaryColor,
                                                value: addresslist.contains(
                                                    getAddrList[index].id),
                                              ),
                                            ),
                                            title: InkWell(
                                              onTap: () async {
                                                _markers.clear();
                                                setState(() {
                                                  locationCheck = false;
                                                  if (addresslist.contains(
                                                      getAddrList[index].id)) {
                                                    addresslist.remove(
                                                        getAddrList[index].id);
                                                  } else {
                                                    addresslist.clear();
                                                    addresslist.add(
                                                        getAddrList[index].id);
                                                  }
                                                  alertLoader = true;
                                                });
                                                Map<String, dynamic>
                                                    updateAddress = {
                                                  'lat': getAddrList[index]
                                                      .lat
                                                      .toString(),
                                                  'long': getAddrList[index]
                                                      .long
                                                      .toString(),
                                                };
                                                print(updateAddress);
                                                await DataApiService.instance
                                                    .updateAddress(
                                                        updateAddress, context);


                                                setState(() {
                                                  alertLoader = false;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              getAddrList[index]
                                                                  .name
                                                                  .toString(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.sp),
                                                            ),

                                                          ],
                                                        ),
                                                        Container(
                                                          width: 45.w,
                                                          child: Text(
                                                            getAddrList[index]
                                                                .locationName
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                                fontSize:
                                                                    11.sp),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          if (addresslist.isNotEmpty) {
                            setState(() {
                              buttonLoader = true;
                            });
                            getUsersList.clear();
                            await DataApiService.instance
                                .getprofileinfo(context);
                            await DataApiService.instance.getUsers(context);

                            getCurrentLocation();
                            sourceLocation =
                                LatLng(profileInfo.lat!, profileInfo.lng!);

                            setState(() {
                              buttonLoader = false;
                            });
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
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
                ),
              ),
            );
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
                      ),

                    ),
                    Positioned(
                      right: 1.2.h,
                      top: 7,
                      child: Container(
                          height: 15,
                          width: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: secondaryColor,
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
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: sourceLocation,
                      zoom: 15,
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
