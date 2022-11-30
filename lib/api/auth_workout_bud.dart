import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:co_op/constants/custom_dialog.dart';
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
import 'package:co_op/screens/profile/AddressList.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/Profile_Model.dart';
import 'urls.dart';
import 'global_variables.dart';

class DataApiService {
  DataApiService._();

  static final DataApiService _instance = DataApiService._();

  static DataApiService get instance => _instance;

  Future getlogintoken(Map<String, dynamic> data, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + login_url;
      print(url);

      try {
        http.Response response = await http.post(Uri.parse(url),
            body: data, headers: {'Accept': "application/json"});
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success'] == true) {
          USER_TOKEN.value = result['token'];
          profileInfo = GetProfileModel.fromJson(result['user']);
          print('true');
          setUserLoggedIn(true);
          saveUserDataToken(
            token: USER_TOKEN.value,
          );
          return true;
        } else {
          print('false');
          SnackMessage = result['message'];
          return false;
        }

        /*     final result = jsonDecode(response.body);
      print(result.containsKey('token'));
      print(result.containsKey('message'));
      if (result.containsKey('token')) {
        SnackMessage = 'Login Successfully';
        CUSTOMER_TOKEN.value = result['token'];

        setUserLoggedIn(true);
        saveUserDataToken(
          token: CUSTOMER_TOKEN.value,
        );
      } else {
        SnackMessage = result['message'];
      }
      return result.containsKey('token'); */
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    } else {
      SnackMessage = 'No Internet Connection';
      return false;
    }
  }

  Future register(
      String username,
      String gender,
      String age,
      String weight,
      String height,
      String goal,
      String level,
      String email,
      String password,
      String fullname,
      String nickname,
      String phonenumber,
      String lat,
      String long,
      String address,
      String name,
      String image,
      context) async {
    String url = baseUrl + register_url;
    print(url);
    try {
      /*   http.Response response = await http.post(Uri.parse(url),
          body: body, headers: {'Accept': 'application/json'});

      final result = jsonDecode(response.body); */
      var headers = {
        'Accept': 'application/json',
      };
      var request = http.MultipartRequest('POST', Uri.parse(url));
      print(phonenumber);
      request.fields.addAll({
        'name': name,
        'user_name': username,
        /* 'nick_name': 'nifty', */
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
        'goal': goal,
        'activity_level': level,
        /* 'phone_number': '03067100021', */

        'email': email,
        'password': password,
        if (fullname != '') 'full_name': fullname,
        if (nickname != '') 'nick_name': nickname,
        if (phonenumber != '') 'phone_number': phonenumber,
        'lat': lat,
        'long': long,
        'sub_category_id': filterList.join(','),
        'location_name': address,
      });
      print(address);
      if (image != '')
        request.files.add(await http.MultipartFile.fromPath('image', image));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String ans = await response.stream.bytesToString();
      final result = jsonDecode(ans);
      print(result);

      if (result['success'] == true) {
        print('true');
        SnackMessage = result['message'];
        USER_TOKEN.value = result['token'];
        return true;
      } else {
        print('false');
        SnackMessage = result['message'];
        return false;
      }
    } on Exception {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future updateProfile(
      String gender,
      String username,
      String age,
      String weight,
      String height,
      String fullname,
      String nickname,
      String phonenumber,
      int selectedIndex,
      String image,
      context) async {
    String url = baseUrl + updateProfile_url;
    print(url);
    try {
      /*   http.Response response = await http.post(Uri.parse(url),
          body: body, headers: {'Accept': 'application/json'});

      final result = jsonDecode(response.body); */
      var headers = {
        'Accept': 'application/json',
        "Authorization": "Bearer ${USER_TOKEN.value}",
      };
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({
        'gender': gender,
        'user_name': username,
        'age': age,
        'weight': weight,
        'height': height,
        if (fullname != '') 'full_name': fullname,
        if (nickname != '') 'nick_name': nickname,
        if (phonenumber != '') 'phone_number': phonenumber,
        if (selectedIndex == 0) 'activity_level': 'Beginner',
        if (selectedIndex == 1) 'activity_level': 'Intermediate',
        if (selectedIndex == 2) 'activity_level': 'Advanced',
      });
      print('image path');
      print(image);
      request.files.add(await http.MultipartFile.fromPath('image', image));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String ans = await response.stream.bytesToString();
      final result = jsonDecode(ans);
      print(result);

      if (result['success'] == true) {
        print('true');
        SnackMessage = result['message'];

        return true;
      } else {
        print('false');
        SnackMessage = result['message'];
        return false;
      }
    } on Exception {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future getprofileinfo(context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + profile_url;
      print(url);

      try {
        http.Response response = await http.get(Uri.parse(url), headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          profileInfo = GetProfileModel.fromJson(result['user']);
          print(USER_TOKEN.value);
          print('success');
        } else {
          print("unsucess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    } else {
      GlobalSnackBar.show(context, 'You are disconnected with internet');
    }
  }

  Future updateProfileWithoutImage(Map<String, dynamic> updte, context) async {
    String url = baseUrl + updateProfile_url;
    print(url);

    try {
      http.Response response =
          await http.post(Uri.parse(url), body: updte, headers: {
        "Authorization": "Bearer ${USER_TOKEN.value}",
      });
      print(response.body);
      final result = jsonDecode(response.body);
      if (result['success'] == true) {
        print('true');
        SnackMessage = result['message'];

        return true;
      } else {
        print('false');
        SnackMessage = result['message'];
        return false;
      }
    } on Exception {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future getUserStatus(String idto, String idfrom, context) async {
    String url = baseUrl + requestStatus_url;
    print(url);
    print('idto=' + idfrom);
    print('idfrom=' + idto);

    try {
      http.Response response = await http.post(Uri.parse(url), body: {
        'id_to': idfrom,
        'id_from': idto
      }, headers: {
        "Authorization": "Bearer ${USER_TOKEN.value}",
      });
      print(response.body);
      final result = jsonDecode(response.body);
      users = GetRequestStatusModel.fromJson(result);
      workoutWithList = List<WorkoutWithModel>.from(
          result['workout_with'].map((x) => WorkoutWithModel.fromJson(x)));
      if (result['success'] == true) {
        print('true');
        SnackMessage = result['message'];

        return true;
      } else {
        print('false');
        SnackMessage = result['message'];
        return false;
      }
    } on Exception {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future requstList(String id, context) async {
    String url = baseUrl + requestList_url;
    print(url);

    try {
      http.Response response = await http.post(Uri.parse(url), body: {
        'id': id,
      }, headers: {
        "Authorization": "Bearer ${USER_TOKEN.value}",
      });
      print(response.body);
      final result = jsonDecode(response.body);
      // requestList = jsonDecode(result['list']);
      requestList =
          result.containsKey('list') ? List<int>.from(result['list']) : [];
      print(requestList);

      if (result['success'] == true) {
        print('true');
        SnackMessage = result['message'];

        return true;
      } else {
        print('false');
        SnackMessage = result['message'];
        return false;
      }
    } on Exception {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future resposneRequest(String id, String status, context) async {
    String url = baseUrl + resoponse_url;
    print(url);

    try {
      http.Response response = await http.post(Uri.parse(url), body: {
        'id': id,
        'status': status
      }, headers: {
        "Authorization": "Bearer ${USER_TOKEN.value}",
      });
      print(response.body);
      final result = jsonDecode(response.body);
      if (result['success'] == true) {
        print('true');
        SnackMessage = result['message'];

        return true;
      } else {
        print('false');
        SnackMessage = result['message'];
        return false;
      }
    } on Exception {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future getFiltersList(context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = filter_url;
      print(url);

      try {
        http.Response response = await http.get(Uri.parse(url), headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Success');

          print("divider");
          getfilterList = List<GetFilterModel>.from(
              result['category'].map((x) => GetFilterModel.fromJson(x)));
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getAddressList(context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + address_url;
      print(url);

      try {
        http.Response response = await http.get(Uri.parse(url), headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Success');

          getAddrList = List<AddressModel>.from(
              result['address'].map((x) => AddressModel.fromJson(x)));
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future addAddress(Map<String, dynamic> address, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + add_address_url;
      print(url);

      try {
        http.Response response =
            await http.post(Uri.parse(url), body: address, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future updateInterest(String interest, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + update_Interest_url;
      print(url);

      try {
        http.Response response = await http.post(Uri.parse(url), body: {
          'sub_category_id': interest
        }, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future forgetPassword(String email, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + forgetPassword_url;
      print(url);

      try {
        http.Response response = await http.post(
          Uri.parse(url),
          body: {'email': email},
        );
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('success');
          SnackMessage = result['message'];
          otp = result['OTP'];
          return true;
        } else {
          SnackMessage = result['message'];

          print("unsuccess");
          return false;
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future changePassword(Map<String, dynamic> pass, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + changePassword_url;
      print(url);

      try {
        http.Response response = await http.post(
          Uri.parse(url),
          body: pass,
        );
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('success');
          SnackMessage = result['message'];

          return true;
        } else {
          SnackMessage = result['message'];

          print("unsuccess");
          return false;
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future updateAddress(Map<String, dynamic> address, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + update_address_url;
      print(url);

      try {
        http.Response response =
            await http.post(Uri.parse(url), body: address, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          SnackMessage = result['message'];
          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future sendRequest(Map<String, dynamic> request, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + sendRequest_url;
      print(url);

      try {
        http.Response response =
            await http.post(Uri.parse(url), body: request, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          SnackMessage = result['message'];

          print('Success');

          return true;
        } else {
          SnackMessage = result['message'];
          print("unsuccess");
          return false;
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getUsersPreference(Map<String, dynamic> address, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + user_prefrence_url;
      print(url);

      try {
        http.Response response =
            await http.post(Uri.parse(url), body: address, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          getUsersList = List<GetUsersModel>.from(
              result['users'].map((x) => GetUsersModel.fromJson(x)));
          SnackMessage = result['message'];
          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getRequest(String id, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + getrequest_url;
      print(url);

      try {
        http.Response response = await http.post(Uri.parse(url), body: {
          'id': id
        }, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          getrequest = GetRequestModel.fromJson(result['request']);
          requestUser = DashboardModel.fromJson(result['user']);

          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future logout(context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + logout_url;
      print(url);

      try {
        http.Response response = await http.get(Uri.parse(url), headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future updateUserAddress(Map<String, dynamic> address, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + update_addrUser_url;
      print(url);

      try {
        http.Response response =
            await http.post(Uri.parse(url), body: address, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future deleteUserAddress(Map<String, dynamic> address, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + delete_addrUser_url;
      print(url);

      try {
        http.Response response =
            await http.post(Uri.parse(url), body: address, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Success');
          return true;
        } else {
          print("unsuccess");
          return false;
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getUsers(context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + get_users_url;
      print(url);

      try {
        http.Response response = await http.get(Uri.parse(url), headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Success');

          getUsersList = List<GetUsersModel>.from(
              result['list'].map((x) => GetUsersModel.fromJson(x)));

          print(getUsersList[0].userName);
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getNotification(context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + notification_url;
      print(url);

      try {
        http.Response response = await http.get(Uri.parse(url), headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (response.statusCode == 200) {
          print('Success');

          notificationList = List<NotificationListModel>.from(
              result['All_Notification']
                  .map((x) => NotificationListModel.fromJson(x)));
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getDashboard(context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + dashboard_url;
      print(url);

      try {
        http.Response response = await http.get(Uri.parse(url), headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Success');

          dashbarodUsersList = List<DashboardModel>.from(
              result['dashboard'].map((x) => DashboardModel.fromJson(x)));
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getActivityUsers(String level, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + activity_url;
      print(url);

      try {
        http.Response response = await http.post(Uri.parse(url), body: {
          'activity_level': level,
        }, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Success');

          activityUsers = List<DashboardModel>.from(
              result['user'].map((x) => DashboardModel.fromJson(x)));
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getBookmarkList(context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + get_bookmark_url;
      print(url);

      try {
        http.Response response = await http.get(Uri.parse(url), headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Success');

          bookmarkList = List<BookmarkModel>.from(
              result['list'].map((x) => BookmarkModel.fromJson(x)));
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getInsightList(String date, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + insight_url;
      print(url);

      try {
        http.Response response = await http.post(Uri.parse(url), body: {
          'date': date
        }, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Success');

          insightList = List<InsightModel>.from(
              result['user'].map((x) => InsightModel.fromJson(x)));
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future getNotificationCount(context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + notification_count_url;
      print(url);

      try {
        http.Response response = await http.get(Uri.parse(url), headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Success');
          notificationCount = jsonDecode(result['count']);
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future sendRating(String id, String rating, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + rating_url;
      print(url);

      try {
        http.Response response = await http.post(Uri.parse(url), body: {
          'rate_to_id': id,
          'stars_rating': rating,
        }, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future addBookmark(String id, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + add_bookmark_url;
      print(url);

      try {
        http.Response response = await http.post(Uri.parse(url), body: {
          'bookmark_id': id,
        }, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future deleteBookmark(String id, context) async {
    connected = await isNetworkAvailable();
    if (connected) {
      String url = baseUrl + delete_bookmark_url;
      print(url);

      try {
        http.Response response = await http.post(Uri.parse(url), body: {
          'id': id,
        }, headers: {
          "Authorization": "Bearer ${USER_TOKEN.value}",
        });
        print(response.body);
        final result = jsonDecode(response.body);
        if (result['success']) {
          print('Success');
        } else {
          print("unsuccess");
        }
      } on Exception {
        rethrow;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future uploadImages(context) async {
    String url = baseUrl + upload_imgaes_url;
    print(url);
    try {
      var headers = {
        'Accept': 'application/json',
        "Authorization": "Bearer ${USER_TOKEN.value}",
      };
      var request = http.MultipartRequest('POST', Uri.parse(url));
      late http.MultipartFile multipartFile;
      List<http.MultipartFile> newList = <http.MultipartFile>[];

      for (int i = 0; i < files.length; i++) {
        multipartFile =
            await http.MultipartFile.fromPath('images[]', files[i].path);
        newList.add(multipartFile);
      }
      request.files.addAll(newList);

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String ans = await response.stream.bytesToString();
      final result = jsonDecode(ans);
      print(result);

      if (result['success'] == true) {
        print('true');

        return true;
      } else {
        print('false');
        return false;
      }
    } on Exception {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
