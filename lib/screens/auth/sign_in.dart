import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/screens/auth/accountsetup/select_gender.dart';
import 'package:co_op/screens/auth/sign_up.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/auth/forgotPassword/forgot_password.dart';
import 'package:co_op/screens/home/home_page.dart';
import '../../../provider/dark_theme_provider.dart';
import '../../api/global_variables.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool value = false;
  bool loader = false;
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  bool view = true;
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  var storedCreds;
  List<String> creds = [];
  String? _email, _pass;
/*   bool _isChecked = false;
  void _handleRemeberme(bool value) {
    print("Handle Rember Me");
    _isChecked = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', EmailController.text);
        prefs.setString('password', PasswordController.text);
      },
    );
    setState(() {
      _isChecked = value;
    });
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;

      print(_remeberMe);
      print(_email);
      print(_password);
      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        EmailController.text = _email ?? "";
        PasswordController.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  } */

  @override
  void initState() {
    // TODO: implement initState

    getStoredCredsList();
    // _loadUserEmailPassword();
    super.initState();
  }

  bool data = false;
  getStoredCredsList() async {
    storedCreds = await getCredsList();
    setState(() {
      data = true;
    });
    print(storedCreds);
  }

  matchPassword() {
    if (data) {
      if (storedCreds.isNotEmpty) {
        for (int i = 0; i < storedCreds.length; i++) {
          if (storedCreds[i].split(',')[0] == _email) {
            setState(() {
              PasswordController.text = storedCreds[i].split(',')[1];
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      child: Image.asset(
                        "assets/images/login.png",
                        height: 30.h,
                      ),
                    ),

                    Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Login",
                              style: Theme.of(context).textTheme.headline1),
                        ],
                      ),
                    )),
                    SizedBox(
                      height: 2.h,
                    ),
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
                                onChanged: (text) {
                                  setState(() {
                                    _email = text;
                                    matchPassword();
                                  });
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
                      height: 2.h,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                              },
                              onChanged: (text) {
                                setState(() {
                                  _pass = text;
                                });
                              },
                              controller: PasswordController,
                              showCursor: true,
                              cursorColor: Colors.grey,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              obscureText: view,
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
                                prefixIcon: Icon(Icons.key),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: themeChange.darkTheme
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 2.h,
                                    fontFamily: 'NeueMachina'),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      view = !view;
                                    });
                                  },
                                  child: Icon(view
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
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
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20.0, top: 4, left: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor: secondaryColor,
                                side: BorderSide(color: Colors.grey),
                                checkColor: Colors.white,
                                value: rememberMe,
                                onChanged: /* (value) {
                                    _handleRemeberme(value!);
                                  } */
                                    (value) {
                                  setState(() {
                                    rememberMe = value!;
                                    if (rememberMe) {
                                      if (creds.isEmpty) {
                                        creds.add(_email! + "," + _pass!);
                                        creds = creds + storedCreds;
                                        print(creds);
                                      }
                                    }
                                  });
                                },
                              ),
                              Text("Remember me")
                            ],
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 4),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primaryColor),
                        child: InkWell(
                            child: Center(
                              child: loader
                                  ? spinkit
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                            ),
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                String? fcmtoken;
                                await FirebaseMessaging.instance
                                    .getToken()
                                    .then((token) {
                                  fcmtoken = token;
                                });
                                bool status = false;
                                Map<String, dynamic> loginUser = {
                                  'email': EmailController.text,
                                  'password': PasswordController.text,
                                  'fcm_tokken': fcmtoken,
                                };
                                print(loginUser);
                                setState(() {
                                  loader = true;
                                });
                                status = await DataApiService.instance
                                    .getlogintoken(loginUser, context);
                                setState(() {
                                  loader = false;
                                });
                                if (status) {
                                  if(profileInfo.verified==1){
                                    if (rememberMe) {
                                      saveCredsList(creds);
                                    }
                                    Get.to(() => HomePage());
                                  }

                                } else {
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.bottomSlide,
                                          title: 'Login',
                                          desc: SnackMessage,
                                          btnOkOnPress: () {},
                                          btnOkColor: Colors.red)
                                      .show();
                                }
                              }
                            }),
                      ),
                    ),

                    ///Social Icons
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Expanded(
                    //         child: Divider(
                    //           height: 0,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //       Text("  or continue with  ", style: TextStyle(fontSize: 16),),
                    //       Expanded(
                    //         child: Divider(
                    //           height: 0,
                    //           color: Colors.black,),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 3.h,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SocialLoginButton(
                    //       buttonType: SocialLoginButtonType.google,
                    //       text: "",
                    //       onPressed: () {},
                    //       mode: SocialLoginButtonMode.single,
                    //     ),
                    //     SizedBox(width: 20,),
                    //     SocialLoginButton(
                    //       buttonType: SocialLoginButtonType.facebook,
                    //       text: "",
                    //       onPressed: () {},
                    //       mode: SocialLoginButtonMode.single,
                    //     ),
                    //     SizedBox(width: 20,),
                    //     SocialLoginButton(
                    //       buttonType: SocialLoginButtonType.appleBlack,
                    //       text: "",
                    //       onPressed: () {},
                    //       mode: SocialLoginButtonMode.single,
                    //     ),
                    //   ],
                    // ),

                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        InkWell(
                            onTap: () {
                              Get.to(SelectGender());
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
