import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/auth/accountsetup/profile_detail.dart';
import 'package:co_op/screens/auth/accountsetup/select_age.dart';
import 'package:co_op/screens/auth/accountsetup/select_height.dart';

import '../../../constants/custom_dialog.dart';
import '../../../constants/custom_page_route.dart';
import '../../../provider/dark_theme_provider.dart';

class ChooseInterest extends StatefulWidget {
  const ChooseInterest({Key? key}) : super(key: key);

  @override
  State<ChooseInterest> createState() => _ChooseInterestState();
}

class _ChooseInterestState extends State<ChooseInterest> {
  int selectedIndex = -1;
  List<int> selectedIndexesSports = [];
  List<int> selectedIndexesCardio = [];
  List<int> selectedIndexesYoga = [];
  List<int> selectedIndexesWeightlifting = [];
  bool value = false;
  List<String> sports = [
    'Cricket',
    'Football',
    'Badminton',
    'Tennis',
    'Basketball',
    'Others'
  ];
  List<String> cardio = [
    'Cricket',
    'Football',
    'Badminton',
    'Tennis',
    'Basketball',
    'Others'
  ];
  List<String> yoga = [
    'Cricket',
    'Football',
    'Badminton',
    'Tennis',
    'Basketball',
    'Others'
  ];
  List<String> weightlifting = [
    'Cricket',
    'Football',
    'Badminton',
    'Tennis',
    'Basketball',
    'Others'
  ];
  bool _customTileExpandedSports = false;
  bool _customTileExpandedCardio = false;
  bool _customTileExpandedYoga = false;
  bool _customTileExpandedWeightlifting = false;
  bool buttonLoader = false;
  @override
  void initState() {
    super.initState();
    if (interestNavigation == false) {
      filterList.clear();
    } else {
      print(profileInfo.subCategoryId.length);
      if (profileInfo.subCategoryId.isNotEmpty) {
        filterList = profileInfo.subCategoryId;
      } else {
        filterList.clear();
      }
    }
  }

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
                  "Choose your interest",
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
                  "To give you a better experience and results\nwe need to know your interest",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: getfilterList.length,
                      itemBuilder: (BuildContext context, int indexl) {
                        return ExpansionTile(
                          title: Text(getfilterList[indexl].title,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          subtitle: const Text('Please choose your interest'),
                          trailing: Icon(
                            _customTileExpandedSports
                                ? Icons.arrow_drop_down_circle
                                : Icons.arrow_drop_down,
                          ),
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      getfilterList[indexl].getSubCate!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      leading: Checkbox(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        onChanged: (x) {
                                          setState(() {
                                            if (filterList.contains(
                                                getfilterList[indexl]
                                                    .getSubCate![index]
                                                    .id
                                                    .toString())) {
                                              filterList.remove(
                                                  getfilterList[indexl]
                                                      .getSubCate![index]
                                                      .id
                                                      .toString());
                                            } else {
                                              filterList.add(
                                                  getfilterList[indexl]
                                                      .getSubCate![index]
                                                      .id
                                                      .toString());
                                            }
                                          });
                                          print(filterList);
                                        },
                                        activeColor: secondaryColor,
                                        value: filterList.contains(
                                            getfilterList[indexl]
                                                .getSubCate![index]
                                                .id
                                                .toString()),
                                      ),
                                      title: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (filterList.contains(
                                                getfilterList[indexl]
                                                    .getSubCate![index]
                                                    .id
                                                    .toString())) {
                                              filterList.remove(
                                                  getfilterList[indexl]
                                                      .getSubCate![index]
                                                      .id
                                                      .toString());
                                            } else {
                                              filterList.add(
                                                  getfilterList[indexl]
                                                      .getSubCate![index]
                                                      .id
                                                      .toString());
                                            }
                                          });
                                          print(filterList);
                                        },
                                        child: Text(
                                          getfilterList[indexl]
                                              .getSubCate![index]
                                              .title,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ),
                                    );
                                  },
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 3,
                                          crossAxisCount: 2),
                                ))
                          ],
                          onExpansionChanged: (bool expanded) {
                            setState(
                                () => _customTileExpandedSports = expanded);
                          },
                        );
                      },
                    ),
                  ],
                ),
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
                          interestNavigation = false;
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
                        onTap: () async {
                          if (interestNavigation == false) {
                            if (filterList.isNotEmpty) {
                              imagepath='';
                              Navigator.push(
                                context,
                                CustomPageRoute(
                                    child: ProfileDetail(),
                                    direction: AxisDirection.left),
                              );
                            } else {
                              GlobalToast.show(
                                  'Please select atleast one option');
                            }
                          } else {
                            setState(() {
                              buttonLoader = true;
                            });

                            if (filterList.isNotEmpty) {
                              print(filterList.join(','));
                              await DataApiService.instance.updateInterest(
                                  filterList.join(','), context);
                              await DataApiService.instance
                                  .getprofileinfo(context);
                              interestNavigation = false;

                              Get.back();
                            } else {
                              setState(() {
                                buttonLoader = false;
                              });
                              GlobalToast.show(
                                  'Please select atleast one option');
                            }
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
                              buttonLoader
                                  ? spinkit
                                  : Text(
                                      interestNavigation == false
                                          ? "Continue"
                                          : "Save",
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
