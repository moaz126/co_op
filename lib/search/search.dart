import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/screens/workout/workout_detail_page.dart';

import '../bottom_navigation_bar.dart';
import '../constants/constants.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> userName = ['Jack', 'Shane', 'Alex Hales', 'Johnson'];
  List<double> ratings = [5.0, 4.0, 3.5, 2.5];
  List<String> images = [
    'assets/images/stretching.jpg',
    'assets/images/weight.jpg',
    'assets/images/weight.jpg',
    'assets/images/muscles.webp',
  ];
  late final _ratingController;
  late double _rating;

  double _userRating = 0.0;
  double _initialRating = 5.0;

  IconData? _selectedIcon;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavBar(index: 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.sports_gymnastics),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Discover",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
            InkWell(onTap: () {}, child: Icon(Icons.search)),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 4, 28, 4),
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
                  },
                  child: Container(
                    height: 5.h,
                    width: 28.w,
                    decoration: BoxDecoration(
                        color:
                            selectedIndex == 0 ? primaryColor : Colors.black12,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: primaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Beginner",
                            style: TextStyle(
                                color: selectedIndex == 0
                                    ? Colors.white
                                    : primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    height: 5.h,
                    width: 28.w,
                    decoration: BoxDecoration(
                        color:
                            selectedIndex == 1 ? primaryColor : Colors.black12,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: primaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Intermediate",
                          style: TextStyle(
                              color: selectedIndex == 1
                                  ? Colors.white
                                  : primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Container(
                    height: 5.h,
                    width: 28.w,
                    decoration: BoxDecoration(
                        color:
                            selectedIndex == 2 ? primaryColor : Colors.black12,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: primaryColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Advanced",
                          style: TextStyle(
                              color: selectedIndex == 2
                                  ? Colors.white
                                  : primaryColor,
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
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {});
                      Get.to(WorkoutDetail('1'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(alignment: Alignment.bottomCenter, children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.cover,
                                height: 12.h,
                                width: double.infinity,
                              ),
                            ),
                            Opacity(
                              opacity: 0.4,
                              child: Container(
                                height: 12.h,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              RatingBar(
                                                  initialRating: ratings[index],
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 24,
                                                  ratingWidget: RatingWidget(
                                                      full: const Icon(
                                                          Icons.star,
                                                          color:
                                                              secondaryColor),
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
                                              Container(
                                                width: 30,
                                                height: 30,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  ratings.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.bookmark_border,
                                        color: Colors.white,
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
        ],
      ),
    );
  }
}
