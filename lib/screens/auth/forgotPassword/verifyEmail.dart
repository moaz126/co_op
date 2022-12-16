import 'dart:async';

import 'package:co_op/screens/auth/forgotPassword/new_password.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';

import '../../../api/global_variables.dart';
import '../../../provider/dark_theme_provider.dart';

class EmailVerify extends StatefulWidget {
  final String email;
  EmailVerify(this.email);

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  @override
  int selectedIndex = 0;
  TextEditingController EmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController OtpController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Your Email"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 4.h,
            ),
            Container(
              child: Image.asset(
                "assets/images/forget2.png",
                height: 30.h,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Center(
                child: Text(
                  "Enter Your 6 Digit OTP Sent To \n" + widget.email,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
              //height: 10.h,
              child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      autoFocus: true,
                      autoUnfocus: true,
                      enablePinAutofill: false,
                      pastedTextStyle: TextStyle(
                        color: HexColor('#FF2501'),
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      /* obscuringWidget: const FlutterLogo(
                          size: 24,
                        ), */
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v != otp.toString()) {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        inactiveColor: Colors.grey.withOpacity(0.5),
                        selectedColor: HexColor('#FF2501'),
                        selectedFillColor: HexColor('#F2F2F4'),

                        //disabledColor: Colors.black,
                        inactiveFillColor: HexColor('#F2F2F4'),
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 60,
                        fieldWidth: 48,
                        activeFillColor: HexColor('#F2F2F4'),
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: OtpController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(5, 5),
                          color: Colors.black12,
                          blurRadius: 5,
                        )
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                        // if (otp.toString() == OtpController.text) {
                        //   Get.to(() => NewPassword(widget.email));
                        // }
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          // currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  if (otp.toString() == OtpController.text) {
                    Get.to(() => NewPassword(widget.email));
                  } else{
                    Fluttertoast.showToast(
                        msg: 'Invalid OTP'
                            .toString(),
                        toastLength: Toast
                            .LENGTH_SHORT,
                        gravity:
                        ToastGravity
                            .BOTTOM,
                        timeInSecForIosWeb:
                        1,
                        textColor:
                        Colors.white,
                        fontSize: 16.0);
                  }
                },
                child: Container(
                  width: 90.w,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor),
                  child: Center(
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
