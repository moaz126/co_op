import 'package:flutter/material.dart';
import 'package:co_op/provider/dark_theme_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

const String google_api_key = 'AIzaSyBDOMNCVC2eacCxKYuRxIwCz4w-QjV_l5Y';

const Color primaryColor = Color(0xff5724f5);
const Color secondaryColor = Color(0xffeb7e30);

String? id;
String? userId;
String? type;

final spinkit = SpinKitFadingCube(
  color: Colors.white,
  size: 2.h,
);
/* final pageSpinkit = SpinKitCubeGrid(
  color: Colors.black,
  size: 5.h,
); */
final pageSpinkit = SizedBox(
  height: 20.h,
  width: 20.h,
  child: Lottie.asset(
    'assets/animations/page_loader.json',
  ),
);final requestButton = SizedBox(
  height: 5,
  width: 90.w,
  child: Lottie.asset(
    'assets/animations/requestButton.json',
  ),
);
final timeRemaining = SizedBox(
  height: 20.h,
  width: 20.h,
  child: Lottie.asset(
    'assets/animations/timeRemaining.json',
  ),
);
final timeend = SizedBox(
  height: 20.h,
  width: 20.h,
  child: Lottie.asset(
    'assets/animations/timeEnd.json',
  ),
);

/* SpinKitFadingCube(
  color: secondaryColor,
  size: 5.h,
); */
final emptyAnimation = SizedBox(
  height: 30.h,
  width: 30.h,
  child: Lottie.asset(
    'assets/animations/empty.json',
  ),
);
