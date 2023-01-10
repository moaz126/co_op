import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/workout/workout_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as form;
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../provider/dark_theme_provider.dart';

class Clock extends StatefulWidget {
  final String requestId;
  final String requestedToid;

  Clock(this.requestId, this.requestedToid);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  int _duration = 500;
  int _initDuration = 0;
  final CountDownController _controller = CountDownController();
  final nextDeadline = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Duration? timerDifference;

  double rate = 0.0;

  DateTime getNextDeadline(DateTime now) {
    final todaysDeadline = DateTime(now.year, now.month, now.day, 16, 30);

    if (now.isBefore(todaysDeadline)) {
      return todaysDeadline;
    }

    return todaysDeadline.add(Duration(seconds: 10));
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";

    return result;
  }

  int timerleft = 100;

  void _startCountDown() {
    String st = form.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    print(getrequest.meetUpTime);
    DateTime startDate = form.DateFormat("yyyy-MM-dd HH:mm:ss").parse(st);
    DateTime endDate = form.DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(getrequest.meetUpDate.toString() + ' ' + getrequest.meetUpTime);
    print('start');
    print(startDate);
    print(endDate);

// Get the Duration using the diferrence method

    Duration dif = endDate.difference(startDate);

// Print the result in any format you want
    print(dif.toString()); // 12:00:00.000000
    print(dif.inSeconds);
    timerleft = dif.inSeconds;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerleft > 0) {
        setState(() {
          timerleft--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  timeDifference() {
    Duration initDif = DateTime.now().difference(startTime);
    // Duration dif = endTime.difference(DateTime.now());
    Duration dif = endTime.difference(startTime);
    _initDuration = initDif.inSeconds;
    _duration = dif.inSeconds;
    print('inital duration');
    print(_initDuration);
    print('duration');
    print(_duration);
    if (_duration < 0||_initDuration>_duration) {
      DataApiService.instance
          .completeRequest(users.requestId.toString(), context);
    }
  }

  bool loader = false;

  callApi() async {
    setState(() {
      loader = true;
    });
    await DataApiService.instance.getRequest(widget.requestId, context);
    startTime = form.DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(getrequest.meetUpDate.toString() + ' ' + getrequest.meetUpTime);
    endTime = form.DateFormat("yyyy-MM-dd HH:mm:ss").parse(
        getrequest.meetUpDate.toString() + ' ' + getrequest.meetupEndTime);

    _startCountDown();
    timeDifference();
    setState(() {
      loader = false;
    });
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
          title: Text('Get Ready!'),
          leading: InkWell(
              onTap: () {
                if (_duration < 0||_initDuration>_duration) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              WorkoutDetail(users.userData!.id.toString())));
                } else {
                  Get.back();
                }
              },
              child: Icon(Icons.arrow_back)),
        ),
        body: loader
            ? Center(child: pageSpinkit)
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: 2,
                  ),
                  _duration < 0 || _initDuration>_duration
                      ? Column(
                          children: [
                            timeend,
                            Center(
                              child: Text(
                                'Your time is over!',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                      : timerleft == 0 || timerleft < 0
                          ? Center(
                              child: CircularCountDownTimer(
                                duration: _duration,
                                initialDuration: _initDuration,
                                controller: _controller,
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 2,
                                ringColor: Colors.grey[300]!,
                                ringGradient: null,
                                fillColor: Colors.purpleAccent[100]!,
                                fillGradient: null,
                                backgroundColor: Colors.purple[500],
                                backgroundGradient: null,
                                strokeWidth: 20.0,
                                strokeCap: StrokeCap.round,
                                textStyle: const TextStyle(
                                  fontSize: 33.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textFormat: CountdownTextFormat.HH_MM_SS,
                                isReverse: false,
                                isReverseAnimation: false,
                                isTimerTextShown: true,
                                autoStart: true,
                                onStart: () {
                                  debugPrint('Countdown Started');
                                },
                                onComplete: () {
                                  debugPrint('Countdown Ended');
                                  DataApiService.instance.completeRequest(
                                      users.requestId.toString(), context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        final themeChange =
                                            Provider.of<DarkThemeProvider>(
                                                context);

                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: Container(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              height: 350,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: ClipOval(
                                                                child:
                                                                    CachedNetworkImage(
                                                                  height: 15.h,
                                                                  width: 15.h,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                      requestUser
                                                                          .image
                                                                          .toString(),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                    'assets/images/profile.png',
                                                                    height: 70,
                                                                    width: 70,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image
                                                                          .asset(
                                                                    'assets/images/profile.png',
                                                                    height: 70,
                                                                    width: 70,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                            requestUser
                                                                .userName,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline3),
                                                        SizedBox(height: 10),
                                                        Text(
                                                            'Your workout has been ended please rate your experience with ' +
                                                                requestUser
                                                                    .userName,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText2),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  RatingBar(
                                                      initialRating: 0.0,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30,
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
                                                      onRatingUpdate: (value) {
                                                        rate = value;
                                                      }),
                                                  Column(children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      height: 6.h,
                                                      width: 70.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: primaryColor),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          DataApiService
                                                              .instance
                                                              .sendRating(
                                                                  requestUser.id
                                                                      .toString(),
                                                                  rate.toString(),
                                                                  context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      WorkoutDetail(users
                                                                          .userData!
                                                                          .id
                                                                          .toString())));
                                                        },
                                                        child: Center(
                                                            child: Text(
                                                                "Submit",
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

                                // This Callback will execute when the Countdown Changes.
                                onChange: (String timeStamp) {
                                  // Here, do whatever you want
                                  // debugPrint('Countdown Changed $timeStamp');
                                },
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  timeRemaining,
                                  Text(
                                    'Time remaining',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    intToTimeLeft(timerleft),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                  SizedBox(
                    height: 15.h,
                  )

                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: timerleft == 0 || timerleft < 0 && _duration > 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    width: 60.w,
                    child: _button(
                        title: "Quit",
                        onPressed: () {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Quit',
                                  desc: 'Are you sure you want to quit?',
                                  btnOkOnPress: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          final themeChange =
                                          Provider.of<DarkThemeProvider>(
                                              context);

                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                                  child: Container(
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                    height: 350,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              SizedBox(height: 10),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: ClipOval(
                                                                      child:
                                                                      CachedNetworkImage(
                                                                        height: 15.h,
                                                                        width: 15.h,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        imageUrl: 'https://becktesting.site/workout-bud/public/storage/user/' +
                                                                            requestUser
                                                                                .image
                                                                                .toString(),
                                                                        placeholder: (context,
                                                                            url) =>
                                                                            Image
                                                                                .asset(
                                                                              'assets/images/profile.png',
                                                                              height: 70,
                                                                              width: 70,
                                                                              fit: BoxFit
                                                                                  .fill,
                                                                            ),
                                                                        errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                            Image
                                                                                .asset(
                                                                              'assets/images/profile.png',
                                                                              height: 70,
                                                                              width: 70,
                                                                              fit: BoxFit
                                                                                  .contain,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 10),
                                                              Text(
                                                                  requestUser
                                                                      .userName,
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .headline3),
                                                              SizedBox(height: 10),
                                                              Text(
                                                                  'Your workout has been ended please rate your experience with ' +
                                                                      requestUser
                                                                          .userName,
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .bodyText2),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        RatingBar(
                                                            initialRating: 0.0,
                                                            direction:
                                                            Axis.horizontal,
                                                            allowHalfRating: true,
                                                            itemCount: 5,
                                                            itemSize: 30,
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
                                                            onRatingUpdate: (value) {
                                                              rate = value;
                                                            }),
                                                        Column(children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Container(
                                                            height: 6.h,
                                                            width: 70.w,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(20),
                                                                color: primaryColor),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                _controller.pause();
                                                                DataApiService.instance.quitTimer(
                                                                    profileInfo.id.toString(),
                                                                    getrequest.requestedToId.toString(),
                                                                    getrequest.id.toString(),
                                                                    context);
                                                                DataApiService.instance.completeRequest(
                                                                    users.requestId.toString(), context);



                                                                /* Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context) =>
                                                                            WorkoutDetail(
                                                                                widget.requestedToid)));*/
                                                                DataApiService
                                                                    .instance
                                                                    .sendRating(
                                                                    requestUser.id
                                                                        .toString(),
                                                                    rate.toString(),
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);  Navigator.pop(context);
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext
                                                                        context) =>
                                                                            WorkoutDetail(users
                                                                                .userData!
                                                                                .id
                                                                                .toString())));
                                                              },
                                                              child: Center(
                                                                  child: Text(
                                                                      "Submit",
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
                                  btnCancelOnPress: () {})
                              .show();
                        }),
                  ),

                ],
              )
            : SizedBox());
  }

  Widget _button({required String title, VoidCallback? onPressed}) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
