import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';


customDialog(
    {required BuildContext context,
    required String title,
    required String middleText,
    required Widget content,
    required bool hasContent}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 56.h,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  child: CircleAvatar(
                                radius: 8.h,
                                backgroundImage: AssetImage(
                                  "assets/images/muscles.webp",
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3),
                        SizedBox(height: 10),
                        Text(middleText,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  hasContent
                      ? content
                      : Container(
                          height: 6.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: secondaryColor),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                                child: Text("Okay",
                                    style: TextStyle(
                                        fontSize: 2.1.h, color: Colors.white))),
                          ),
                        ),
                ],
              ),
            ),
          );
        });
      });
}

class GlobalSnackBar {
  final String message;

  const GlobalSnackBar({
    required this.message,
  });

  static show(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0.0,
        //behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: new Duration(milliseconds: 500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        ),
      ),
    );
  }
}

class GlobalToast {
  final String message;

  const GlobalToast({
    required this.message,
  });

  static show(
    String message,
  ) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
