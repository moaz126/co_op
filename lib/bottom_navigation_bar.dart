import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/home/home_page.dart';
import 'package:co_op/screens/insight.dart';
import 'package:co_op/screens/profile/profile_page.dart';
import 'package:co_op/search/search.dart';
import 'package:co_op/search/track_screen.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}
class _BottomNavBarState extends State<BottomNavBar> {
  int index = -1;
  @override
  void initState() {
    index = widget.index;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        // currentIndex: index,
        onTap: (value) {
          if (value == 0) {
            Get.off(()=>HomePage());
          }
          else if (value == 1) {
            Get.off(()=>TrackScreen());
          }
          else if (value == 2) {
            Get.off(()=>Insight());
          }
          else if (value == 3) {
            Get.off(()=>ProfilePage());
          }

        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(.60),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: index == 0
                        ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child:
                      Icon(Icons.home_filled,color: secondaryColor,),
                    )
                        : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child:Icon(Icons.home_filled,color: Colors.grey,),
                    ),
                  ),
                  index == 0?
                  Text(
                  "Home",
                    style: TextStyle(fontSize: 13,
                        fontFamily: 'Interbold', color: secondaryColor),
                  ):Text(
                    "Home",
                    style: TextStyle(fontSize: 13,
                        fontFamily: 'Interbold',
                        color: Colors.grey),)
                ],
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: index == 1
                        ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child:Container(
                          height: 2.7.h,
                          child: Icon(Icons.search,color: secondaryColor,)),)
                        : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                          height: 2.7.h,
                          child: Icon(Icons.search,color: Colors.grey,)),
                    ),
                  ),
                  index == 1?
                  Text(
    "Search",
                    style: TextStyle(fontSize: 13,
                        fontFamily: 'Interbold', color: secondaryColor),
                  ):Text(
    "Search",
                    style: TextStyle(fontSize: 13,
                        fontFamily: 'Interbold',
                        color: Colors.grey),)
                ],
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: index == 2
                        ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child:Container(
                        height: 2.7.h,
                        child: Icon(Icons.insert_chart,color: secondaryColor,

                        ),
                      )
                    )
                        : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                          height: 2.7.h,
                          child: Icon(Icons.insert_chart,color: Colors.grey,)),
                    ),
                  ),
                  index == 2?
                  Text(
                  "Insight",
                    style: TextStyle(fontSize: 13,
                        fontFamily: 'Interbold', color: secondaryColor),
                  ):Text(
    "Insight",
                    style: TextStyle(fontSize: 13,
                        fontFamily: 'Interbold',
                        color: Colors.grey),)
                ],
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: index == 3
                          ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(Icons.person,color: secondaryColor,)
                      )
                          : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(Icons.person,color: Colors.grey,)
                      )),
                  index == 3?
                  Text(
    "Profile",
                    style: TextStyle(fontSize: 13,
                    fontFamily: 'Interbold', color: secondaryColor),
                  ):Text(
    "Profile",
                    style: TextStyle(fontSize: 13,
                        fontFamily: 'Interbold',
                    color: Colors.grey),)
                ],
              ),
              label: ''),

        ],
      );
  }
}