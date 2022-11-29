import 'package:co_op/api/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/constants/custom_page_route.dart';
import 'package:co_op/constants/number_picker.dart';
import 'package:co_op/screens/auth/accountsetup/select_weight.dart';

import '../../../provider/dark_theme_provider.dart';

class SelectAge extends StatefulWidget {
  const SelectAge({Key? key}) : super(key: key);

  @override
  State<SelectAge> createState() => _SelectAgeState();
}

class _SelectAgeState extends State<SelectAge> {
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
                  "How old are you?",
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
                  "Age in years. This will help us to personalize\nan exercise program plan that suits you.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectNumber(),
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
                          print(select_age);
                          Navigator.push(
                            context,
                            CustomPageRoute(
                                child: SelectWeight(),
                                direction: AxisDirection.left),
                          );
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
