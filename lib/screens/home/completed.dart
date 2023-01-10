import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_op/screens/workout/workout_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';

import '../../api/auth_workout_bud.dart';
import '../../api/global_variables.dart';
import '../../constants/noInternet.dart';

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  int selectedIndex = 0;
  List<String> userName = ['Jack', 'Shane', 'Alex Hales', 'Johnson'];
  List<double> ratings = [5.0, 4.0, 3.5, 2.5];
  List<String> images = [
    'assets/images/stretching.jpg',
    'assets/images/weight.jpg',
    'assets/images/weight.jpg',
    'assets/images/muscles.webp',
  ];



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


  bool loader = false;

  callApi() async {
    setState(() {
      loader = true;
    });
    await DataApiService.instance.getComplete(context);
    setState(() {
      loader = false;
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                child: Icon(Icons.arrow_back),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text('Finished'),
          ],
        ),
      ),
      body: loader
          ? Center(child: pageSpinkit)
          : connected == false
              ? NoInternet(
                  page: Completed(),
                )
              : SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: _pullRefresh,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        completedList.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    height: 20.h,
                                    child: emptyAnimation,
                                  ),
                                  Text('No Requests Found')
                                ],
                              )
                            : ListView.builder(
                                itemCount: completedList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(() => WorkoutDetail(
                                                  completedList[index]
                                                      .id
                                                      .toString()));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child:
                                                              CachedNetworkImage(
                                                            height: 12.h,
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                            imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                completedList[
                                                                        index]
                                                                    .image
                                                                    .toString(),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              images[0],
                                                              fit: BoxFit.cover,
                                                              height: 12.h,
                                                              width: double
                                                                  .infinity,
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) => /* Icon(Icons
                                                                    .person) */
                                                                Image.asset(
                                                              images[0],
                                                              fit: BoxFit.cover,
                                                              height: 12.h,
                                                              width: double
                                                                  .infinity,
                                                            ),
                                                          ),
                                                        ),
                                                        Opacity(
                                                          opacity: 0.4,
                                                          child: Container(
                                                            height: 12.h,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      18.0,
                                                                  vertical: 8),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                completedList[
                                                                        index]
                                                                    .userName,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        22),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'Workout time ' +
                                                                        completedList[index].duration.replaceAll(
                                                                            'after',
                                                                            ''),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            18),
                                                                  ),
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
