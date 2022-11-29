import 'package:co_op/api/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/auth/accountsetup/profile_detail.dart';
import 'package:co_op/screens/auth/accountsetup/select_age.dart';
import 'package:co_op/screens/auth/accountsetup/select_height.dart';

import '../../../constants/custom_dialog.dart';
import '../../../constants/custom_page_route.dart';
import '../../../provider/dark_theme_provider.dart';

class PhysicalActivity extends StatefulWidget {
  const PhysicalActivity({Key? key}) : super(key: key);

  @override
  State<PhysicalActivity> createState() => _PhysicalActivityState();
}

class _PhysicalActivityState extends State<PhysicalActivity> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Physical activity level?",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "To give you a better experience and results\nwe need to know your gender",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: Container(
                      height: 8.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: selectedIndex == 0
                            ? secondaryColor
                            : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Beginner",
                              style: TextStyle(
                                  color: selectedIndex == 0
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Container(
                      height: 8.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: selectedIndex == 1
                            ? secondaryColor
                            : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Intermediate",
                            style: TextStyle(
                                color: selectedIndex == 1
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    child: Container(
                      height: 8.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: selectedIndex == 2
                            ? secondaryColor
                            : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Advanced",
                            style: TextStyle(
                                color: selectedIndex == 2
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 6.h,
                          width: 38.w,
                          margin: EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Back",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (selectedIndex == 0) {
                             ScaffoldMessenger.of(context).clearSnackBars();
                            select_level = 'Beginner';
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  child: ProfileDetail(),
                                  direction: AxisDirection.left),
                            );
                          } else if (selectedIndex == 1) {
                             ScaffoldMessenger.of(context).clearSnackBars();
                            select_level = 'Intermediate';
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  child: ProfileDetail(),
                                  direction: AxisDirection.left),
                            );
                          } else if (selectedIndex == 2) {
                             ScaffoldMessenger.of(context).clearSnackBars();
                            select_level = 'Advanced';
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  child: ProfileDetail(),
                                  direction: AxisDirection.left),
                            );
                          } else {
                            GlobalSnackBar.show(
                                context, 'Please select acitivity level');
                          }
                        },
                        child: Container(
                          height: 6.h,
                          width: 38.w,
                          margin: EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Continue",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 1.8.h,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
