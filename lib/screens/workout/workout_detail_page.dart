import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart' as form;
import 'package:lottie/lottie.dart';


import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:co_op/screens/workout/get_ready.dart';

import '../../constants/constants.dart';
import '../../constants/noInternet.dart';
import '../../provider/dark_theme_provider.dart';
import '../../search/clock.dart';

class WorkoutDetail extends StatefulWidget {
  final String id;

  WorkoutDetail(this.id);

  @override
  State<WorkoutDetail> createState() => _WorkoutDetailState();
}

class _WorkoutDetailState extends State<WorkoutDetail> {
  CarouselController controller = CarouselController();
  List<String> userName = ['Jack', 'Shane', 'Alex Hales', 'Johnson'];
  List<double> ratings = [5.0, 4.0, 3.5, 2.5];
  List<String> images = [
    'assets/images/stretching.jpg',
    'assets/images/weight.jpg',
    'assets/images/weight.jpg',
    'assets/images/muscles.webp',
  ];

  List<String> imageList = [
    "assets/images/stretching.jpg",
  ];
  int selectedIndexDots = 0;
  int selectedIndex = 0;

  double _userRating = 0.0;
  double _initialRating = 5.0;
  String pickedDate = '';
  String pickedTime = '';
  String pickedTimeApi = '';
  String pickedEndTime = '';
  String pickedEndTimeApi = '';
  bool buttonLoader = false;
  String latitude = '';
  String longitude = '';

  IconData? _selectedIcon;
  bool loader = false;
  bool acceptLoader=false;
  bool declineLoader=false;
  bool found = false;
  TextEditingController AddressController = TextEditingController();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  int _duration = 500;
  int _initDuration = 0;

  int timerleft = 0;

  timeDifference() async {
    Duration initDif = DateTime.now().difference(startTime);
    Duration dif = endTime.difference(DateTime.now());
    _initDuration = initDif.inSeconds;
    _duration = dif.inSeconds;
    print('duration');
    print(_duration);
    if (_duration < 0) {
      await DataApiService.instance
          .completeRequest(users.requestId.toString(), context);
      await DataApiService.instance
          .getUserStatus(profileInfo.id.toString(), widget.id, context);
    }
  }

  void _timeDifference() {
    String st = form.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    print(getrequest.meetUpTime);
    DateTime startDate = form.DateFormat("yyyy-MM-dd HH:mm:ss").parse(st);
    DateTime endDate = form.DateFormat("yyyy-MM-dd HH:mm:ss").parse(
        users.request[0].meetUpDate.toString() +
            ' ' +
            users.request[0].meetUpTime);
    print('start');
    print(startDate);
    print(endDate);

// Get the Duration using the diferrence method

    Duration dif = endDate.difference(startDate);

// Print the result in any format you want
    print(dif.toString()); // 12:00:00.000000
    print(dif.inSeconds);
    timerleft = dif.inSeconds;
    if (timerleft < 0) {
      Get.to(() => Clock(users.requestId.toString(),widget.id));
    }
  }

