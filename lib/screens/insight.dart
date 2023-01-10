import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:co_op/models/InsightModel.dart';
import 'package:co_op/screens/workout/workout_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';

import '../bottom_navigation_bar.dart';

class Insight extends StatefulWidget {
  const Insight({Key? key}) : super(key: key);

  @override
  State<Insight> createState() => _InsightState();
}

class _InsightState extends State<Insight> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(index: 2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "History",
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: Column(
        children: const [Expanded(child: TabBarViewWidget())],
      ),
    );
  }
}

class TabBarViewWidget extends StatefulWidget {
  const TabBarViewWidget({super.key});

  @override
  State<TabBarViewWidget> createState() => _TabBarViewWidgetState();
}

class _TabBarViewWidgetState extends State<TabBarViewWidget> {
  List<String> userName = [
    'Simran',
    'Rani',
    'Deepika',
  ];

  List<String> images = [
    'assets/images/intro1.png',
    'assets/images/intro1.png',
    'assets/images/intro1.png',
  ];
  List<InsightModel> yogaUsers = [];
  List<InsightModel> sportsUsers = [];
  List<InsightModel> weightListUsers = [];
  List<InsightModel> cardioUsers = [];
  String? selectedDate;
  DateTime select = DateTime.now();
  bool loader = false;

