import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_op/constants/custom_dialog.dart';
import 'package:co_op/constants/widgets.dart';
import 'package:co_op/screens/workout/navigate.dart';
import 'package:co_op/screens/workout/workout_detail_page.dart';
import 'package:co_op/search/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart' as form;
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
import 'package:co_op/bottom_navigation_bar.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/home/bookmarks.dart';
import 'package:co_op/screens/home/notification.dart';

import '../../api/auth_workout_bud.dart';
import '../../api/global_variables.dart';
import '../../constants/noInternet.dart';
import '../../provider/dark_theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<String> userName = ['Jack', 'Shane', 'Alex Hales', 'Johnson'];
  List<double> ratings = [5.0, 4.0, 3.5, 2.5];
  List<String> images = [
    'assets/images/stretching.jpg',
    'assets/images/weight.jpg',
    'assets/images/weight.jpg',
    'assets/images/muscles.webp',
  ];
/*   DateTime combine() {
    final f = form.DateFormat("dd:mm:yyyy");
    setState(() {
      String pickedDate = date.toString().split(' ')[0];
    });
    TimeOfDay t;
    final now = new DateTime.now();
    return new DateTime(now.year, now.month, now.day, t.hour, t.minute);
  } */

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

  double _userRating = 0.0;
  final double _initialRating = 5.0;
  /*  void showPlacePicker() async {
    LocationResult? result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyBDOMNCVC2eacCxKYuRxIwCz4w-QjV_l5Y",
              defaultLocation: LatLng(31.432354, 73.121249),
            )));

    // Handle the result in your way
    print(result);
  } */
  bool loader = false;
  callApi() async {
    setState(() {
      loader = true;
    });
    await DataApiService.instance.getDashboard(context);
    await DataApiService.instance.getActivityUsers('Beginner', context);
    await DataApiService.instance.getNotification(context);
    setState(() {
      loader = false;
    });
  }

  bool activityLoader = false;
  callActivityApi(String level) async {
    setState(() {
      activityLoader = true;
    });
    await DataApiService.instance.getActivityUsers(level, context);
    setState(() {
      activityLoader = false;
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed(context);
        if (result == null) {
          result = false;
        }
        return result;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(index: 0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: 4.h,
                  child: Image.asset(
                    "assets/icons/logo.png",
                    height: 2.h,
                    fit: BoxFit.fill,
                  )),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {});
                        Get.to(() => const NotificationPage());
                      },
                      child: Stack(
                        children: [
                          Icon(
                            Icons.notifications_none_outlined,
                            color: secondaryColor,
                          ),
                          notificationCount != 0
                              ? Positioned(
                                  right: 0,
                                  child: Container(
                                    height: 12,
                                    width: 12,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      notificationCount.toString(),
                                      style: TextStyle(fontSize: 7),
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      )),
                  // InkWell(
                  //     onTap: (){
                  //       setState(() {});
                  //       Get.to(()=>const BookmarksPage());
                  //     },
                  //     child: const Icon(Icons.bookmark_border, color: secondaryColor,))
                ],
              )
            ],
          ),
        ),
        body: loader
            ? Center(child: pageSpinkit)
            : connected == false
                ? NoInternet(
                    page: HomePage(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Row(
                            children: [
                              Text(
                                "Welcome, " + profileInfo.userName.toString(),
                                style: Theme.of(context).textTheme.headline3,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 37.h,
                          // width: 15.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dashbarodUsersList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => WorkoutDetail(
                                        dashbarodUsersList[index]
                                            .id
                                            .toString()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  height: 34.h,
                                                  width: 70.w,
                                                  fit: BoxFit.fill,
                                                  imageUrl:
                                                      'https://becktesting.site/workout-bud/public/storage/user/' +
                                                          dashbarodUsersList[
                                                                  index]
                                                              .image
                                                              .toString(),
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                    images[0],
                                                    fit: BoxFit.cover,
                                                    height: 34.h,
                                                    width: 70.w,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) => /* Icon(Icons
                              .person) */
                                                      Image.asset(
                                                    images[0],
                                                    fit: BoxFit.cover,
                                                    height: 34.h,
                                                    width: 70.w,
                                                  ),
                                                ),
                                              ),
                                              Opacity(
                                                opacity: 0.4,
                                                child: Container(
                                                  height: 34.h,
                                                  width: 70.w,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dashbarodUsersList[index]
                                                          .userName,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            AbsorbPointer(
                                                              absorbing: true,
                                                              child: RatingBar(
                                                                  tapOnlyMode:
                                                                      false,
                                                                  updateOnDrag:
                                                                      false,
                                                                  initialRating: dashbarodUsersList[index].avg ==
                                                                          null
                                                                      ? 0.0
                                                                      : dashbarodUsersList[
                                                                              index]
                                                                          .avg
                                                                          .toDouble()
                                                                  /*  ratings[
                                                                          index] */
                                                                  ,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  allowHalfRating:
                                                                      true,
                                                                  itemCount: 5,
                                                                  itemSize: 24,
                                                                  ratingWidget:
                                                                      RatingWidget(
                                                                          full: const Icon(Icons.star,
                                                                              color:
                                                                                  secondaryColor),
                                                                          half:
                                                                              const Icon(
                                                                            Icons.star_half,
                                                                            color:
                                                                                secondaryColor,
                                                                          ),
                                                                          empty:
                                                                              const Icon(
                                                                            Icons.star_outline,
                                                                            color:
                                                                                secondaryColor,
                                                                          )),
                                                                  onRatingUpdate:
                                                                      (value) {}),
                                                            ),
                                                            Container(
                                                              width: 30,
                                                              height: 30,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                dashbarodUsersList[index]
                                                                            .avg ==
                                                                        null
                                                                    ? '0.0'
                                                                    : dashbarodUsersList[
                                                                            index]
                                                                        .avg
                                                                        .toString()
                                                                /*   ratings[index]
                                                                    .toString() */
                                                                ,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        dashbarodUsersList[
                                                                        index]
                                                                    .bookmark ==
                                                                0
                                                            ? InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    DataApiService
                                                                        .instance
                                                                        .addBookmark(
                                                                            dashbarodUsersList[index].id.toString(),
                                                                            context);
                                                                    dashbarodUsersList[
                                                                            index]
                                                                        .bookmark = 1;
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 20,
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .bookmark_border,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    DataApiService
                                                                        .instance
                                                                        .deleteBookmark(
                                                                            dashbarodUsersList[index].id.toString(),
                                                                            context);
                                                                    dashbarodUsersList[
                                                                            index]
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
                                            ]),
                                        // Text(goal[1], style: TextStyle(color: Colors.black, fontSize: 14, ),),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Workout Levels",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              InkWell(
                                onTap: () async {
                                  final s = form.DateFormat("HH:mm");
                                  String st = s.format(DateTime.now());
                                  DateTime dateTime = s.parse(st);
                                },
                                child: Text(
                                  "See All",
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 28, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 0;
                                  });
                                  callActivityApi('Beginner');
                                  setState(() {});
                                },
                                child: Container(
                                  height: 5.h,
                                  width: 28.w,
                                  decoration: BoxDecoration(
                                      color: selectedIndex == 0
                                          ? secondaryColor
                                          : Colors.black12,
                                      borderRadius: BorderRadius.circular(40),
                                      border:
                                          Border.all(color: secondaryColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Beginner",
                                          style: TextStyle(
                                              color: selectedIndex == 0
                                                  ? Colors.white
                                                  : secondaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 1;
                                  });
                                  callActivityApi('Intermediate');
                                  setState(() {});
                                },
                                child: Container(
                                  height: 5.h,
                                  width: 28.w,
                                  decoration: BoxDecoration(
                                      color: selectedIndex == 1
                                          ? secondaryColor
                                          : Colors.black12,
                                      borderRadius: BorderRadius.circular(40),
                                      border:
                                          Border.all(color: secondaryColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Intermediate",
                                        style: TextStyle(
                                            color: selectedIndex == 1
                                                ? Colors.white
                                                : secondaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 2;
                                  });
                                  callActivityApi('Advanced');
                                  setState(() {});
                                },
                                child: Container(
                                  height: 5.h,
                                  width: 28.w,
                                  decoration: BoxDecoration(
                                      color: selectedIndex == 2
                                          ? secondaryColor
                                          : Colors.black12,
                                      borderRadius: BorderRadius.circular(40),
                                      border:
                                          Border.all(color: secondaryColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Advanced",
                                        style: TextStyle(
                                            color: selectedIndex == 2
                                                ? Colors.white
                                                : secondaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        activityLoader
                            ? Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Center(child: pageSpinkit),
                              )
                            : ListView.builder(
                                itemCount: activityUsers.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => WorkoutDetail(
                                            activityUsers[index]
                                                .id
                                                .toString()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: CachedNetworkImage(
                                                      height: 12.h,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          'https://becktesting.site/workout-bud/public/storage/user/' +
                                                              activityUsers[
                                                                      index]
                                                                  .image
                                                                  .toString(),
                                                      placeholder:
                                                          (context, url) =>
                                                              Image.asset(
                                                        images[0],
                                                        fit: BoxFit.cover,
                                                        height: 12.h,
                                                        width: double.infinity,
                                                      ),
                                                      errorWidget: (context,
                                                              url,
                                                              error) => /* Icon(Icons
                              .person) */
                                                          Image.asset(
                                                        images[0],
                                                        fit: BoxFit.cover,
                                                        height: 12.h,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                  ),
                                                  Opacity(
                                                    opacity: 0.4,
                                                    child: Container(
                                                      height: 12.h,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 18.0,
                                                        vertical: 8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          activityUsers[index]
                                                              .userName,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22),
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
                                                                          tapOnlyMode: false,
                                                                          updateOnDrag: false,
                                                                          initialRating: activityUsers[index].avg == null ? 0.0 : activityUsers[index].avg.toDouble()

                                                                          /*   ratings[
                                                                                  index] */
                                                                          ,
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
                                                                          onRatingUpdate: (value) {}),
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
                                                                        activityUsers[index].avg ==
                                                                                null
                                                                            ? '0.0'
                                                                            : activityUsers[index].avg.toString()
                                                                        /*  ratings[index]
                                                                            .toString() */
                                                                        ,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
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
                                                            activityUsers[index]
                                                                        .bookmark ==
                                                                    0
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        DataApiService.instance.addBookmark(
                                                                            activityUsers[index].id.toString(),
                                                                            context);
                                                                        activityUsers[index]
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
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        DataApiService.instance.deleteBookmark(
                                                                            activityUsers[index].id.toString(),
                                                                            context);
                                                                        activityUsers[index]
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
                                                ]),
                                            // Text(goal[1], style: TextStyle(color: Colors.black, fontSize: 14, ),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class ImagesModel {
  ImagesModel({
    required this.goal,
    required this.image,
  });

  String goal;
  String image;

  factory ImagesModel.fromJson(Map<String, dynamic> json) => ImagesModel(
        goal: json["goal"],
        image: json["instructions"],
      );
}
