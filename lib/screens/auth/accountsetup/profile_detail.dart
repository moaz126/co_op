import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';

import 'package:co_op/screens/auth/sign_up.dart';


import '../../../api/global_variables.dart';
import '../../../constants/custom_page_route.dart';
import '../../../provider/dark_theme_provider.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  TextEditingController FullNameController = TextEditingController();
  TextEditingController NickNameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PhoneNumberController = TextEditingController();
   File? file;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.image);

    if (result == null) return;
    final path = result.files.single.path!;
    imagepath = path;
    setState(() => file = File(path));
  }

  Future<dynamic> _onBackPressed(context) async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Exit',
      desc: 'Do you want to exit app',
      btnCancelOnPress: () {},
      btnCancelText: 'No',
      btnOkText: 'Yes',
      btnOkOnPress: () async {
        SystemNavigator.pop();
      },
    ).show();
  }


  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    "Fill Your Profile",
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
                    "Don\'t worry, you can always change it later. or\nyou can skip it for now.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  Stack(children: [
                    file == null
                        ? CircleAvatar(
                            radius: 80,
                            backgroundImage:
                                AssetImage("assets/images/intro1.png"),
                          )
                        : CircleAvatar(
                            radius: 80,
                            backgroundImage: FileImage(
                              file!,
                            ),
                          ),
                    Positioned(
                        bottom: 3,
                        right: 4,
                        child: InkWell(
                          onTap: () {
                            selectFile();
                          },
                          child: CircleAvatar(
                              backgroundColor: secondaryColor,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              )),
                        ))
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        height: 8.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          child: Center(
                            child: TextField(
                              controller: FullNameController,
                              showCursor: true,
                              cursorColor: Colors.grey,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                prefixIcon: Icon(Icons.person),
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 2.h,
                                    fontFamily: 'NeueMachina'),
                                filled: true,
                                fillColor: Colors.transparent,
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
                        height: 8.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                          child: TextField(
                            controller: NickNameController,
                            showCursor: true,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Nick Name',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 2.h,
                                  fontFamily: 'NeueMachina'),
                              filled: true,
                              fillColor: Colors.transparent,
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
                        height: 8.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                          child: TextField(
                            controller: EmailController,
                            showCursor: true,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.mail),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 2.h,
                                  fontFamily: 'NeueMachina'),
                              filled: true,
                              fillColor: Colors.transparent,
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
                        height: 8.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                          child: TextField(
                            controller: PhoneNumberController,
                            showCursor: true,
                            cursorColor: Colors.grey,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(15)
                            ],
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 2.h,
                                  fontFamily: 'NeueMachina'),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
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
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  child: SignUp(),
                                  direction: AxisDirection.left),
                            );
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
                                  "Skip",
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
                            setUserFirstTime(false);
                            print('hello');
                            print(EmailController.text);
                            if(FullNameController.text.isNotEmpty)
                            profileDetail.fullName = FullNameController.text;
                            if(NickNameController.text.isNotEmpty)
                            profileDetail.nickName = NickNameController.text;
                            if(PhoneNumberController.text.isNotEmpty)
                            profileDetail.phoneNumber =
                                PhoneNumberController.text;
                            if(EmailController.text.isNotEmpty)
                            profileDetail.email = EmailController.text;
                            print('path');
                            print(file);
                            Navigator.push(
                              context,
                              CustomPageRoute(
                                  child: SignUp(),
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
                                  "Start",
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
      ),
    );
  }
}