  callApi() async {
    found=false;
    setState(() {
      loader = true;
    });
    // await DataApiService.instance
    //     .requstList(profileInfo.id.toString(), context);

    await DataApiService.instance
        .getUserStatus(profileInfo.id.toString(), widget.id, context);
    await DataApiService.instance
        .requstList(users.requestId.toString(), context);
    if (users.request.isNotEmpty) {
      startTime = form.DateFormat("yyyy-MM-dd HH:mm:ss").parse(
          users.request[0].meetUpDate.toString() +
              ' ' +
              users.request[0].meetUpTime);
      endTime = form.DateFormat("yyyy-MM-dd HH:mm:ss").parse(
          users.request[0].meetUpDate.toString() +
              ' ' +
              users.request[0].endTime);
      // await timeDifference();
      setState(() {});
    }
    print('request');
    print(requestList);
    for (var i = 0; i < requestList.length; i++) {
      if (requestList[i].toString() == widget.id) {
        found = true;
      }
    }

    setState(() {
      loader = false;
    });
  }

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
  }
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future<void> _pullRefresh() async {
    callApi();
    _refreshController.refreshCompleted();
  }
  @override
  void initState() {
    super.initState();

    callApi();
  }

  @override
  void dispose() {
    String pickedDate = '';
    String pickedTime = '';
    String pickedTimeApi = '';
    String pickedEndTime = '';
    String pickedEndTimeApi = '';
    AddressController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: connected == false
          ? NoInternet(
              page: WorkoutDetail(widget.id),
            )
          : loader
              ? Center(child: pageSpinkit)
              : SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _pullRefresh,
                child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          users.userData!.getWorkoutImages.isEmpty
                              ? CarouselSlider(
                                  carouselController: controller,
                                  items: imageList.map((e) {
                                    return InkWell(
                                      onTap: () {
                                        if (selectedIndexDots ==
                                            imageList.length - 1) {
                                          print('click');
                                        }
                                      },
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0)),
                                        ),
                                        color: Colors.transparent,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(e.trim().toString()),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                      enableInfiniteScroll: false,
                                      viewportFraction: 1,
                                      height: 260,
                                      onPageChanged: (val, _) {
                                        setState(() {
                                          selectedIndexDots = val;
                                          controller.jumpToPage(val);
                                        });
                                      }),
                                )
                              : CarouselSlider(
                                  carouselController: controller,
                                  items: users
                                      .userData!.getWorkoutImages[0].images
                                      .map((e) {
                                    return InkWell(
                                      onTap: () {
                                        if (selectedIndexDots ==
                                            users.userData!.getWorkoutImages[0]
                                                    .images.length -
                                                1) {
                                          print('click');
                                        }
                                      },
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0)),
                                        ),
                                        color: Colors.transparent,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: CachedNetworkImage(
                                            height: 34.h,
                                            width: 100.w,
                                            fit: BoxFit.contain,
                                            imageUrl:
                                                'https://becktesting.site/workout-bud/public/storage/user/workout/' +
                                                    e,
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/images/stretching.jpg',
                                              fit: BoxFit.cover,
                                              height: 34.h,
                                              width: 70.w,
                                            ),
                                            errorWidget: (context, url,
                                                    error) => /* Icon(Icons
                                .person) */
                                                Image.asset(
                                              'assets/images/stretching.jpg',
                                              fit: BoxFit.cover,
                                              height: 34.h,
                                              width: 70.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                      viewportFraction: 1,
                                      height: 260,
                                      onPageChanged: (val, _) {
                                        setState(() {
                                          selectedIndexDots = val;
                                          controller.jumpToPage(val);
                                        });
                                      }),
                                ),
                          Positioned(
                            bottom: 10,
                            child: AnimatedSmoothIndicator(
                              activeIndex: selectedIndexDots,
                              count: imageList.length,
                              effect: const WormEffect(
                                  dotHeight: 8,
                                  dotColor: Colors.white,
                                  activeDotColor: Colors.deepPurpleAccent),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 10,
                            right: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      print('click');
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 4.h,
                                      width: 4.h,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.arrow_back,
                                          color: Colors.white),
                                    )),
                                Row(
                                  children: [
                                    /*  Icon(Icons.bookmark, color: Colors.white), */
                                    /*  InkWell(
                                        onTap: () async {
                                          /*             await selectFile();
                                          print(files.length);
                                          DataApiService.instance
                                              .uploadImages(context); */
                                        },
                                        child: Icon(Icons.menu,
                                            color: Colors.white)), */
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          children: [
                            Text(
                              users.userData!.userName,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      const Divider(
                        height: 10,
                        color: Colors.black,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      " ",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),

                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 9.h,
                                        width: 19.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.1),
                                              offset: Offset(
                                                3.0,
                                                3.0,
                                              ),
                                              blurRadius: 10.0,
                                              spreadRadius: 4.0,
                                            ),
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.1),
                                              offset: Offset(
                                                -3.0,
                                                -1.0,
                                              ),
                                              blurRadius: 10.0,
                                              spreadRadius: 4.0,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:8.0,left: 8),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                      width: 2.5.h,
                                                      height: 2.h,
                                                      child: Image.asset(
                                                          'assets/icons/request.png')),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  Container(
                                                    child: const Text(
                                                      'Rating',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0),
                                                    child: Text(
                                                      users.userData!.rating
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  AbsorbPointer(
                                                    absorbing: true,
                                                    child: RatingBar(
                                                        tapOnlyMode: false,
                                                        updateOnDrag: false,
                                                        initialRating: users
                                                            .userData!.rating,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 15,
                                                        ratingWidget:
                                                            RatingWidget(
                                                                full: const Icon(
                                                                    Icons.star,
                                                                    color:
                                                                        secondaryColor),
                                                                half: const Icon(
                                                                  Icons.star_half,
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                                empty: const Icon(
                                                                  Icons
                                                                      .star_outline,
                                                                  color:
                                                                      secondaryColor,
                                                                )),
                                                        onRatingUpdate:
                                                            (value) {}),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Container(
                                      height: 9.h,
                                      width: 19.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            offset: Offset(
                                              3.0,
                                              3.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 4.0,
                                          ),
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            offset: Offset(
                                              -3.0,
                                              -1.0,
                                            ),
                                            blurRadius: 10.0,
                                            spreadRadius: 4.0,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:8.0,left: 8),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                    width: 2.5.h,
                                                    height: 2.5.h,
                                                    child: Image.asset(
                                                        'assets/icons/exercises.png')),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Container(
                                                  child: const Text(
                                                    'Finished',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  users.userData!.completed
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 22),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Text(
                                                  'Workouts',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 90.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          offset: Offset(
                                            3.0,
                                            3.0,
                                          ),
                                          blurRadius: 10.0,
                                          spreadRadius: 4.0,
                                        ),
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          offset: Offset(
                                            -3.0,
                                            -1.0,
                                          ),
                                          blurRadius: 10.0,
                                          spreadRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 20, right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Age',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  users.userData!.age.toString(),
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 20, right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Weight',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  users.userData!.weight
                                                          .toString() +
                                                      ' lbs',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 20, right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Height',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  users.userData!.height
                                                          .toString() +
                                                      ' ft',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 20, right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Activity level',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  users.userData!.activityLevel ==
                                                          'null'
                                                      ? 'Beginner'
                                                      : users
                                                          .userData!.activityLevel
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 20, right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Email',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  users.userData!.email
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        users.userData!.phone == null
                                            ? SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 20,
                                                    right: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Phone number',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      users.userData!.phone ==
                                                              null
                                                          ? '-'
                                                          : users.userData!.phone
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        users.userData!.nickName == null ||
                                                users.userData!.nickName == 'null'
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 20,
                                                    right: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: const Text(
                                                        'Nick name',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        users.userData!
                                                                    .nickName ==
                                                                null
                                                            ? '-'
                                                            : users.userData!
                                                                .nickName
                                                                .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 20, right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: const Text(
                                                  'Goals',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 20, right: 20),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              runAlignment: WrapAlignment.start,
                                              runSpacing: 10.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              direction: Axis.horizontal,
                                              textDirection: TextDirection.ltr,
                                              spacing: 5,
                                              children: <Widget>[
                                                for (int i = 0;
                                                    i <
                                                        users.userData!.goal
                                                            .length;
                                                    i++)
                                                  Container(
                                                      height: 35,
                                                      width: users.userData!
                                                              .goal[i].length
                                                              .toDouble() *
                                                          9.8,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  secondaryColor,
                                                              width: 1.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20)),
                                                      child: Center(
                                                          child: Text(
                                                        users.userData!.goal[i],
                                                      ))),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 80,
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: loader
          ? SizedBox()
          : users.status == 1
             //start
              ? InkWell(
                  onTap: () {
                    setState(() {});
                    Get.to(() => Clock(users.requestId.toString(),widget.id));
                  },
                  child: Container(
                      height: 6.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                          child: Text('START',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white)))),
                )
              : found
               //request in progress
                  ? InkWell(
                      onTap: () {
                        setState(() {});
                      },
                      child: Container(
                          height: 6.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Center(
                              child: Text('Request In Progress',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)))),
                    )
                  : users.status == 0
                      ?//accept
                      InkWell(
                                          onTap: () {
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

                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context)
                                                                  .scaffoldBackgroundColor,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            height: 30.h,
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      left: 20,
                                                                      right: 20),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        child: Text(
                                                                          'Workout Date',
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: Text(
                                                                          users.request[0].meetUpDate.toString().split(' ')[0],
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      left: 20,
                                                                      right: 20),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        child: Text(
                                                                          'Workout start time',
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: Text(
                                                                          form.DateFormat("h:mma").format(DateTime.parse('2022-12-02 '+users.request[0].meetUpTime))
                                                                          ,
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ), Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      left: 20,
                                                                      right: 20),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        child: Text(
                                                                          'Workout end time',
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: Text(
                                                                          form.DateFormat("h:mma").format(DateTime.parse('2022-12-02 '+users.request[0].endTime)),
                                                                          style: TextStyle(
                                                                              fontWeight:
                                                                              FontWeight.bold,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10.h,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        setState((){
                                                                          acceptLoader=true;
                                                                        });
                                                                        await DataApiService.instance
                                                                            .resposneRequest(
                                                                            users.requestId.toString(),
                                                                            '1',
                                                                            context);
                                                                        /*     Navigator.pop(
                                                                    context); */
                                                                        setState((){
                                                                          acceptLoader=false;
                                                                        });
                                                                        Navigator.pop(context);

                                                                        Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder:
                                                                                    (BuildContext context) =>
                                                                                    WorkoutDetail(
                                                                                        widget.id)));

                                                                      },
                                                                      child: Container(
                                                                          height: 6.h,
                                                                          width: 30.w,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.green,
                                                                              borderRadius: BorderRadius.circular(30)),
                                                                          child:  Center(
                                                                              child:acceptLoader?spinkit: const Text('Accept',
                                                                                  style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      color: Colors.white)))),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        setState((){
                                                                          declineLoader=true;
                                                                        });
                                                                        await DataApiService.instance
                                                                            .resposneRequest(
                                                                            users.requestId.toString(),
                                                                            '0',
                                                                            context);
                                                                        setState((){
                                                                          declineLoader=false;
                                                                        });
                                                                        Navigator.pop(context);

                                                                        Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder:
                                                                                    (BuildContext context) =>
                                                                                    WorkoutDetail(
                                                                                        widget.id)));

                                                                      },
                                                                      child: Container(
                                                                          height: 6.h,
                                                                          width: 30.w,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.red,
                                                                              borderRadius: BorderRadius.circular(30)),
                                                                          child:  Center(
                                                                              child:declineLoader?spinkit: const Text('Decline',
                                                                                  style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      color: Colors.white)))),
                                                                    ),
                                                                  ],
                                                                )

                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                });
                                          },
                                          child:/*Container(
                                            height: 80,
                                            width: 80.w,
                                            child: OverflowBox(
                                                minHeight: 170,
                                                maxHeight: 170,
                                                minWidth: 200,
                                                child: Lottie.asset(
                                                  'assets/animations/requestButton.json',
                                                ),),
                                          ) */Container(
                                              height: 6.h,
                                              width: 80.w,
                                              decoration: BoxDecoration(
                                                  color: Colors.deepPurpleAccent,
                                                  borderRadius: BorderRadius.circular(30)),
                                              child: const Center(
                                                  child: Text('View Request',
                                                      style: TextStyle(
                                                          fontSize: 18, color: Colors.white)))),
                                        )
                   //send request
                   : InkWell(
                          onTap: () {
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
                                        height: 40.h,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      /*   InkWell(
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
                                                        ), */
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  /*    Text(
                                                        getUsersList[index]
                                                            .userName,
                                                        textAlign: TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline3),
                                                    SizedBox(height: 10), */
                                                  Text(
                                                      'Pick your date and time',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      DatePicker.showDatePicker(context,
                                                          showTitleActions:
                                                              true,
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
                                                              doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                                          onChanged: (date) {
                                                        final f =
                                                            form.DateFormat(
                                                                "dd:mm:yyyy");
                                                        setState(() {
                                                          pickedDate = date
                                                              .toString()
                                                              .split(' ')[0];
                                                          print('pickedDate');
                                                          print(pickedDate);
                                                        });
                                                        print('change $date in time zone ' +
                                                            date.timeZoneOffset
                                                                .inHours
                                                                .toString());
                                                      }, onConfirm: (date) {
                                                        final f =
                                                            form.DateFormat(
                                                                "dd:mm:yyyy");
                                                        setState(() {
                                                          pickedDate = date
                                                              .toString()
                                                              .split(' ')[0];
                                                          print('pickedDate');
                                                          print(pickedDate);
                                                        });
                                                        print('change $date in time zone ' +
                                                            date.timeZoneOffset
                                                                .inHours
                                                                .toString());
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
                                                          color:
                                                              secondaryColor),
                                                      child: Center(
                                                        child: Text(
                                                          pickedDate != ''
                                                              ? pickedDate
                                                              : 'Pick Date',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                                            theme: const DatePickerTheme(
                                                                headerColor:
                                                                    secondaryColor,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                itemStyle: TextStyle(
                                                                    color:
                                                                        primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
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
                                                          print(pickedTime);
                                                          print(
                                                              'confirm $time');
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
                                                                    .circular(
                                                                        10),
                                                            color:
                                                                secondaryColor),
                                                        child: Center(
                                                          child: Text(
                                                            pickedTime != ''
                                                                ? pickedTime
                                                                : 'Pick Time',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              Center(
                                                child: TextButton(
                                                    onPressed: () {
                                                      DatePicker.showTime12hPicker(
                                                          context,
                                                          showTitleActions:
                                                              true,
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
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      16)),
                                                          onChanged: (time) {
                                                        /*   final f = form.DateFormat("hh:mm a");
                                                                                  final s = form.DateFormat("HH:mm");

                                                                                  f.format(time);
                                                                                  setState(() {
                                                                                    pickedEndTime = f.format(time);
                                                                                  });
                                                                                  pickedEndTimeApi = s.format(time); */
                                                      }, onConfirm: (time) {
                                                        /*  if (time.isBefore(form.DateFormat("hh:mm a").parse(pickedTime))) {
                                                                                    Fluttertoast.showToast(msg: 'Please pick correct time'.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);
                                                                                  } else { */

                                                        final f =
                                                            form.DateFormat(
                                                                "hh:mm a");
                                                        final s =
                                                            form.DateFormat(
                                                                "HH:mm");

                                                        f.format(time);
                                                        String timeCheck =
                                                            f.format(time);
                                                        DateTime check =
                                                            f.parse(timeCheck);
                                                        if (check.isBefore(
                                                            f.parse(
                                                                pickedTime))) {
                                                          Fluttertoast.showToast(
                                                              msg: 'Sorry! you entered wrong a time'
                                                                  .toString(),
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                        } else {
                                                          setState(() {
                                                            pickedEndTime =
                                                                f.format(time);
                                                          });
                                                          pickedEndTimeApi =
                                                              s.format(time);
                                                          print(pickedEndTime);
                                                          print(
                                                              'confirm $time');
                                                        }
                                                      },
                                                          currentTime:
                                                              DateTime.now());
                                                    },
                                                    child: Container(
                                                      height: 6.h,
                                                      width: 65.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              secondaryColor),
                                                      child: Center(
                                                        child: Text(
                                                          pickedEndTime != ''
                                                              ? pickedEndTime
                                                              : 'Pick End Time',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 0, 20, 0),
                                                  child: Column(
                                                    children: [

                                                      Container(
                                                        width: 65.w,
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
                                                                          tagName
                                                                              .split(',');
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
                                                                        AddressController.text = result
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
                                                                        const LatLng(
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
                                                                  const EdgeInsets
                                                                          .symmetric(
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
                                                                    const BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .red),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                              border:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                              prefixIcon:
                                                                  const Icon(Icons
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
                                                                  ? Colors
                                                                      .white38
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

                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              Container(
                                                height: 5.5.h,
                                                width: 70.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: primaryColor),
                                                child: InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      buttonLoader = true;
                                                    });
                                                    if (pickedDate != '' &&
                                                        pickedEndTime != '' &&
                                                        AddressController
                                                            .text.isNotEmpty &&
                                                        pickedTime != '') {
                                                      Map<String, dynamic>
                                                          request = {
                                                        /*    'requested_by_id':
                                                            profileInfo.id
                                                                .toString(), */
                                                        'requested_to_id':
                                                            widget.id
                                                                .toString(),
                                                        'long': longitude,
                                                        'lat': latitude,
                                                        'meet_up_date':
                                                            pickedDate,
                                                        'meet_up_time':
                                                            pickedTimeApi,
                                                        'meetup_end_time':
                                                            pickedEndTimeApi
                                                      };
                                                      print(request);
                                                      bool status =
                                                          await DataApiService
                                                              .instance
                                                              .sendRequest(
                                                                  request,
                                                                  context);
                                                      setState(() {
                                                        buttonLoader = false;
                                                      });
                                                      found = true;
                                                      Navigator.pop(context);
                                                      callApi();

                                                      if (status) {
                                                        Fluttertoast.showToast(
                                                            msg: SnackMessage
                                                                .toString(),
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg: SnackMessage
                                                                .toString(),
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      }
                                                    }
                                                  },
                                                  child: Center(
                                                      child: buttonLoader
                                                          ? spinkit
                                                          : Text("Send Request",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      2.1.h,
                                                                  color: Colors
                                                                      .white))),
                                                ),
                                              ),
                                            ]),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                });
                          },
                          child: Container(
                              height: 6.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Center(
                                  child: Text('Send Request',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)))),
                        ),
    );
  }
}
