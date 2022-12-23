import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/workout/workout_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> headline = [
    'Congratulations',
    'New Workout is Available!',
    'New Features are Available!',
    'Verification Successful'
  ];
  List<String> description = [
    'You have been exercising for 2 hours',
    'Check now and practice',
    'You can nw set exercise reminder',
    'Account verification complete'
  ];
  List<String> images = [
    'assets/images/stretching.jpg',
    'assets/images/weight.jpg',
    'assets/images/weight.jpg',
    'assets/images/muscles.webp',
  ];
  bool loader = false;

  callApi() async {
    setState(() {
      loader = true;
    });
    await DataApiService.instance.getNotification(context);

    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: loader
          ? Center(child: pageSpinkit)
          : Column(
              children: [
                Expanded(
                  child: notificationList.isEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Center(
                              child: emptyAnimation,
                            ),
                            Text('No Notifications yet')
                          ],
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: notificationList.length,
                          padding: EdgeInsets.only(bottom: 80),
                          itemBuilder: (context, index) {
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
                                        setState(() {});
                                        Get.to(() => WorkoutDetail(
                                            notificationList[index]
                                                        .requestedById ==
                                                    profileInfo.id
                                                ? notificationList[index]
                                                    .requestedToId
                                                    .toString()
                                                : notificationList[index]
                                                    .requestedById
                                                    .toString()));
                                        // if (notificationList[index]
                                        //         .title
                                        //         .toUpperCase() ==
                                        //     'YOU HAVE A NEW NOTIFICATION') {
                                        //   Get.to(() => WorkoutDetail(
                                        //       notificationList[index]
                                        //           .requestedById
                                        //           .toString()));
                                        // } else if (notificationList[index]
                                        //         .title
                                        //         .toUpperCase() ==
                                        //     ' ACCEPT YOUR REQUEST ') {
                                        //   Get.to(() => WorkoutDetail(
                                        //       notificationList[index]
                                        //           .requestedById
                                        //           .toString()));
                                        // }
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
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topLeft:
                                                              Radius.circular(
                                                                  20)),
                                                  child: notificationList[index].requestedByUser[0].id==profileInfo.id
                                                      ? CachedNetworkImage(
                                                          height: 12.h,
                                                          width: 12.h,
                                                          fit: BoxFit.cover,
                                                          imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                              notificationList[
                                                                      index]
                                                                  .requestedToUser[
                                                                      0]
                                                                  .image
                                                                  .toString(),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            'assets/images/stretching.jpg',
                                                            fit: BoxFit.cover,
                                                            height: 12.h,
                                                            width: 12.h,
                                                          ),
                                                          errorWidget: (context,
                                                                  url,
                                                                  error) => /* Icon(Icons
                                    .person) */
                                                              Image.asset(
                                                            'assets/images/stretching.jpg',
                                                            fit: BoxFit.cover,
                                                            height: 7.h,
                                                            width: 7.h,
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          height: 12.h,
                                                          width: 12.h,
                                                          fit: BoxFit.cover,
                                                          imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                              notificationList[
                                                                      index]
                                                                  .requestedByUser[
                                                                      0]
                                                                  .image
                                                                  .toString(),
                                                          placeholder:
                                                              (context, url) =>
                                                                  Image.asset(
                                                            'assets/images/stretching.jpg',
                                                            fit: BoxFit.cover,
                                                            height: 12.h,
                                                            width: 12.h,
                                                          ),
                                                          errorWidget: (context,
                                                                  url,
                                                                  error) => /* Icon(Icons
                                    .person) */
                                                              Image.asset(
                                                            'assets/images/stretching.jpg',
                                                            fit: BoxFit.cover,
                                                            height: 7.h,
                                                            width: 7.h,
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
                                                          notificationList[
                                                                  index]
                                                              .title,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      SizedBox(
                                                          width: 60.w,
                                                          child: Text(
                                                              notificationList[
                                                                      index]
                                                                  .description,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)))
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
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
