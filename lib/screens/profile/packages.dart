import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/packages.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white,
              ],
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 10,
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
        ),
        Positioned(
          top: 200,
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14),

          ),
        ),
        Positioned(
          bottom: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 95.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Be Premium",
                        style: TextStyle(
                            fontSize: 4.h,
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                            // shadows: const [
                            //   Shadow( // bottomLeft
                            //       offset: Offset(-1.5, -1.5),
                            //       color: primaryColor
                            //   ),
                            //   Shadow( // bottomRight
                            //       offset: Offset(1.5, -1.5),
                            //       color: primaryColor
                            //   ),
                            //   Shadow( // topRight
                            //       offset: Offset(1.5, 1.5),
                            //       color: primaryColor
                            //   ),
                            //   Shadow( // topLeft
                            //       offset: Offset(-1.5, 1.5),
                            //       color: primaryColor
                            //   ),
                            // ]
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Get Unlimited Access",
                        style: TextStyle(
                            fontSize: 3.h,
                            color: primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Enjoy workout access without ads and restrictions",
                          style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
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
                        height: 10.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: selectedIndex == 0
                                ? secondaryColor.withOpacity(0.8)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: selectedIndex == 0
                                    ? secondaryColor
                                    : Colors.transparent,
                                width: 3)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  height: 2.h,
                                  width: 2.h,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: selectedIndex == 0
                                              ? primaryColor
                                              : Colors.black)),
                                  child: selectedIndex == 0
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            height: 2.h,
                                            width: 2.h,
                                            decoration: BoxDecoration(
                                              color: selectedIndex == 0
                                                  ? primaryColor
                                                  : Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("1 Month",
                                      style: TextStyle(
                                          color: selectedIndex == 0
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1)),
                                  Text("Pay once cancel anytime",
                                      style: TextStyle(
                                          color: selectedIndex == 0
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1)),
                                ],
                              ),
                              Text("\$16.99/m",
                                  style: TextStyle(
                                      color: selectedIndex == 0
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1))
                            ],
                          ),
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
                        height: 10.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: selectedIndex == 1
                                ? secondaryColor.withOpacity(0.8)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: selectedIndex == 1
                                    ? secondaryColor
                                    : Colors.transparent,
                                width: 3)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  height: 2.h,
                                  width: 2.h,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: selectedIndex == 1
                                              ? primaryColor
                                              : Colors.black)),
                                  child: selectedIndex == 1
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            height: 2.h,
                                            width: 2.h,
                                            decoration: BoxDecoration(
                                              color: selectedIndex == 1
                                                  ? primaryColor
                                                  : Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("6 Months",
                                      style: TextStyle(
                                          color: selectedIndex == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1)),
                                  Text("Pay once cancel anytime",
                                      style: TextStyle(
                                          color: selectedIndex == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1)),
                                ],
                              ),
                              Text("\$66.99/m",
                                  style: TextStyle(
                                      color: selectedIndex == 1
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1))
                            ],
                          ),
                        ),
                      ),
                    ),
                   const SizedBox(
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
                        height: 10.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: selectedIndex == 2
                                ? secondaryColor.withOpacity(0.8)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: selectedIndex == 2
                                    ? secondaryColor
                                    : Colors.transparent,
                                width: 3)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  height: 2.h,
                                  width: 2.h,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: selectedIndex == 2
                                              ? primaryColor
                                              : Colors.black)),
                                  child: selectedIndex == 2
                                      ? Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            height: 2.h,
                                            width: 2.h,
                                            decoration: BoxDecoration(
                                              color: selectedIndex == 2
                                                  ? primaryColor
                                                  : Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("12 Months",
                                      style: TextStyle(
                                          color: selectedIndex == 2
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1)),
                                  Text("Pay once cancel anytime",
                                      style: TextStyle(
                                          color: selectedIndex == 2
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1)),
                                ],
                              ),
                              Text("\$166.99/m",
                                  style: TextStyle(
                                      color: selectedIndex == 2
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 90.w,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor),
                  child: InkWell(
                      child: Center(
                        child: const Text(
                          'Subscribe',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
                      }),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
