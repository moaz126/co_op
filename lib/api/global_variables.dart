import 'dart:io';

import 'package:co_op/models/Address_Model.dart';
import 'package:co_op/models/BookmarkModel.dart';
import 'package:co_op/models/DashboardModel.dart';
import 'package:co_op/models/Filter_Model.dart';
import 'package:co_op/models/GetRequestModel.dart';
import 'package:co_op/models/GetUsers_Model.dart';
import 'package:co_op/models/InsightModel.dart';
import 'package:co_op/models/NotificationModel.dart';
import 'package:co_op/models/RequestStatus_Model.dart';
import 'package:co_op/models/WorkoutWithModel.dart';
import 'package:co_op/screens/home/requestList.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:co_op/models/Profile_Model.dart';

import '../models/InProgressModel.dart';
import '../models/MyRequestList.dart';

final USER_TOKEN = ValueNotifier("");
final ratingStars = ValueNotifier(0.0);
var profileInfo = GetProfileModel(goal: [], subCategoryId: [], imageList: []);
List<GetFilterModel> getfilterList = [];
List<MyRequestList> myReqeustList = [];
List<InProgressModel> inProgressList = [];
List<InProgressModel> completedList = [];
List<AddressModel> getAddrList = [];
List<BookmarkModel> bookmarkList = [];
List<GetUsersModel> getUsersList = [];
List<WorkoutWithModel> workoutWithList = [];
List<NotificationListModel> notificationList = [];
List<DashboardModel> dashbarodUsersList = [];
List<DashboardModel> activityUsers = [];
List<InsightModel> insightList = [];
bool firstHome = false;
List<File> files = [];
List<String> imageFiles = [];
int notificationCount = 0;
var getrequest =
    GetRequestModel(meetUpTime: '00:00:00', meetupEndTime: '00:00:00');
var requestUser = DashboardModel(
    id: 0,
    subCategoryId: [],
    userName: '',
    email: 'email',
    gender: 0,
    age: 5,
    weight: '0',
    height: 'height',
    goal: [],
    long: 0.0,
    lat: 0.0,
    activityLevel: 'activityLevel',
    image: 'image',
    fullName: 'fullName',
    nickName: 'nickName',
    phone: 'phone',
    emailVerifiedAt: 'emailVerifiedAt',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    otp: 'otp',
    fcmTokken: 'fcmTokken',
    avg: 0,
    bookmark: 0,
    bookmarkId: 0,
    getReviews: []);
List<int> requestList = [];
var users = GetRequestStatusModel(
    success: true,
    userData: null,
    request: [],
    status: -1,
    requestId: null,
    message: '');
bool connected = false;
String? SnackMessage;
String imagepath = '';
int select_gender = -1;
int select_age = 10;
int select_weight = 10;
int select_height = 70;
int select_height_decimal = 0;
int otp = -1;
List<String> select_goal = [];
List<String> filterList = [];
String? select_level;
String? image;
String? fullName;
String? nickName;
int? phoneNumber;
bool interestNavigation = false;

class Profile {
  Profile({
    this.select_gender,
    this.select_age,
    this.select_weight,
    this.select_height,
    this.select_goal,
    this.select_level,
    this.image,
    this.fullName,
    this.nickName,
    this.phoneNumber,
    this.email,
    this.Emailcontroller,
  });
  int? select_gender = -1;
  int? select_age = 10;
  int? select_weight = 10;
  int? select_height = 70;
  List<String>? select_goal = [];
  String? select_level;
  String? image;
  String? fullName;
  String? nickName;
  String? phoneNumber;
  String? email;
  TextEditingController? Emailcontroller;
}

var profileDetail = new Profile();
void setUserLoggedIn(bool key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isLoggedIn", key);
}

Future getUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var log = prefs.getBool("isLoggedIn") ?? false;
  return log;
}

void saveUserDataToken({@required token}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString("token", token);
}

Future getUserDataToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? result = pref.getString("token");
  return result;
}

void setUserFirstTime(bool key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isFirstTime", key);
}

Future getUserFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var log = prefs.getBool("isFirstTime") ?? true;
  return log;
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

void saveCredsList(List<String> list) async {
  print("save creds");
  print(list);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("creds", list);
}

Future getCredsList() async {
  print("get creds");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var log = prefs.getStringList("creds") ?? [];
  return log;
}
