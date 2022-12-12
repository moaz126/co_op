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

import 'package:provider/provider.dart';
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
  bool found = false;
  TextEditingController AddressController = TextEditingController();
  callApi() async {
    setState(() {
      loader = true;
    });
    await DataApiService.instance
        .requstList(profileInfo.id.toString(), context);
    await DataApiService.instance
        .getUserStatus(profileInfo.id.toString(), widget.id, context);

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
              : Column(
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
                                      shape: RoundedRectangleBorder(
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
                                      shape: RoundedRectangleBorder(
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
                            effect: WormEffect(
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
                                    child: Icon(Icons.arrow_back,
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
                    SizedBox(
                      height: 10,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(18,4,18,4),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       InkWell(
                    //         highlightColor: Colors.transparent,
                    //         splashColor: Colors.transparent,
                    //         onTap: (){
                    //           setState(() {
                    //             selectedIndex=0;
                    //           });
                    //         },
                    //         child: Container(
                    //           height: 5.h,
                    //           width: 28.w,
                    //           decoration: BoxDecoration(
                    //               color: selectedIndex == 0 ? Colors.deepPurpleAccent : Colors.black12,
                    //               borderRadius: BorderRadius.circular(40),
                    //               border: Border.all(color: Colors.deepPurpleAccent)
                    //           ),
                    //           child:
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text("Beginner", style: TextStyle(color: selectedIndex == 0 ? Colors.white : Colors.deepPurpleAccent, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1 ))
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(height: 20,),
                    //       InkWell(
                    //         highlightColor: Colors.transparent,
                    //         splashColor: Colors.transparent,
                    //         onTap: (){
                    //           setState(() {
                    //             selectedIndex=1;
                    //           });
                    //         },
                    //         child: Container(
                    //           height: 5.h,
                    //           width: 28.w,
                    //           decoration: BoxDecoration(
                    //               color: selectedIndex == 1 ? Colors.deepPurpleAccent : Colors.black12,
                    //               borderRadius: BorderRadius.circular(40),
                    //               border: Border.all(color: Colors.deepPurpleAccent)
                    //           ),
                    //           child:
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Icon(Icons.timer_outlined, color: selectedIndex == 1 ? Colors.white : Colors.deepPurpleAccent, size: 20,),
                    //               Text(" 10 Minutes", style: TextStyle(color: selectedIndex == 1 ? Colors.white : Colors.deepPurpleAccent, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1 ),)
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(height: 20,),
                    //       InkWell(
                    //         highlightColor: Colors.transparent,
                    //         splashColor: Colors.transparent,
                    //         onTap: (){
                    //           setState(() {
                    //             selectedIndex=2;
                    //           });
                    //         },
                    //         child: Container(
                    //           height: 5.h,
                    //           width: 28.w,
                    //           decoration: BoxDecoration(
                    //               color: selectedIndex == 2 ? Colors.deepPurpleAccent : Colors.black12,
                    //               borderRadius: BorderRadius.circular(40),
                    //               border: Border.all(color: Colors.deepPurpleAccent)
                    //           ),
                    //           child:
                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Icon(Icons.play_circle_outline, color:selectedIndex == 2 ? Colors.white : Colors.deepPurpleAccent, size: 20,),
                    //               Text(" 10 Workouts", style: TextStyle(color: selectedIndex == 2 ? Colors.white : Colors.deepPurpleAccent, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1 ),)
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //
                    //     ],
                    //   ),
                    // ),
                    Divider(
                      height: 10,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Workout Activity",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          /*  Text(
                            "See All",
                            style: TextStyle(
                                color: Colors.deepPurpleAccent, fontSize: 16),
                          ), */
                        ],
                      ),
                    ),

                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          workoutWithList.isEmpty
                              ? Positioned(
                                  top: 20,
                                  child: Column(
                                    children: [
                                      emptyAnimation,
                                      Text("No Activity Found!")
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: workoutWithList.length,
                                  padding: EdgeInsets.only(bottom: 80),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(20),
                                                            topLeft:
                                                                Radius.circular(
                                                                    20)),
                                                    child: CachedNetworkImage(
                                                      height: 12.h,
                                                      width: 12.h,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          'https://becktesting.site/workout-bud/public/storage/user/' +
                                                              workoutWithList[
                                                                      index]
                                                                  .workoutUser[
                                                                      0]
                                                                  .image
                                                                  .toString(),
                                                      placeholder:
                                                          (context, url) =>
                                                              Image.asset(
                                                        images[0],
                                                        fit: BoxFit.cover,
                                                        height: 12.h,
                                                        width: 12.h,
                                                      ),
                                                      errorWidget: (context,
                                                              url,
                                                              error) => /* Icon(Icons
                              .person) */
                                                          Image.asset(
                                                        images[0],
                                                        fit: BoxFit.cover,
                                                        height: 12.h,
                                                        width: 12.h,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          workoutWithList[index]
                                                              .workoutUser[0]
                                                              .userName,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 20),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    AbsorbPointer(
                                                                      absorbing:
                                                                          true,
                                                                      child: RatingBar(
                                                                          initialRating: workoutWithList[index].rating == null ? 0.0 : workoutWithList[index].rating!,
                                                                          direction: Axis.horizontal,
                                                                          allowHalfRating: true,
                                                                          itemCount: 5,
                                                                          itemSize: 24,
                                                                          ratingWidget: RatingWidget(
                                                                              full: const Icon(Icons.star, color: secondaryColor),
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
                                                                              ratings[index] = value;
                                                                            });
                                                                          }),
                                                                    ),
                                                                    Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        workoutWithList[index].rating ==
                                                                                null
                                                                            ? '0.0'
                                                                            : workoutWithList[index].rating.toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                secondaryColor,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            workoutWithList[index]
                                                                        .bookmark ==
                                                                    0
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        DataApiService.instance.addBookmark(
                                                                            workoutWithList[index].id.toString(),
                                                                            context);
                                                                        workoutWithList[index]
                                                                            .bookmark = 1;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .bookmark_border,
                                                                        color:
                                                                            secondaryColor,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        DataApiService.instance.deleteBookmark(
                                                                            workoutWithList[index].id.toString(),
                                                                            context);
                                                                        workoutWithList[index]
                                                                            .bookmark = 0;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .bookmark,
                                                                        color:
                                                                            secondaryColor,
                                                                      ),
                                                                    ),
                                                                  )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Text(goal[1], style: TextStyle(color: Colors.black, fontSize: 14, ),),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          users.status == 1
                              ? Positioned(
                                  bottom: 8,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {});
                                      Get.to(() =>
                                          Clock(users.requestId.toString()));
                                    },
                                    child: Container(
                                        height: 6.h,
                                        width: 80.w,
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurpleAccent,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Center(
                                            child: const Text('START',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white)))),
                                  ),
                                )
                              : found
                                  ? Positioned(
                                      bottom: 8,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Container(
                                            height: 6.h,
                                            width: 80.w,
                                            decoration: BoxDecoration(
                                                color: Colors.deepPurpleAccent,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: Center(
                                                child: const Text(
                                                    'Request already send',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white)))),
                                      ),
                                    )
                                  : users.status == 0
                                      ? Positioned(
                                          bottom: 8,
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  AwesomeDialog(
                                                          context: context,
                                                          dialogType: DialogType
                                                              .question,
                                                          animType: AnimType
                                                              .BOTTOMSLIDE,
                                                          title: 'Request',
                                                          desc:
                                                              'Are you sure to accept this request',
                                                          btnOkOnPress:
                                                              () async {
                                                            await DataApiService
                                                                .instance
                                                                .resposneRequest(
                                                                    users
                                                                        .requestId
                                                                        .toString(),
                                                                    '1',
                                                                    context);
                                                            /*     Navigator.pop(
                                                                context); */

                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        WorkoutDetail(
                                                                            widget.id)));
                                                          },
                                                          btnCancelOnPress:
                                                              () {})
                                                      .show();
                                                },
                                                child: Container(
                                                    height: 6.h,
                                                    width: 40.w,
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Center(
                                                        child: const Text(
                                                            'Accept',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white)))),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  AwesomeDialog(
                                                          context: context,
                                                          dialogType: DialogType
                                                              .question,
                                                          animType: AnimType
                                                              .BOTTOMSLIDE,
                                                          title: 'Request',
                                                          desc:
                                                              'Are you sure to decline this request',
                                                          btnOkOnPress:
                                                              () async {
                                                            await DataApiService
                                                                .instance
                                                                .resposneRequest(
                                                                    users
                                                                        .requestId
                                                                        .toString(),
                                                                    '0',
                                                                    context);
                                                            Navigator.pop(
                                                                context);

                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        WorkoutDetail(
                                                                            widget.id)));
                                                          },
                                                          btnCancelOnPress:
                                                              () {})
                                                      .show();
                                                },
                                                child: Container(
                                                    height: 6.h,
                                                    width: 40.w,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Center(
                                                        child: const Text(
                                                            'Decline',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white)))),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Positioned(
                                          bottom: 8,
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    final themeChange = Provider
                                                        .of<DarkThemeProvider>(
                                                            context);

                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                        child: Container(
                                                          color: Theme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor,
                                                          height: 40.h,
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            10),
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
                                                                    SizedBox(
                                                                        height:
                                                                            10),
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
                                                                            TextAlign
                                                                                .center,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyText2),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 5),
                                                              Column(children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        DatePicker.showDatePicker(
                                                                            context,
                                                                            showTitleActions:
                                                                                true,
                                                                            minTime: DateTime(
                                                                                2022,
                                                                                10,
                                                                                24),
                                                                            maxTime: DateTime(
                                                                                2024,
                                                                                6,
                                                                                7),
                                                                            theme:
                                                                                const DatePickerTheme(headerColor: secondaryColor, backgroundColor: Colors.white, itemStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18), doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                                                            onChanged:
                                                                                (date) {
                                                                          final f =
                                                                              form.DateFormat("dd:mm:yyyy");
                                                                          setState(
                                                                              () {
                                                                            pickedDate =
                                                                                date.toString().split(' ')[0];
                                                                            print('pickedDate');
                                                                            print(pickedDate);
                                                                          });
                                                                          print('change $date in time zone ' +
                                                                              date.timeZoneOffset.inHours.toString());
                                                                        }, onConfirm:
                                                                                (date) {
                                                                          final f =
                                                                              form.DateFormat("dd:mm:yyyy");
                                                                          setState(
                                                                              () {
                                                                            pickedDate =
                                                                                date.toString().split(' ')[0];
                                                                            print('pickedDate');
                                                                            print(pickedDate);
                                                                          });
                                                                          print('change $date in time zone ' +
                                                                              date.timeZoneOffset.inHours.toString());
                                                                          print(
                                                                              'confirm $date');
                                                                        },
                                                                            currentTime:
                                                                                DateTime.now(),
                                                                            locale: LocaleType.en);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            6.h,
                                                                        width:
                                                                            30.w,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            color: secondaryColor),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            pickedDate != ''
                                                                                ? pickedDate
                                                                                : 'Pick Date',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          DatePicker.showTime12hPicker(
                                                                              context,
                                                                              showTitleActions:
                                                                                  true,
                                                                              theme: DatePickerTheme(headerColor: secondaryColor, backgroundColor: Colors.white, itemStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18), doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                                                              onChanged: (time) {
                                                                            final f =
                                                                                form.DateFormat("hh:mm a");
                                                                            final s =
                                                                                form.DateFormat("HH:mm");

                                                                            f.format(time);
                                                                            setState(() {
                                                                              pickedTime = f.format(time);
                                                                            });
                                                                            pickedTimeApi =
                                                                                s.format(time);
                                                                          }, onConfirm: (time) {
                                                                            final f =
                                                                                form.DateFormat("hh:mm a");
                                                                            final s =
                                                                                form.DateFormat("HH:mm");

                                                                            f.format(time);
                                                                            setState(() {
                                                                              pickedTime = f.format(time);
                                                                            });
                                                                            pickedTimeApi =
                                                                                s.format(time);
                                                                            print(pickedTime);
                                                                            print('confirm $time');
                                                                          }, currentTime: DateTime.now());
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              6.h,
                                                                          width:
                                                                              30.w,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: secondaryColor),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              pickedTime != '' ? pickedTime : 'Pick Time',
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                                Center(
                                                                  child:
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            DatePicker.showTime12hPicker(context,
                                                                                showTitleActions: true,
                                                                                theme: DatePickerTheme(headerColor: secondaryColor, backgroundColor: Colors.white, itemStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18), doneStyle: TextStyle(color: Colors.white, fontSize: 16)), onChanged: (time) {
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

                                                                              final f = form.DateFormat("hh:mm a");
                                                                              final s = form.DateFormat("HH:mm");

                                                                              f.format(time);
                                                                              String timeCheck = f.format(time);
                                                                              DateTime check = f.parse(timeCheck);
                                                                              if (check.isBefore(f.parse(pickedTime))) {
                                                                                Fluttertoast.showToast(msg: 'Sorry! you entered wrong a time'.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, textColor: Colors.white, fontSize: 16.0);
                                                                              } else {
                                                                                setState(() {
                                                                                  pickedEndTime = f.format(time);
                                                                                });
                                                                                pickedEndTimeApi = s.format(time);
                                                                                print(pickedEndTime);
                                                                                print('confirm $time');
                                                                              }
                                                                            }, currentTime: DateTime.now());
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                6.h,
                                                                            width:
                                                                                65.w,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryColor),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                pickedEndTime != '' ? pickedEndTime : 'Pick End Time',
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          )),
                                                                ),
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            20,
                                                                            0,
                                                                            20,
                                                                            0),
                                                                    child:
                                                                        Column(
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
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                TextFormField(
                                                                              validator: (value) {
                                                                                if (value!.isEmpty) {
                                                                                  return 'This field is required';
                                                                                }
                                                                              },
                                                                              onTap: () {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => PlacePicker(
                                                                                      apiKey: "AIzaSyBDOMNCVC2eacCxKYuRxIwCz4w-QjV_l5Y",
                                                                                      onPlacePicked: (result) {
                                                                                        print(result.geometry!.location);
                                                                                        final tagName = result.formattedAddress.toString();
                                                                                        print(result.formattedAddress);
                                                                                        final split = tagName.split(',');
                                                                                        final Map<int, String> values = {
                                                                                          for (int i = 0; i < split.length; i++) i: split[i]
                                                                                        };
                                                                                        final value1 = values[0];
                                                                                        final value2 = values[1];
                                                                                        final value3 = values[2];
                                                                                        final value4 = values[3];
                                                                                        setState(() {
                                                                                          AddressController.text = result.formattedAddress.toString();
                                                                                          latitude = result.geometry!.location.lat.toString();
                                                                                          longitude = result.geometry!.location.lng.toString();

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
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                      selectInitialPosition: true,
                                                                                      autocompleteOnTrailingWhitespace: true,
                                                                                      useCurrentLocation: true,
                                                                                      initialPosition: LatLng(31.65465, 31.35153),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              controller: AddressController,
                                                                              readOnly: true,
                                                                              showCursor: false,
                                                                              cursorColor: Colors.grey,
                                                                              textAlign: TextAlign.start,
                                                                              keyboardType: TextInputType.number,
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                                LengthLimitingTextInputFormatter(15)
                                                                              ],
                                                                              decoration: InputDecoration(
                                                                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                                                                errorBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  //<-- SEE HERE
                                                                                  borderSide: BorderSide(width: 1, color: Colors.red),
                                                                                ),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: Colors.transparent,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(10)),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: Colors.transparent,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(10)),
                                                                                border: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                      color: Colors.transparent,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(10)),
                                                                                prefixIcon: Icon(Icons.location_on),
                                                                                hintText: 'Select Meeting Point',
                                                                                hintStyle: TextStyle(color: themeChange.darkTheme ? Colors.white : Colors.grey, fontSize: 2.h, fontFamily: 'NeueMachina'),
                                                                                filled: true,
                                                                                fillColor: themeChange.darkTheme ? Colors.white38 : Colors.black12,
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
                                                                  height: 2.h,
                                                                ),
                                                                Container(
                                                                  height: 5.5.h,
                                                                  width: 70.w,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      color:
                                                                          primaryColor),
                                                                  child:
                                                                      InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      if (pickedDate != '' &&
                                                                          pickedEndTime !=
                                                                              '' &&
                                                                          AddressController
                                                                              .text
                                                                              .isNotEmpty &&
                                                                          pickedTime !=
                                                                              '') {
                                                                        Map<String,
                                                                                dynamic>
                                                                            request =
                                                                            {
                                                                          /*    'requested_by_id':
                                                        profileInfo.id
                                                            .toString(), */
                                                                          'requested_to_id': widget
                                                                              .id
                                                                              .toString(),
                                                                          'long':
                                                                              longitude,
                                                                          'lat':
                                                                              latitude,
                                                                          'meet_up_date':
                                                                              pickedDate,
                                                                          'meet_up_time':
                                                                              pickedTimeApi,
                                                                          'meetup_end_time':
                                                                              pickedEndTimeApi
                                                                        };
                                                                        print(
                                                                            request);
                                                                        bool status = await DataApiService.instance.sendRequest(
                                                                            request,
                                                                            context);

                                                                        Navigator.pop(
                                                                            context);
                                                                        callApi();

                                                                        if (status) {
                                                                          Fluttertoast.showToast(
                                                                              msg: SnackMessage.toString(),
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 1,
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0);
                                                                        } else {
                                                                          Fluttertoast.showToast(
                                                                              msg: SnackMessage.toString(),
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 1,
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0);
                                                                        }
                                                                      }
                                                                    },
                                                                    child: Center(
                                                                        child: Text(
                                                                            "Send Request",
                                                                            style:
                                                                                TextStyle(fontSize: 2.1.h, color: Colors.white))),
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
                                                    color:
                                                        Colors.deepPurpleAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Center(
                                                    child: const Text(
                                                        'Send Request',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors
                                                                .white)))),
                                          ),
                                        ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
