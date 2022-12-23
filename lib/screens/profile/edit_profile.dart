import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/constants/custom_dialog.dart';
import 'package:co_op/screens/profile/profile_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../api/global_variables.dart';
import '../../constants/constants.dart';
import '../../constants/custom_page_route.dart';
import '../../constants/noInternet.dart';
import '../../provider/dark_theme_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController FullNameController = TextEditingController();
  TextEditingController NickNameController = TextEditingController();
  TextEditingController PhoneNumberController = TextEditingController();
  TextEditingController UsernameController = TextEditingController();
  TextEditingController AgeController = TextEditingController();
  TextEditingController WeightController = TextEditingController();
  TextEditingController HeightController = TextEditingController();
  File? file;
  String updateImage = '';
  List<Address> addrUser = [];
  bool loader = false;
  bool view = true;

  int selectedIndex = 0;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;
    updateImage = path;
    setState(() => file = File(path));
  }

  List<String> imageList = [
    "assets/images/stretching.jpg",
    "assets/images/stretching.jpg",
    "assets/images/stretching.jpg",
    "assets/images/stretching.jpg",
    "assets/images/stretching.jpg",
  ];

  initialize() {
    if (profileInfo.fullName != null && profileInfo.fullName != 'null') {
      FullNameController.text = profileInfo.fullName.toString();
    }
    if (profileInfo.nickName != 'null' && profileInfo.nickName != null) {
      NickNameController.text = profileInfo.nickName.toString();
    }
    if (profileInfo.phone != null && profileInfo.phone != 'null') {
      PhoneNumberController.text = profileInfo.phone.toString();
    }
    if (profileInfo.activityLevel == 'Beginner') {
      selectedIndex = 0;
    } else if (profileInfo.activityLevel == 'Intermediate') {
      selectedIndex = 1;
    } else if (profileInfo.activityLevel == 'Advanced') {
      selectedIndex = 2;
    }

    UsernameController.text = profileInfo.userName.toString();
    AgeController.text = profileInfo.age.toString();
    WeightController.text = profileInfo.weight.toString();
    HeightController.text = profileInfo.height.toString();
  }

  List<File> multipleImages = [];

  selectMultipleImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      multipleImages =
          multipleImages + result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
  }

  bool pageLoader = false;

  callApi() async {
    setState(() {
      pageLoader = true;
    });
    await DataApiService.instance.getAddressList(context);
    for (var i = 0; i < getAddrList.length; i++) {
      addrUser.add(Address(
          AddController:
              TextEditingController(text: getAddrList[i].locationName)));
    }
    setState(() {
      pageLoader = false;
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text(
          "Edit your profile",
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: connected == false
          ? NoInternet(
              page: EditProfile(),
            )
          : pageLoader
              ? Center(child: pageSpinkit)
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Stack(children: [
                              file == null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        height: 20.h,
                                        width: 20.h,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            'https://becktesting.site/workout-bud/public/storage/user/' +
                                                profileInfo.image.toString(),
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/images/intro1.png',
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.fill,
                                        ),
                                        errorWidget: (context, url,
                                                error) => /* Icon(Icons
                            .person) */
                                            Image.asset(
                                                'assets/images/intro1.png',
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.fill),
                                      ),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: Get.width,
                                child: Text(
                                  'Full Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Container(
                                  height: 8.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 0),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: Get.width,
                                child: Text(
                                  'Nick Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Container(
                                  height: 8.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: Get.width,
                                child: Text(
                                  'User Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Container(
                                  height: 8.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
                                    child: TextField(
                                      controller: UsernameController,
                                      showCursor: true,
                                      cursorColor: Colors.grey,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        prefixIcon: Icon(Icons.mail),
                                        hintText: 'Username',
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
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: Get.width,
                                child: Text(
                                  'Phone Number',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Container(
                                  height: 8.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
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
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 25.w,
                                child: Text(
                                  'Age',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 25.w,
                                child: Text(
                                  'Weight',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 25.w,
                                child: Text(
                                  'Height',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 8.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 8, 5, 0),
                                  child: TextField(
                                    controller: AgeController,
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
                                      hintText: 'Age',
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
                              Container(
                                height: 8.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 8, 5, 0),
                                  child: TextField(
                                    controller: WeightController,
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
                                      hintText: 'Weight',
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
                              Container(
                                height: 8.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 8, 5, 0),
                                  child: TextField(
                                    controller: HeightController,
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
                                      hintText: 'Height',
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
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Container(
                            width: Get.width,
                            child: Text(
                              'Activity level',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  width: 25.w,
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
                                              fontSize: 10,
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
                                  width: 25.w,
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
                                            fontSize: 10,
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
                                  width: 25.w,
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
                                            fontSize: 10,
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
                          height: 2.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Container(
                            width: Get.width,
                            child: Text(
                              'Workout Images',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        profileInfo.imageList.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Container(
                                  padding: EdgeInsets.only(right: 20),
                                  height: 150,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Row(
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  profileInfo.imageList[0]
                                                      .images.length;
                                              i++)
                                            Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () async {},
                                                  child: Container(
                                                    height: 140,
                                                    width: 140,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                        ),
                                                        color: Colors.white),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: /* Image.asset(
                                                      imageList[i],
                                                      fit: BoxFit
                                                          .cover) */
                                                            Image.network(
                                                          'https://becktesting.site/workout-bud/public/storage/user/workout/' +
                                                              profileInfo
                                                                  .imageList[0]
                                                                  .images[i],
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                        )),
                                                  ),
                                                ),
                                                Positioned(
                                                    right: 5,
                                                    top: 5,
                                                    child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            DataApiService
                                                                .instance
                                                                .deleteImage(
                                                                    profileInfo
                                                                        .imageList[
                                                                            0]
                                                                        .images[i],
                                                                    context);
                                                            profileInfo
                                                                .imageList[0]
                                                                .images
                                                                .removeAt(i);
                                                          });
                                                          print(i);
                                                          print(profileInfo
                                                              .imageList[0]
                                                              .images
                                                              .length);

                                                          print(
                                                              "helooooooooooooo");
                                                        },
                                                        child:
                                                            Icon(Icons.close)))
                                              ],
                                            ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          for (int i = 0;
                                              i < multipleImages.length;
                                              i++)
                                            Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    await selectMultipleImages();
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    height: 140,
                                                    width: 140,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(0.4),
                                                        ),
                                                        color: Colors.white),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: imageList.isEmpty
                                                          ? DottedBorder(
                                                              dashPattern: [
                                                                4,
                                                                6
                                                              ],
                                                              strokeWidth: 2,
                                                              color:
                                                                  Colors.grey,
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/upload.png',
                                                                  height: 5.h,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                ),
                                                              ),
                                                            )
                                                          : Image.file(
                                                              File(
                                                                  multipleImages[
                                                                          i]
                                                                      .path),
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                    right: 5,
                                                    top: 5,
                                                    child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            multipleImages
                                                                .removeAt(i);
                                                          });

                                                          print(
                                                              "helooooooooooooo");
                                                        },
                                                        child:
                                                            Icon(Icons.close)))
                                              ],
                                            ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await selectMultipleImages();
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 140,
                                          width: 140,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                              ),
                                              color: Colors.white),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: DottedBorder(
                                                dashPattern: [4, 6],
                                                strokeWidth: 2,
                                                color: Colors.grey,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Image.asset(
                                                    'assets/images/upload.png',
                                                    height: 5.h,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : multipleImages.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              for (int i = 0;
                                                  i < multipleImages.length;
                                                  i++)
                                                Stack(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        // await selectMultipleImages();
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        height: 140,
                                                        width: 140,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.4),
                                                                ),
                                                                color: Colors
                                                                    .white),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: imageList
                                                                  .isEmpty
                                                              ? DottedBorder(
                                                                  dashPattern: [
                                                                    4,
                                                                    6
                                                                  ],
                                                                  strokeWidth:
                                                                      2,
                                                                  color: Colors
                                                                      .grey,
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Image
                                                                        .file(
                                                                      File(multipleImages[
                                                                              index]
                                                                          .path),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: double
                                                                          .infinity,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Image.file(
                                                                  File(multipleImages[
                                                                          i]
                                                                      .path),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: double
                                                                      .infinity,
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        right: 5,
                                                        top: 5,
                                                        child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                multipleImages
                                                                    .removeAt(
                                                                        i);
                                                              });

                                                              print(
                                                                  "helooooooooooooo");
                                                            },
                                                            child: Icon(
                                                                Icons.close)))
                                                  ],
                                                ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await selectMultipleImages();
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 140,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    5)),
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                        color: Colors.white),
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: /* myImages[i].isEmpty
                                                      ?  */
                                                            DottedBorder(
                                                          dashPattern: [4, 6],
                                                          strokeWidth: 2,
                                                          color: Colors.grey,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Image.asset(
                                                              'assets/images/upload.png',
                                                              height: 4.h,
                                                            ),
                                                          ),
                                                        )
                                                        /* : Image.file(
                                                          File(myImages[i]),
                                                          fit: BoxFit.cover,
                                                          width: double.infinity,
                                                        ), */
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: () async {
                                              await selectMultipleImages();
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                    color: Colors.white),
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: /* myImages[i].isEmpty
                                                    ?  */
                                                        DottedBorder(
                                                      dashPattern: [4, 6],
                                                      strokeWidth: 2,
                                                      color: Colors.grey,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Image.asset(
                                                          'assets/images/upload.png',
                                                          height: 4.h,
                                                        ),
                                                      ),
                                                    )
                                                    /* : Image.file(
                                                        File(myImages[i]),
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ), */
                                                    ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                        /*       SizedBox(
                      height: 2.h,
                    ),
                    ListView.builder(
                      itemCount: getAddrList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
                                  child: Text(
                                    'Address#${index + 1}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 8.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 8, 24, 0),
                                    child: TextField(
                                      onTap: () {},
                                      controller: addrUser[index].AddController,
                                      readOnly: true,
                                      showCursor: false,
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
                                        prefixIcon: Icon(Icons.location_pin),
                                        hintText:
                                            getAddrList[index].locationName,
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
                                SizedBox(
                                  height: 2.h,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        width: Get.width,
                        child: Text(
                          'Add Address',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacePicker(
                                      apiKey:
                                          "AIzaSyBDOMNCVC2eacCxKYuRxIwCz4w-QjV_l5Y",
                                      onPlacePicked: (result) {
                                        print(result.geometry!.location);
                                        final tagName =
                                            result.formattedAddress.toString();
                                        print(result.formattedAddress);
                                        final split = tagName.split(',');
                                        final Map<int, String> values = {
                                          for (int i = 0; i < split.length; i++)
                                            i: split[i]
                                        };
                                        final value1 = values[0];
                                        final value2 = values[1];
                                        final value3 = values[2];
                                        final value4 = values[3];
                                        setState(() {

                                          addrUser.insert(
                                              0,
                                              Address(
                                                  AddController:
                                                      TextEditingController(
                                                          text: result
                                                              .formattedAddress
                                                              .toString()),
                                                  useraddress: value1,
                                                  city: value2,
                                                  country: value3,
                                                  latitude: result
                                                      .geometry!.location.lat
                                                      .toString(),
                                                  longitude: result
                                                      .geometry!.location.lng
                                                      .toString()));

                                          /*   if(value1!=null) {
                                              address.text = value1.toString();
                                            }
                                            if(value2!=null) {
                                              houseNo.text = value2.toString();
                                            }
                                            if(value3!=null) {
                                              city.text = value3.toString();
                                            } */
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      useCurrentLocation: true,
                                      initialPosition:
                                          LatLng(31.65465, 31.35153),
                                    ),
                                  ),
                                );
                              },
                              readOnly: true,
                              showCursor: false,
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
                                prefixIcon: Icon(Icons.location_pin),
                                hintText: 'Address',
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
                    ), */
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (loader == false) {
                                        print('click');
                                        setState(() {
                                          loader = true;
                                        });

                                        if (updateImage == '') {
                                          Map<String, dynamic> update = {
                                            if (profileInfo.userName !=
                                                UsernameController.text)
                                              'user_name':
                                                  UsernameController.text,
                                            'gender':
                                                profileInfo.gender.toString(),
                                            'age': AgeController.text,
                                            'weight': WeightController.text,
                                            'height': HeightController.text,
                                            if (NickNameController
                                                .text.isNotEmpty)
                                              'nick_name':
                                                  NickNameController.text,
                                            if (FullNameController
                                                .text.isNotEmpty)
                                              'full_name':
                                                  FullNameController.text,
                                            if (PhoneNumberController
                                                .text.isNotEmpty)
                                              'phone_number':
                                                  PhoneNumberController.text,
                                            if (selectedIndex == 0)
                                              'activity_level': 'Beginner',
                                            if (selectedIndex == 1)
                                              'activity_level': 'Intermediate',
                                            if (selectedIndex == 2)
                                              'activity_level': 'Advanced',
                                          };
                                          bool status = await DataApiService
                                              .instance
                                              .updateProfileWithoutImage(
                                                  update, context);
                                          if (status) {
                                            if (multipleImages.isNotEmpty) {
                                              await DataApiService.instance
                                                  .uploadImages(
                                                      multipleImages, context);
                                            }
                                            await DataApiService.instance
                                                .getprofileinfo(context);

                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProfilePage()));
                                          } else {
                                            GlobalToast.show(SnackMessage!);
                                          }
                                        } else {
                                          bool status1 = await DataApiService
                                              .instance
                                              .updateProfile(
                                                  profileInfo.gender.toString(),
                                                  UsernameController.text,
                                                  AgeController.text,
                                                  WeightController.text,
                                                  HeightController.text,
                                                  FullNameController.text,
                                                  NickNameController.text,
                                                  PhoneNumberController.text,
                                                  selectedIndex,
                                                  updateImage,
                                                  context);
                                          if (status1) {
                                            if (multipleImages.isNotEmpty) {
                                              await DataApiService.instance
                                                  .uploadImages(
                                                      multipleImages, context);
                                            }
                                            await DataApiService.instance
                                                .getprofileinfo(context);

                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProfilePage()));
                                          } else {
                                            GlobalToast.show(SnackMessage!);
                                          }
                                        }
                                        setState(() {
                                          loader = false;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 6.h,
                                      width: 80.w,
                                      margin: EdgeInsets.only(bottom: 0),
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          loader
                                              ? spinkit
                                              : Text(
                                                  "Save",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 1.8.h,
                                                      fontWeight:
                                                          FontWeight.w600),
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

class Address {
  Address({
    this.useraddress,
    this.hashcode,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.AddController,
  });

  String? useraddress;
  String? hashcode;
  String? city;
  String? country;
  String? latitude;
  String? longitude;
  TextEditingController? AddController;
}
