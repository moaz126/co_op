import 'package:co_op/constants/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/auth/accountsetup/select_age.dart';

import '../../../api/global_variables.dart';
import '../../../provider/dark_theme_provider.dart';

class SelectGender extends StatefulWidget {
  const SelectGender({Key? key}) : super(key: key);

  @override
  State<SelectGender> createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 4.h,
            ),
            InkWell(
                onTap: () {
                  themeChange.darkTheme = !themeChange.darkTheme;
                },
                child: Icon(Icons.dark_mode)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 89.w,
                    child: Center(
                        child: Text(
                      "Tell us about yourself",
                      style: Theme.of(context).textTheme.headline3,
                    ))),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 88.w,
                    child: Center(
                        child: Text(
                      "To give you a better experience and results\nwe need to know your gender",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2,
                    ))),
              ],
            ),
            SizedBox(height: 80),
            Expanded(
              child: Column(
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: themeChange.darkTheme
                          ? selectedIndex == 1
                              ? primaryColor
                              : Colors.white38
                          : selectedIndex == 1
                              ? primaryColor
                              : Colors.black12,
                      radius: 72,
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          children: [
                            Image.asset("assets/icons/female.png",
                                height: 50,
                                color: themeChange.darkTheme
                                    ? selectedIndex == 1
                                        ? Colors.white
                                        : Colors.white
                                    : selectedIndex == 1
                                        ? Colors.white
                                        : Colors.black),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Female",
                                style: GoogleFonts.bebasNeue(
                                  color: themeChange.darkTheme
                                      ? selectedIndex == 1
                                          ? Colors.white
                                          : Colors.white
                                      : selectedIndex == 1
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 18,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: themeChange.darkTheme
                          ? selectedIndex == 0
                              ? secondaryColor
                              : Colors.white38
                          : selectedIndex == 0
                              ? secondaryColor
                              : Colors.black12,
                      radius: 72,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/male.png",
                                height: 50,
                                color: themeChange.darkTheme
                                    ? selectedIndex == 0
                                        ? Colors.white
                                        : Colors.white
                                    : selectedIndex == 0
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Male",
                                  style: GoogleFonts.bebasNeue(
                                    color: themeChange.darkTheme
                                        ? selectedIndex == 0
                                            ? Colors.white
                                            : Colors.white
                                        : selectedIndex == 0
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 18,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primaryColor,
                  // gradient: LinearGradient(
                  //   begin: Alignment.topRight,
                  //   end: Alignment.bottomLeft,
                  //   colors: [
                  //     primaryColor,
                  //     secondaryColor,
                  //   ],
                  // ),
                ),
                child: InkWell(
                    child: Center(
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      if (selectedIndex == 0) {
                        ScaffoldMessenger.of(context).clearSnackBars();

                        select_gender = 1;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SelectAge()));
                      } else if (selectedIndex == 1) {
                        ScaffoldMessenger.of(context).clearSnackBars();

                        select_gender = 0;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SelectAge()));
                      } else {
                        GlobalToast.show('Please select gender');
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
