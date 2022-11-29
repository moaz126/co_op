import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/screens/auth/forgotPassword/verifyEmail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';

import '../../../api/global_variables.dart';
import '../../../provider/dark_theme_provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  int selectedIndex = 0;
  TextEditingController EmailController = TextEditingController();
  bool buttonLoader = false;

  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 4.h,
            ),
            Container(
              child: Image.asset(
                "assets/images/forget1.png",
                height: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: const Text(
                "Please Enter Your Email To Recieve OTP",
              ),
            ),
            /*  Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: const Text(
                "Select which contact detail should we use to reset your password",
              ),
            ), */
            SizedBox(
              height: 5.h,
            ),
            Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field is required';
                              }
                            },
                            controller: EmailController,
                            showCursor: true,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 25.0),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                //<-- SEE HERE
                                borderSide:
                                    BorderSide(width: 1, color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              prefixIcon: Icon(Icons.mail),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  color: themeChange.darkTheme
                                      ? Colors.white
                                      : Colors.grey,
                                  fontSize: 2.h,
                                  fontFamily: 'NeueMachina'),
                              filled: true,
                              fillColor: themeChange.darkTheme
                                  ? Colors.white38
                                  : Colors.black12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                /*   InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              child: Container(
                height: 10.h,
                width: 90.w,
                decoration: BoxDecoration(
                    color: selectedIndex == 0
                        ? secondaryColor.withOpacity(0.3)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: selectedIndex == 0
                            ? secondaryColor
                            : Colors.grey.withOpacity(0.4),
                        width: 3)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 3.h,
                        backgroundColor: selectedIndex==0? Colors.white : Colors.black12,
                        backgroundImage: const AssetImage(""),
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Via SMS",
                              style: TextStyle(
                                  color: selectedIndex == 0
                                      ? Colors.black
                                      : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1)),
                          Text("+92321*****49",
                              style: TextStyle(
                                  color: selectedIndex == 0
                                      ? Colors.black
                                      : Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: Container(
                height: 10.h,
                width: 90.w,
                decoration: BoxDecoration(
                    color: selectedIndex == 1
                        ? secondaryColor.withOpacity(0.3)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: selectedIndex == 1
                            ? secondaryColor
                            : Colors.grey.withOpacity(0.4),
                        width: 3)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 3.h,
                        backgroundColor: selectedIndex==1?Colors.white: Colors.black12,
                        backgroundImage: AssetImage(""),
                      ),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Via EMail",
                              style: TextStyle(
                                  color: selectedIndex == 1
                                      ? Colors.black
                                      : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1)),
                          Text("abd*****ad@tecbeck.com",
                              style: TextStyle(
                                  color: selectedIndex == 1
                                      ? Colors.black
                                      : Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ), */
                InkWell(
                  onTap: () async {
                    setState(() {
                      buttonLoader = true;
                    });
                    print('click');
                    bool status = await DataApiService.instance
                        .forgetPassword(EmailController.text, context);
                    print(status);
                    if (status) {
                      Get.to(() => EmailVerify(EmailController.text));
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.bottomSlide,
                        title: 'Sign Up',
                        desc: SnackMessage,
                        btnOkOnPress: () {},
                      ).show();
                    }
                    setState(() {
                      buttonLoader = false;
                    });
                  },
                  child: Container(
                    width: 90.w,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryColor),
                    child: Center(
                      child: buttonLoader
                          ? spinkit
                          : Text(
                              'Send Code',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