  callApi() async {
    setState(() {
      loader = true;
    });
    await DataApiService.instance
        .getInsightList(selectedDate.toString(), context);
    print('length');
    print(insightList.length);
    if (insightList.isNotEmpty) {
      print(insightList[0].userData.length);
      for (var i = 0; i < insightList.length; i++) {
        for (var j = 0; j < insightList[i].userData.length; j++) {
          if (insightList[i].userData[j].filterId == 1) {
            print('object');
            if (yogaUsers.contains(insightList[i]) == false) {
              yogaUsers.add(insightList[i]);
            }
          } else if (insightList[i].userData[j].filterId == 2) {
            if (sportsUsers.contains(insightList[i]) == false) {
              print('filterid');
              sportsUsers.add(insightList[i]);
            }
          } else if (insightList[i].userData[j].filterId == 3) {
            if (weightListUsers.contains(insightList[i]) == false) {
              weightListUsers.add(insightList[i]);
            }
          } else if (insightList[i].userData[j].filterId == 4) {
            if (cardioUsers.contains(insightList[i]) == false) {
              cardioUsers.add(insightList[i]);
            }
          }
        }
      }
    }

    print('second');
    print(yogaUsers.length);
    print(sportsUsers.length);
    print(weightListUsers.length);
    print(cardioUsers.length);
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final s = DateFormat("yyyy-MM-dd");
    selectedDate = s.format(DateTime.now());

    callApi();
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
      child: loader
          ? Center(
              child: pageSpinkit,
            )
          : DefaultTabController(
              initialIndex: 0,
              length: 4,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  preferredSize:
                      Size.fromHeight(170), // here the desired height
                  child: AppBar(
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    flexibleSpace: /*  CalendarTimeline(
                initialDate: DateTime(2020, 4, 20),
                firstDate: DateTime(2019, 1, 15),
                lastDate: DateTime(2020, 11, 20),
                onDateSelected: (date) => print(date),
                leftMargin: 20,
                monthColor: Colors.blueGrey,
                dayColor: Colors.black,
                activeDayColor: Colors.white,
                activeBackgroundDayColor: secondaryColor,
                dotsColor: Colors.white,
                selectableDayPredicate: (date) => date.day != 23,
                locale: 'en_ISO',
              ), */
                        HorizontalCalendar(
                            date: select,
                            initialDate: DateTime(2000, 9, 7),
                            textColor: Colors.black45,
                            backgroundColor: Colors.white,
                            selectedColor: secondaryColor,
                            onDateSelected: (date) async {
                              final s = DateFormat("yyyy-MM-dd");
                              select = s.parse(date);
                              selectedDate = date;
                              yogaUsers.clear();
                              sportsUsers.clear();
                              cardioUsers.clear();
                              weightListUsers.clear();
                              await callApi();
                              setState(() {});
                            }),
                    /* EventCalendar(
                /*     emptyText: '',
                headerMonthStringType: HeaderMonthStringTypes.Full,
                headerWeekDayStringType: HeaderWeekDayStringTypes.Short,
                dayEventCountViewType: DayEventCountViewType.LABEL,
                dayEventCountTextColor: Colors.white,
                dayEventCountColor: primaryColor,
                dayIndexSelectedBackgroundColor: primaryColor,
                calendarType: CalendarType.Gregorian,
                calendarLanguage: 'en',
                viewType: CalendarViewType.Daily,
                canSelectViewType: false, */
                calendarType: CalendarType.GREGORIAN,
                calendarLanguage: 'en',
                onChangeDateTime: (datetime) {
                  print(datetime);
                },
                calendarOptions: CalendarOptions(
                  toggleViewType: false,
                  viewType: ViewType.DAILY,
                ),
                showEvents: false,

                /*  events: [
                  Event(
                    child: const Text('Laravel Event'),
                    dateTime: CalendarDateTime(
                      year: 1401,
                      month: 5,
                      day: 12,
                      calendarType: CalendarType.JALALI,
                    ),
                  ),

                  /*
                  Event(
                    title: "",
                    description: '',
                    dateTime: '2022-11-19 20:00',
                  ),
                  Event(
                    title: "",
                    description: '',
                    dateTime: '2022-11-19 20:00',
                  ), */
                ], */
              ), */

                    // CalendarTimeline(
                    //   initialDate: DateTime.now(),
                    //   firstDate: DateTime(2019, 1, 15),
                    //   lastDate: DateTime.now().add(Duration(days: 60)),
                    //   onDateSelected: (date) => print(date),
                    //   leftMargin: 60,
                    //   monthColor: Colors.white,
                    //   dayColor: Colors.black,
                    //   activeDayColor: Colors.white,
                    //   activeBackgroundDayColor: secondaryColor,
                    //   dotsColor: const Color(0xFF333A47),
                    //   selectableDayPredicate: (date) => date.day != 23,
                    //   locale: 'en_ISO',
                    // ),
                    bottom: TabBar(
                      indicatorColor: primaryColor,
                      indicatorWeight: 5.0,
                      labelColor: primaryColor,
                      labelPadding: EdgeInsets.only(top: 10.0),
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: 'Yoga',
                          icon: Image.asset(
                            "assets/icons/yoga.png",
                            height: 30,
                          ),
                          iconMargin: EdgeInsets.only(bottom: 4.0),
                        ),
                        //child: Image.asset('images/android.png'),
                        Tab(
                          text: 'Sports',
                          icon: Image.asset(
                            "assets/icons/sports.png",
                            height: 30,
                          ),
                          iconMargin: EdgeInsets.only(bottom: 4.0),
                        ),
                        Tab(
                          text: 'Cardio',
                          icon: Image.asset(
                            "assets/icons/cardio.png",
                            height: 38,
                          ),
                          iconMargin: EdgeInsets.only(bottom: 0.0),
                        ),
                        Tab(
                          text: 'Weightlift',
                          icon: Image.asset(
                            "assets/icons/weightlifting.png",
                            height: 30,
                          ),
                          iconMargin: EdgeInsets.only(bottom: 4.0),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    yogaUsers.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                child: emptyAnimation,
                              ),
                              Text('No Users Found!')
                            ],
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: yogaUsers.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return yogaUsers[index]
                                      .inProgress ==
                                      1 &&
                                      yogaUsers[index].completed ==
                                          0
                                      ?SizedBox(): InkWell(
                                    onTap: () {
                                      yogaUsers[index].requestedByUser[0].id ==
                                              profileInfo.id
                                          ? Get.to(() => WorkoutDetail(
                                              yogaUsers[index]
                                                  .requestedToId
                                                  .toString()))
                                          : Get.to(() => WorkoutDetail(
                                              yogaUsers[index]
                                                  .requestedById
                                                  .toString()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: ClipRRect(
                                        child: Banner(
                                          textStyle: TextStyle(fontSize: 10),
                                          message: /*yogaUsers[index]
                                                          .inProgress ==
                                                      1 &&
                                                  yogaUsers[index].completed ==
                                                      0
                                              ? 'In Progress'
                                              :*/ yogaUsers[index].status == 2
                                                  ? 'Declined'
                                                  : yogaUsers[index]
                                                              .completed ==
                                                          1
                                                      ? 'Completed'
                                                      : yogaUsers[index]
                                                                  .status ==
                                                              0
                                                          ? 'Pending'
                                                          : 'Accepted',
                                          color: yogaUsers[index].status == 0
                                              ? Colors.green
                                              : secondaryColor,
                                          location: BannerLocation.topEnd,
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
                                                            BorderRadius
                                                                .circular(20),
                                                        child: yogaUsers[index]
                                                                    .requestedByUser[
                                                                        0]
                                                                    .id ==
                                                                profileInfo.id
                                                            ? CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 22.h,
                                                                width: double
                                                                    .infinity,
                                                                imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                    yogaUsers[
                                                                            index]
                                                                        .requestedToUser[
                                                                            0]
                                                                        .image
                                                                        .toString(),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Image.asset(
                                                                  images[0],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  images[0],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                ),
                                                              )
                                                            : CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 22.h,
                                                                width: double
                                                                    .infinity,
                                                                imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                    yogaUsers[
                                                                            index]
                                                                        .requestedByUser[
                                                                            0]
                                                                        .image
                                                                        .toString(),
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Image.asset(
                                                                  images[0],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  images[0],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                ),
                                                              )),
                                                    Opacity(
                                                      opacity: 0.4,
                                                      child: Container(
                                                        height: 22.h,
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
                                                            yogaUsers[index]
                                                                        .requestedByUser[
                                                                            0]
                                                                        .id ==
                                                                    profileInfo
                                                                        .id
                                                                ? yogaUsers[
                                                                        index]
                                                                    .requestedToUser[
                                                                        0]
                                                                    .userName
                                                                : yogaUsers[
                                                                        index]
                                                                    .requestedByUser[
                                                                        0]
                                                                    .userName,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                DateFormat(
                                                                        "h:mma")
                                                                    .format(DateTime.parse(
                                                                        '2022-12-02 ' +
                                                                            yogaUsers[index].meetUpTime)),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                        "h:mma")
                                                                    .format(DateTime.parse(
                                                                        '2022-12-02 ' +
                                                                            yogaUsers[index].meetupEndTime)),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ],
                                                          ),

                                                          const SizedBox(
                                                            height: 10,
                                                          ),

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
                                  );
                                },
                              ),
                            ),
                          ),
                    sportsUsers.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                child: emptyAnimation,
                              ),
                              Text('No Users Found!')
                            ],
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: sportsUsers.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return sportsUsers[index]
                                      .inProgress ==
                                      1 &&
                                      sportsUsers[index]
                                          .completed ==
                                          0
                                      ?SizedBox(): Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {});
                                        sportsUsers[index].requestedByUser[0].id ==
                                            profileInfo.id
                                            ? Get.to(() => WorkoutDetail(
                                            sportsUsers[index]
                                                .requestedToId
                                                .toString()))
                                            : Get.to(() => WorkoutDetail(
                                            sportsUsers[index]
                                                .requestedById
                                                .toString()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: ClipRRect(
                                          child: Banner(
                                            textStyle: TextStyle(fontSize: 10),
                                            message: /*sportsUsers[index]
                                                            .inProgress ==
                                                        1 &&
                                                    sportsUsers[index]
                                                            .completed ==
                                                        0
                                                ? 'In Progress'
                                                :*/ sportsUsers[index].status == 2
                                                    ? 'Declined'
                                                    : sportsUsers[index]
                                                                .completed ==
                                                            1
                                                        ? 'Completed'
                                                        : sportsUsers[index]
                                                                    .status ==
                                                                0
                                                            ? 'Pending'
                                                            : 'Accepted',
                                            color:
                                                sportsUsers[index].status == 0
                                                    ? Colors.green
                                                    : secondaryColor,
                                            location: BannerLocation.topEnd,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: sportsUsers[
                                                                          index]
                                                                      .requestedByUser[
                                                                          0]
                                                                      .id ==
                                                                  profileInfo.id
                                                              ? CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                  imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                      sportsUsers[
                                                                              index]
                                                                          .requestedToUser[
                                                                              0]
                                                                          .image
                                                                          .toString(),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) => /* Icon(Icons
                                                                        .person) */
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                )
                                                              : CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                  imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                      sportsUsers[
                                                                              index]
                                                                          .requestedByUser[
                                                                              0]
                                                                          .image
                                                                          .toString(),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) => /* Icon(Icons
                                                                        .person) */
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                )),
                                                      Opacity(
                                                        opacity: 0.4,
                                                        child: Container(
                                                          height: 22.h,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
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
                                                              sportsUsers[index]
                                                                          .requestedByUser[
                                                                              0]
                                                                          .id ==
                                                                      profileInfo
                                                                          .id
                                                                  ? sportsUsers[
                                                                          index]
                                                                      .requestedToUser[
                                                                          0]
                                                                      .userName
                                                                  : sportsUsers[
                                                                          index]
                                                                      .requestedByUser[
                                                                          0]
                                                                      .userName,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                            ),

                                                            Row(
                                                              children: [
                                                                Text(
                                                                  DateFormat(
                                                                          "h:mma")
                                                                      .format(DateTime.parse(
                                                                          '2022-12-02 ' +
                                                                              sportsUsers[index].meetUpTime)),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  '-',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Text(
                                                                  DateFormat(
                                                                          "h:mma")
                                                                      .format(DateTime.parse(
                                                                          '2022-12-02 ' +
                                                                              sportsUsers[index].meetupEndTime)),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ],
                                                            ),

                                                            const SizedBox(
                                                              height: 10,
                                                            ),

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
                                  );
                                },
                              ),
                            ),
                          ),
                    cardioUsers.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                child: emptyAnimation,
                              ),
                              Text('No Users Found!')
                            ],
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: cardioUsers.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return cardioUsers[index]
                                      .inProgress ==
                                      1 &&
                                      cardioUsers[index]
                                          .completed ==
                                          0
                                      ?SizedBox(): Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0.0),
                                    child: InkWell(
                                      onTap: () {

                                        cardioUsers[index].requestedByUser[0].id ==
                                            profileInfo.id
                                            ? Get.to(() => WorkoutDetail(
                                            cardioUsers[index]
                                                .requestedToId
                                                .toString()))
                                            : Get.to(() => WorkoutDetail(
                                            cardioUsers[index]
                                                .requestedById
                                                .toString()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: ClipRRect(
                                          child: Banner(
                                            textStyle: TextStyle(fontSize: 10),
                                            message: cardioUsers[index].status == 2
                                                    ? 'Declined'
                                                    : cardioUsers[index]
                                                                .completed ==
                                                            1
                                                        ? 'Completed'
                                                        : cardioUsers[index]
                                                                    .status ==
                                                                0
                                                            ? 'Pending'
                                                            : 'Accepted',
                                            color:
                                                cardioUsers[index].status == 0
                                                    ? Colors.green
                                                    : secondaryColor,
                                            location: BannerLocation.topEnd,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: cardioUsers[
                                                                          index]
                                                                      .requestedByUser[
                                                                          0]
                                                                      .id ==
                                                                  profileInfo.id
                                                              ? CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                  imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                      cardioUsers[
                                                                              index]
                                                                          .requestedToUser[
                                                                              0]
                                                                          .image
                                                                          .toString(),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) => /* Icon(Icons
                                                                        .person) */
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                )
                                                              : CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                  imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                      cardioUsers[
                                                                              index]
                                                                          .requestedByUser[
                                                                              0]
                                                                          .image
                                                                          .toString(),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) => /* Icon(Icons
                                                                        .person) */
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                )),
                                                      Opacity(
                                                        opacity: 0.4,
                                                        child: Container(
                                                          height: 22.h,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
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
                                                              cardioUsers[index]
                                                                          .requestedByUser[
                                                                              0]
                                                                          .id ==
                                                                      profileInfo
                                                                          .id
                                                                  ? cardioUsers[
                                                                          index]
                                                                      .requestedToUser[
                                                                          0]
                                                                      .userName
                                                                  : cardioUsers[
                                                                          index]
                                                                      .requestedByUser[
                                                                          0]
                                                                      .userName,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  DateFormat(
                                                                          "h:mma")
                                                                      .format(DateTime.parse(
                                                                          '2022-12-02 ' +
                                                                              cardioUsers[index].meetUpTime)),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  '-',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Text(
                                                                  DateFormat(
                                                                          "h:mma")
                                                                      .format(DateTime.parse(
                                                                          '2022-12-02 ' +
                                                                              cardioUsers[index].meetupEndTime)),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ],
                                                            ),

                                                            const SizedBox(
                                                              height: 10,
                                                            ),

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
                                  );
                                },
                              ),
                            ),
                          ),
                    weightListUsers.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Center(
                                child: emptyAnimation,
                              ),
                              Text('No Users Found!')
                            ],
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: weightListUsers.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return weightListUsers[index]
                                      .inProgress ==
                                      1 &&
                                      weightListUsers[index]
                                          .completed ==
                                          0?SizedBox(): Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {});
                                        weightListUsers[index].requestedByUser[0].id ==
                                            profileInfo.id
                                            ? Get.to(() => WorkoutDetail(
                                            weightListUsers[index]
                                                .requestedToId
                                                .toString()))
                                            : Get.to(() => WorkoutDetail(
                                            weightListUsers[index]
                                                .requestedById
                                                .toString()));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: ClipRRect(
                                          child: Banner(
                                            textStyle: TextStyle(fontSize: 10),
                                            message:  weightListUsers[index]
                                                            .status ==
                                                        2
                                                    ? 'Declined'
                                                    : weightListUsers[index]
                                                                .completed ==
                                                            1
                                                        ? 'Completed'
                                                        : weightListUsers[
                                                                        index]
                                                                    .status ==
                                                                0
                                                            ? 'Pending'
                                                            : 'Accepted',
                                            color: weightListUsers[index]
                                                        .status ==
                                                    0
                                                ? Colors.green
                                                : secondaryColor,
                                            location: BannerLocation.topEnd,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: weightListUsers[
                                                                          index]
                                                                      .requestedByUser[
                                                                          0]
                                                                      .id ==
                                                                  profileInfo.id
                                                              ? CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                  imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                      weightListUsers[
                                                                              index]
                                                                          .requestedToUser[
                                                                              0]
                                                                          .image
                                                                          .toString(),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) => /* Icon(Icons
                                                                        .person) */
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                )
                                                              : CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 22.h,
                                                                  width: double
                                                                      .infinity,
                                                                  imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                      weightListUsers[
                                                                              index]
                                                                          .requestedByUser[
                                                                              0]
                                                                          .image
                                                                          .toString(),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) => /* Icon(Icons
                                                                        .person) */
                                                                      Image
                                                                          .asset(
                                                                    images[0],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        22.h,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                                )),
                                                      Opacity(
                                                        opacity: 0.4,
                                                        child: Container(
                                                          height: 22.h,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
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
                                                              weightListUsers[
                                                                              index]
                                                                          .requestedByUser[
                                                                              0]
                                                                          .id ==
                                                                      profileInfo
                                                                          .id
                                                                  ? weightListUsers[
                                                                          index]
                                                                      .requestedToUser[
                                                                          0]
                                                                      .userName
                                                                  : weightListUsers[
                                                                          index]
                                                                      .requestedByUser[
                                                                          0]
                                                                      .userName,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  DateFormat(
                                                                          "h:mma")
                                                                      .format(DateTime.parse(
                                                                          '2022-12-02 ' +
                                                                              weightListUsers[index].meetUpTime)),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  '-',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                Text(
                                                                  DateFormat(
                                                                          "h:mma")
                                                                      .format(DateTime.parse(
                                                                          '2022-12-02 ' +
                                                                              weightListUsers[index].meetupEndTime)),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ],
                                                            ),

                                                            const SizedBox(
                                                              height: 10,
                                                            ),

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
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
