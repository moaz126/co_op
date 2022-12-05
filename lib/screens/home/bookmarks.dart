import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/workout/workout_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<String> headline = [
    'Arms Dumbbell',
    'Man Dumbbell',
    'Arms Exercise',
    'Pull up Training'
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
    await DataApiService.instance.getBookmarkList(context);
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
        title: Text("My Bookmarks"),
      ),
      body: loader
          ? Center(
              child: pageSpinkit,
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      itemCount: bookmarkList.length,
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.94,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (c, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => WorkoutDetail(
                                      bookmarkList[index].user.id.toString()));
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: CachedNetworkImage(
                                              height: 45.w,
                                              width: 45.w,
                                              fit: BoxFit.fill,
                                              imageUrl:
                                                  'https://becktesting.site/workout-bud/public/storage/user/' +
                                                      bookmarkList[index]
                                                          .user
                                                          .image
                                                          .toString(),
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                images[0],
                                                fit: BoxFit.cover,
                                                height: 45.w,
                                                width: 45.w,
                                              ),
                                              errorWidget: (context, url,
                                                      error) => /* Icon(Icons
                                    .person) */
                                                  Image.asset(
                                                images[0],
                                                fit: BoxFit.cover,
                                                height: 45.w,
                                                width: 45.w,
                                              ),
                                            ),
                                          ),
                                          Opacity(
                                            opacity: 0.4,
                                            child: Container(
                                              height: 45.w,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bookmarkList[index]
                                                      .user
                                                      .userName
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        /*  Text(
                                                          '10Min',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          width: 2,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ), */
                                                        Text(
                                                          bookmarkList[index]
                                                                      .user
                                                                      .activityLevel ==
                                                                  'null'
                                                              ? 'Beginner'
                                                              : bookmarkList[
                                                                      index]
                                                                  .user
                                                                  .activityLevel,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    // Icon(Icons.bookmark, color: Colors.white,)
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
                            ),
                          ),
                        );
                      }),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     scrollDirection: Axis.vertical,
                //     itemCount: images.length,
                //     padding: EdgeInsets.only(bottom: 80),
                //     itemBuilder: (context, index) {
                //       return Padding(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 16.0, vertical: 8.0),
                //         child: InkWell(
                //           onTap: () {
                //             setState(() {});
                //           },
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Container(
                //                 decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(20),
                //                   boxShadow: [
                //                     BoxShadow(
                //                       color: Colors.grey.withOpacity(0.5),
                //                       spreadRadius: 2,
                //                       blurRadius: 3,
                //                       offset:
                //                           Offset(0, 3), // changes position of shadow
                //                     ),
                //                   ],
                //                 ),
                //                 child: Row(
                //                   children: [
                //                     ClipRRect(
                //                       borderRadius: BorderRadius.only(
                //                           bottomLeft: Radius.circular(20),
                //                           topLeft: Radius.circular(20)),
                //                       child: Image.asset(
                //                         images[index],
                //                         fit: BoxFit.cover,
                //                         height: 12.h,
                //                         width: 12.h,
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 8.0),
                //                       child: Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                //                           Text(headline[index],
                //                               style: Theme.of(context)
                //                                   .textTheme
                //                                   .bodyText2),
                //                           SizedBox(
                //                             height: 5,
                //                           ),
                //                           SizedBox(
                //                               width: 60.w,
                //                               child: Text(description[index],
                //                                   style:
                //                                       TextStyle(color: Colors.grey)))
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //               // Text(goal[1], style: TextStyle(color: Colors.black, fontSize: 14, ),),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
    );
  }
}
