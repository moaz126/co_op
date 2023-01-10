import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../api/global_variables.dart';
import '../../../api/urls.dart';

class DataController extends GetxController {
  final count=0.obs;

  var isDataLoading = false.obs;



  @override
  Future<void> onInit() async {
    super.onInit();
    getApi();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}


  getApi() async {
    print('called');
    try{
      isDataLoading(true);
      String url = baseUrl + notification_count_url;
      print(url);
      http.Response response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer ${USER_TOKEN.value}",
      });
      print(response.body);
      final result = jsonDecode(response.body);
      if (result['success']) {
        print('Success');
        count(result['count']);

      } else {
        print("unsuccess");
      }
    }catch(e){
      log('Error while getting data is $e');
      print('Error while getting data is $e');
    }finally{
      isDataLoading(false);
    }
  }
}