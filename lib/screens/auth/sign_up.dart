import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/constants/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:location/location.dart';
// import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/screens/auth/sign_in.dart';
import '../../../provider/dark_theme_provider.dart';
import '../../api/global_variables.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool value = false;
  bool view = true;
  List<Address> addrUser = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController UserNameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  bool loader = false;
  String latitude = '';
  String longitude = '';
  String _pass = '';

  TextEditingController AddressNameController = TextEditingController();
  _nameDialog() {
    AddressNameController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Address Name'),
            content: TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: AddressNameController,
              decoration: InputDecoration(hintText: "Enter address"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    if (AddressNameController.text.isNotEmpty) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: "AIzaSyBDOMNCVC2eacCxKYuRxIwCz4w-QjV_l5Y",
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
                                AddressController.text =
                                    result.formattedAddress.toString();
                                latitude =
                                    result.geometry!.location.lat.toString();
                                longitude =
                                    result.geometry!.location.lng.toString();
                                addrUser.insert(
                                    0,
                                    Address(
                                        AddController: TextEditingController(
                                            text: result.formattedAddress
                                                .toString()),
                                        useraddress: value1,
                                        city: value2,
                                        country: value3,
                                        latitude: result.geometry!.location.lat
                                            .toString(),
                                        longitude: result.geometry!.location.lng
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
                            selectInitialPosition: true,
                            autocompleteOnTrailingWhitespace: true,
                            useCurrentLocation: true,
                            initialPosition: LatLng(31.65465, 31.35153),
                          ),
                        ),
                      );
                    } else {
                      GlobalToast.show('Please add address name');
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    print(profileInfo.email);
    if (profileDetail.email != null) {
      EmailController.text = profileDetail.email.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Container(
                  child: Image.asset(
                    "assets/images/signup.png",
                    height: 20.h,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Signup",
                              style: Theme.of(context).textTheme.headline1),
                        ],
                      ),
                    )),
                    SizedBox(
                      height: 2.h,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                              },
                              controller: UserNameController,
                              showCursor: true,
                              cursorColor: Colors.grey,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 25.0),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  //<-- SEE HERE
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.red),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: Icon(Icons.person),
                                hintText: 'User Name',
                                hintStyle: TextStyle(
                                    color: themeChange.darkTheme
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 2.h,
                                    fontFamily: 'NeueMachina'),
                                filled: true,
                                fillColor: themeChange.darkTheme
                                    ? Colors.white38
                                    : Colors.black12,
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is required';
                                  }
                                },
                                controller: EmailController,
                                showCursor: true,
                                cursorColor: Colors.grey,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 25.0),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    //<-- SEE HERE
                                    borderSide:
                                        BorderSide(width: 1, color: Colors.red),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  prefixIcon: Icon(Icons.mail),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: themeChange.darkTheme
                                          ? Colors.white
                                          : Colors.grey,
                                      fontSize: 2.h,
                                      fontFamily: 'NeueMachina'),
                                  filled: true,
                                  fillColor: themeChange.darkTheme
                                      ? Colors.white38
                                      : Colors.black12,
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  _pass = value;
                                });
                              },
                              controller: PasswordController,
                              showCursor: true,
                              cursorColor: Colors.grey,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              obscureText: view,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 25.0),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  //<-- SEE HERE
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.red),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: Icon(Icons.key),
                                hintText: 'Password',
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      view = !view;
                                    });
                                  },
                                  child: Icon(view
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                hintStyle: TextStyle(
                                    color: themeChange.darkTheme
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 2.h,
                                    fontFamily: 'NeueMachina'),
                                filled: true,
                                fillColor: themeChange.darkTheme
                                    ? Colors.white38
                                    : Colors.black12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _pass.length > 7 || _pass == ''
                        ? SizedBox(
                            height: 2.h,
                          )
                        : Container(
                            width: Get.width,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child:
                                  Text('Password should atleast 8 characters'),
                            ),
                          ),

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                              },
                              controller: ConfirmPasswordController,
                              showCursor: true,
                              cursorColor: Colors.grey,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              obscureText: view,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 25.0),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  //<-- SEE HERE
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.red),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: Icon(Icons.key),
                                hintText: 'Confirm Password',
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      view = !view;
                                    });
                                  },
                                  child: Icon(view
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                hintStyle: TextStyle(
                                    color: themeChange.darkTheme
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 2.h,
                                    fontFamily: 'NeueMachina'),
                                filled: true,
                                fillColor: themeChange.darkTheme
                                    ? Colors.white38
                                    : Colors.black12,
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
                        child: Column(
                          children: [
                            /*  Container(
                                  width: Get.width,
                                  child: Text(
                                    'Address#${index + 1}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ), */
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field is required';
                                    }
                                  },
                                  onTap: () async {
                                    await _nameDialog();
                                    /*  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlacePicker(
                                          apiKey:
                                              "AIzaSyBDOMNCVC2eacCxKYuRxIwCz4w-QjV_l5Y",
                                          onPlacePicked: (result) {
                                            print(result.geometry!.location);
                                            final tagName = result
                                                .formattedAddress
                                                .toString();
                                            print(result.formattedAddress);
                                            final split = tagName.split(',');
                                            final Map<int, String> values = {
                                              for (int i = 0;
                                                  i < split.length;
                                                  i++)
                                                i: split[i]
                                            };
                                            final value1 = values[0];
                                            final value2 = values[1];
                                            final value3 = values[2];
                                            final value4 = values[3];
                                            setState(() {
                                              AddressController.text = result
                                                  .formattedAddress
                                                  .toString();
                                              latitude = result
                                                  .geometry!.location.lat
                                                  .toString();
                                              longitude = result
                                                  .geometry!.location.lng
                                                  .toString();
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
                                                      latitude: result.geometry!
                                                          .location.lat
                                                          .toString(),
                                                      longitude: result
                                                          .geometry!
                                                          .location
                                                          .lng
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
                                          selectInitialPosition: true,
                                          autocompleteOnTrailingWhitespace:
                                              true,
                                          useCurrentLocation: true,
                                          initialPosition:
                                              LatLng(31.65465, 31.35153),
                                        ),
                                      ),
                                    ); */
                                  },
                                  controller: AddressController,
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
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 25.0, horizontal: 5),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.red),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: Icon(Icons.location_on),
                                    hintText: 'Address',
                                    hintStyle: TextStyle(
                                        color: themeChange.darkTheme
                                            ? Colors.white
                                            : Colors.grey,
                                        fontSize: 2.h,
                                        fontFamily: 'NeueMachina'),
                                    filled: true,
                                    fillColor: themeChange.darkTheme
                                        ? Colors.white38
                                        : Colors.black12,
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
                    ),
                    /*   ListView.builder(
                      itemCount: addrUser.length,
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
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 25.0, horizontal: 5),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          //<-- SEE HERE
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.red),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        prefixIcon: Icon(Icons.location_on),
                                        hintText: 'Address',
                                        hintStyle: TextStyle(
                                            color: themeChange.darkTheme
                                                ? Colors.white
                                                : Colors.grey,
                                            fontSize: 2.h,
                                            fontFamily: 'NeueMachina'),
                                        filled: true,
                                        fillColor: themeChange.darkTheme
                                            ? Colors.white38
                                            : Colors.black12,
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Container(
                        height: 5.h,
                        alignment: Alignment.center,
                        child: InkWell(
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
                                  initialPosition: LatLng(31.65465, 31.35153),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: secondaryColor,
                              ),
                              Text(
                                ' Add Address',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ), */
                    /*    SizedBox(
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
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 4),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primaryColor),
                        child: InkWell(
                            child: Center(
                              child: loader
                                  ? spinkit
                                  : Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                            ),
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (UserNameController.text.isNotEmpty &&
                                    EmailController.text.isNotEmpty &&
                                    PasswordController.text.isNotEmpty &&
                                    ConfirmPasswordController.text.isNotEmpty) {
                                  if (PasswordController.text ==
                                      ConfirmPasswordController.text) {
                                    if (PasswordController.text.length > 7) {
                                      if (loader == false) {
                                        bool status = false;
                                        Map<String, dynamic> registerUser = {
                                          'user_name': UserNameController.text,
                                          /* 'nick_name': 'nifty', */
                                          'gender': select_gender.toString(),
                                          'age': select_age.toString(),
                                          'weight': select_weight.toString(),
                                          'height': select_height.toString(),
                                          'goal': select_goal.join(','),
                                          'activity_level': select_level,
                                          /* 'phone_number': '03067100021', */
                                          'email': EmailController.text,
                                          'password': PasswordController.text,
                                          'full_name': profileDetail.fullName,
                                          'nick_name': profileDetail.nickName,
                                          'phone_number':
                                              profileDetail.phoneNumber,
                                          'lat': latitude,
                                          'long': longitude,
                                          // 'sub_category_id':'1,2,3'
                                        };
                                        print(fullName);
                                        setState(() {
                                          loader = true;
                                        });
                                        status = await DataApiService.instance
                                            .register(
                                                UserNameController.text,
                                                select_gender.toString(),
                                                select_age.toString(),
                                                select_weight.toString(),
                                                select_height.toString() +
                                                    '.' +
                                                    select_height_decimal
                                                        .toString(),
                                                select_goal.join(','),
                                                select_level.toString(),
                                                EmailController.text,
                                                PasswordController.text,
                                                profileDetail.fullName
                                                    .toString(),
                                                profileDetail.nickName
                                                    .toString(),
                                                profileDetail.phoneNumber
                                                    .toString(),
                                                latitude,
                                                longitude,
                                                AddressController.text,
                                                AddressNameController.text,
                                                imagepath,
                                                context);

                                        setState(() {
                                          loader = false;
                                        });
                                        if (status) {
                                          /*  customDialog(
                                          context: context,
                                          title: 'Sign Up',
                                          middleText: SnackMessage.toString(),
                                          content: ElevatedButton(
                                              onPressed: () {
                                                Get.offAll(() => SignIn());
                                              },
                                              child: Text("Login")),
                                          hasContent: true); */
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.SUCCES,
                                            animType: AnimType.BOTTOMSLIDE,
                                            title: 'Sign Up',
                                            desc: SnackMessage,
                                            btnOkOnPress: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignIn()));
                                            },
                                          ).show();
                                        } else {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.bottomSlide,
                                            title: 'Sign Up',
                                            desc: SnackMessage,
                                            btnOkOnPress: () {
                                              UserNameController.clear();
                                              EmailController.clear();
                                              PasswordController.clear();
                                            },
                                          ).show();
                                        }
                                      }
                                    } else {
                                      GlobalToast.show(
                                          'Password should atleast 8 characters');
                                    }
                                  } else {
                                    GlobalToast.show('Passwords do not match');
                                  }
                                }
                              }
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SelectAge()));
                            }),
                      ),
                    ),

                    ///Social Icons
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Expanded(
                    //         child: Divider(
                    //           height: 0,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //       Text("  or continue with  ", style: TextStyle(fontSize: 16),),
                    //       Expanded(
                    //         child: Divider(
                    //           height: 0,
                    //           color: Colors.black,),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 3.h,),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SocialLoginButton(
                    //       buttonType: SocialLoginButtonType.google,
                    //       text: "",
                    //       onPressed: () {},
                    //       mode: SocialLoginButtonMode.single,
                    //     ),
                    //     SizedBox(width: 20,),
                    //     SocialLoginButton(
                    //       buttonType: SocialLoginButtonType.facebook,
                    //       text: "",
                    //       onPressed: () {},
                    //       mode: SocialLoginButtonMode.single,
                    //     ),
                    //     SizedBox(width: 20,),
                    //     SocialLoginButton(
                    //       buttonType: SocialLoginButtonType.appleBlack,
                    //       text: "",
                    //       onPressed: () {},
                    //       mode: SocialLoginButtonMode.single,
                    //     ),
                    //   ],
                    // ),

                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Have an account? "),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SignIn()));
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
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
