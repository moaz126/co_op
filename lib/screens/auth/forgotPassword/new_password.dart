import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/constants/custom_dialog.dart';
import 'package:co_op/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';

import '../../../api/global_variables.dart';
import '../../../provider/dark_theme_provider.dart';

class NewPassword extends StatefulWidget {
  final String email;
  NewPassword(this.email);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  @override
  int selectedIndex = 0;
  TextEditingController EmailController = TextEditingController();
  bool buttonLoader = false;
  bool view = true;

  String _pass = "";

  TextEditingController PasswordController = TextEditingController();

  TextEditingController ConfirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Password"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 4.h,
              ),
              Container(
                child: Image.asset(
                  "assets/images/forget.png",
                  height: 30.h,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: const Text(
                  "Please Enter Your New Password",
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            _pass = value;
                          });
                        },
                        controller: PasswordController,
                        showCursor: true,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        obscureText: view,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            //<-- SEE HERE
                            borderSide: BorderSide(width: 1, color: Colors.red),
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
                          prefixIcon: Icon(Icons.key),
                          hintText: 'Password',
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                view = !view;
                              });
                            },
                            child: Icon(
                                view ? Icons.visibility_off : Icons.visibility),
                          ),
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
              _pass.length > 7 || _pass == ''
                  ? SizedBox(
                      height: 2.h,
                    )
                  : Container(
                      width: Get.width,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('Password should atleast 8 characters'),
                      ),
                    ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          }
                        },
                        controller: ConfirmPasswordController,
                        showCursor: true,
                        cursorColor: Colors.grey,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        obscureText: view,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            //<-- SEE HERE
                            borderSide: BorderSide(width: 1, color: Colors.red),
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
                          prefixIcon: Icon(Icons.key),
                          hintText: 'Confirm Password',
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                view = !view;
                              });
                            },
                            child: Icon(
                                view ? Icons.visibility_off : Icons.visibility),
                          ),
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
              SizedBox(
                height: 5.h,
              ),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      buttonLoader = true;
                    });
                    if (PasswordController.text ==
                        ConfirmPasswordController.text) {
                      Map<String, dynamic> pass = {
                        'email': widget.email,
                        'otp': otp.toString(),
                        'new_password': PasswordController.text,
                      };
                      bool status = await DataApiService.instance
                          .changePassword(pass, context);
                      if (status) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.SUCCES,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Sign Up',
                          desc: SnackMessage,
                          btnOkOnPress: () {
                            /*   Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignIn())); */
                            Get.offAll(SignIn());
                          },
                        ).show();
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
                    } else {
                      GlobalSnackBar.show(context, 'Password should be same');
                    }
                    setState(() {
                      buttonLoader = false;
                    });
                  }
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
                            'Save',
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
        ),
      ),
    );
  }
}
