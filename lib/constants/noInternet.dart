import 'package:co_op/search/track_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../api/global_variables.dart';

class NoInternet extends StatefulWidget {
  final page;
  const NoInternet({Key? key, required this.page}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  bool _isNetworkAvail = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          height: 20.h,
        ),
        // Image.asset('assets/images/No_Internet.jpg',scale: 5,),
        SizedBox(
          height: 4.h,
        ),
        Text(
          'No Internet Available',
        ),
        SizedBox(
          height: 4.h,
        ),
        InkWell(
          onTap: () {
            Future.delayed(const Duration(seconds: 2)).then((_) async {
              _isNetworkAvail = await isNetworkAvailable();
              if (_isNetworkAvail) {
                print('available');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => widget.page));
              } else {
                if (mounted) setState(() {});
              }
            });
          },
          child: Container(
            width: 30.w,
            height: 5.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(5)),
            child: Text(
              'Try Again',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ]),
    );
  }
}
