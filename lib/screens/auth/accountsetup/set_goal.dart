import 'package:co_op/constants/custom_dialog.dart';
import 'package:co_op/screens/auth/accountsetup/choose_interest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/constants/number_picker.dart';
import 'package:co_op/screens/auth/accountsetup/physical_activity.dart';
import 'package:co_op/screens/auth/accountsetup/select_height.dart';
import 'package:co_op/screens/auth/accountsetup/select_weight.dart';

import '../../../api/global_variables.dart';
import '../../../constants/custom_page_route.dart';
import '../../../provider/dark_theme_provider.dart';

class SetGoal extends StatefulWidget {
  const SetGoal({Key? key}) : super(key: key);

  @override
  State<SetGoal> createState() => _SetGoalState();
}

class _SetGoalState extends State<SetGoal> {
  int selectedIndex = -1;
  bool value = false;
  List<int> _selectedIndex = [];

  List<String> goal = [
    'Get Fitter',
    'Gain Weight',
    'Lose Weight',
    'Building Muscles',
    'Improving Endurance',
    'Others'
  ];

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
                  "What is your goal?",
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
                SizedBox(
                  width: 88.w,
                  child: Text(
                    "You can choose more than one, Don\'t worry, you can always change it later.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        if (_selectedIndex.contains(index)) {
                          _selectedIndex.remove(index);
                          select_goal.remove(goal[index]);
                        } else {
                        if(index==1){
                          if(!_selectedIndex.contains(2)){
                            _selectedIndex.add(index);
                            select_goal.add(goal[index]);
                          }
                        }
                       else if(index==2){
                          if(!_selectedIndex.contains(1)){
                            _selectedIndex.add(index);
                            select_goal.add(goal[index]);
                          }
                        }else{
                          _selectedIndex.add(index);
                          select_goal.add(goal[index]);
                        }

                        }
                        setState(() {});
                        print(select_goal);
                      },
                      child: Container(
                        height: 8.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                            color: _selectedIndex.contains(index)
                                ? Colors.white
                                : Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 3,
                                color: _selectedIndex.contains(index)
                                    ? secondaryColor
                                    : Colors.transparent)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                goal[index],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Checkbox(
                                activeColor: secondaryColor,
                                side: BorderSide(color: Colors.grey),
                                checkColor: Colors.white,
                                value: _selectedIndex.contains(index),
                                onChanged: (value) {
                                  if (_selectedIndex.contains(index)) {
                                    _selectedIndex.remove(index);
                                    select_goal.remove(goal[index]);
                                  } else {
                                    if(index==1){
                                      if(!_selectedIndex.contains(2)){
                                        _selectedIndex.add(index);
                                        select_goal.add(goal[index]);
                                      }
                                    }
                                   else if(index==2){
                                      if(!_selectedIndex.contains(1)){
                                        _selectedIndex.add(index);
                                        select_goal.add(goal[index]);
                                      }
                                    }else{
                                      _selectedIndex.add(index);
                                      select_goal.add(goal[index]);
                                    }
                                  }
                                  setState(() {});
                                  print(select_goal);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
                          select_goal.clear();
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
                          print(select_goal);
                          if (select_goal.isNotEmpty) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  child: ChooseInterest(),
                                  direction: AxisDirection.left),
                            );
                          } else {
                            GlobalToast.show('Please select goal');
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
