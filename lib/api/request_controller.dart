import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuitRequestController extends GetxController{
  final quit=false.obs;

  checkquit() {
    quit(true);
  }
}