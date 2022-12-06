import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:co_op/constants/constants.dart';
import 'package:co_op/constants/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:sizer/sizer.dart';

import '../../api/auth_workout_bud.dart';
import '../../constants/noInternet.dart';

class AddressList extends StatefulWidget {
  const AddressList({Key? key}) : super(key: key);

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  final _formKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  List<Address> useraddr = [];
  bool loader = false;
  final spinkit = SpinKitSpinningLines(
    size: 5.h,
    color: Colors.black,
  );
  bool pageLoader = false;

  TextEditingController AddressNameController = TextEditingController();
  callApi() async {
    setState(() {
      pageLoader = true;
    });
    await DataApiService.instance.getAddressList(context);
    await DataApiService.instance.getprofileinfo(context);
    /*  for (var i = 0; i < getAddrList.length; i++) {
      final split = getAddrList[i].locationName.split(',');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      final value1 = values[0];
      final value2 = values[1];
      final value3 = values[2];
      final value4 = values[3];
      final value5 = values[4];

      useraddr.add(Address(
        useraddress: value2,
        hashcode: value3 ?? '-',
        city: value4 ?? '-',
      ));
    } */

    /* for (var i = 0; i < getAddrList.length; i++) {
      addrUser.add(Address(
          AddController:
              TextEditingController(text: getAddrList[i].locationName)));
    } */
    setState(() {
      pageLoader = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    callApi();
    super.initState();
  }

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
              decoration: InputDecoration(hintText: "Address Name"),
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
                              setState(() async {
                                Map<String, dynamic> add_address = {
                                  'name': AddressNameController.text,
                                  'location_name':
                                      result.formattedAddress.toString(),
                                  'lat':
                                      result.geometry!.location.lat.toString(),
                                  'long':
                                      result.geometry!.location.lng.toString(),
                                };
                                print(add_address);
                                await DataApiService.instance
                                    .addAddress(add_address, context);
                                useraddr.clear();
                                Navigator.of(context).pop();
                                await callApi();

                                /*  useraddr.insert(
                            0,
                            Address(
                                useraddress: value1,
                                hashcode: value2,
                                city: value3,
                                country: value4)); */
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
                            },
                            useCurrentLocation: true,
                            initialPosition: LatLng(31.65465, 31.35153),
                          ),
                        ),
                      );
                    } else {
                      GlobalToast.show( 'Please add address name');
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[100],
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text(
          "Address",
          style: Theme.of(context).textTheme.headline3,
        ),
        actions: [
          InkWell(
            onTap: () async {
              await _nameDialog();
            },
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      size: 20,
                    ),
                    Text('Address')
                  ],
                )),
          )
          /*  InkWell(
            onTap: () async {
              await _nameDialog();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/icons/add_address.png',
              ),
            ),
          ) */
        ],
      ),
      body: connected == false
          ? NoInternet(
              page: AddressList(),
            )
          : pageLoader
              ? Center(child: pageSpinkit)
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: (20 / 375.0) * 100.w),
                  child: ListView.builder(
                    itemCount: getAddrList.length,
                    itemBuilder: (context, index) =>
                        AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getAddrList[index].name.toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13.sp),
                                          ),
                                          /*  Text(
                                            'Address#${index + 1}',
                                            style: TextStyle(fontSize: 13.sp),
                                          ), */

                                          /*   Text(
                                        useraddr[index].useraddress.toString(),
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.5),
                                            fontSize: 11.sp),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ), */
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /*   Text('Code' + ": ",
                                          style: TextStyle(fontSize: 13.sp)), */
                                          Container(
                                            width: 55.w,
                                            child: Text(
                                              getAddrList[index]
                                                  .locationName
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  fontSize: 11.sp),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      /* Row(
                                    children: [
                                      Text(
                                        'City' + ": ",
                                        style: TextStyle(fontSize: 13.sp),
                                      ),
                                      Text(
                                        useraddr[index].city.toString(),
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.5),
                                            fontSize: 11.sp),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ), */
                                      /*   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Country' + ": ",
                                        style: TextStyle(fontSize: 13.sp),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: useraddr[index].country,
                                          style: TextStyle(
                                              color: Colors.black.withOpacity(0.5),
                                              fontSize: 11.sp),
                                          children: [
                                            /*   TextSpan(
                                          text: " x2",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1), */
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 23.w,
                                      ),
                                    ],
                                  ) */
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      getAddrList[index].lat ==
                                                  profileInfo.lat &&
                                              getAddrList[index].long ==
                                                  profileInfo.lng
                                          ? Container(
                                              width: 24.w,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                'Primary Address',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ))
                                          : SizedBox(
                                              height: 10,
                                            ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlacePicker(
                                                      apiKey:
                                                          "AIzaSyBDOMNCVC2eacCxKYuRxIwCz4w-QjV_l5Y",
                                                      onPlacePicked: (result) {
                                                        print(result.geometry!
                                                            .location);
                                                        final tagName = result
                                                            .formattedAddress
                                                            .toString();
                                                        print(result
                                                            .formattedAddress);
                                                        final split =
                                                            tagName.split(',');
                                                        final Map<int, String>
                                                            values = {
                                                          for (int i = 0;
                                                              i < split.length;
                                                              i++)
                                                            i: split[i]
                                                        };
                                                        final value1 =
                                                            values[0];
                                                        final value2 =
                                                            values[1];
                                                        final value3 =
                                                            values[2];
                                                        final value4 =
                                                            values[3];
                                                        setState(() async {
                                                          if (getAddrList[index]
                                                                      .lat ==
                                                                  profileInfo
                                                                      .lat &&
                                                              getAddrList[index]
                                                                      .long ==
                                                                  profileInfo
                                                                      .lng) {
                                                            Map<String, dynamic>
                                                                address = {
                                                              'lat': result
                                                                  .geometry!
                                                                  .location
                                                                  .lat
                                                                  .toString(),
                                                              'long': result
                                                                  .geometry!
                                                                  .location
                                                                  .lng
                                                                  .toString(),
                                                            };
                                                            print(address);
                                                            await DataApiService
                                                                .instance
                                                                .updateAddress(
                                                                    address,
                                                                    context);
                                                          }
                                                          Map<String, dynamic>
                                                              update_address = {
                                                            'id': getAddrList[
                                                                    index]
                                                                .id
                                                                .toString(),
                                                            'location_name': result
                                                                .formattedAddress
                                                                .toString(),
                                                            'lat': result
                                                                .geometry!
                                                                .location
                                                                .lat
                                                                .toString(),
                                                            'long': result
                                                                .geometry!
                                                                .location
                                                                .lng
                                                                .toString(),
                                                            'name': getAddrList[
                                                                    index]
                                                                .name
                                                                .toString()
                                                          };
                                                          print(update_address);
                                                          await DataApiService
                                                              .instance
                                                              .updateUserAddress(
                                                                  update_address,
                                                                  context);

                                                          useraddr.clear();
                                                          Navigator.of(context)
                                                              .pop();
                                                          await callApi();

                                                          /*  useraddr.insert(
                                      0,
                                      Address(
                                          useraddress: value1,
                                          hashcode: value2,
                                          city: value3,
                                          country: value4)); */
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
                                                      },
                                                      useCurrentLocation: false,
                                                      initialPosition: LatLng(
                                                          getAddrList[index]
                                                              .lat,
                                                          getAddrList[index]
                                                              .long),
                                                    ),
                                                  ),
                                                );
                                                // Get.to(EditAddress(index));
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                              onTap: () async {
                                                // Get.to(EditAddress(index));
                                                print('delete');
                                                Map<String, dynamic>
                                                    deleteUser = {
                                                  'id': getAddrList[index]
                                                      .id
                                                      .toString(),
                                                };
                                                setState(() {
                                                  pageLoader = true;
                                                });
                                                bool status =
                                                    await DataApiService
                                                        .instance
                                                        .deleteUserAddress(
                                                            deleteUser,
                                                            context);
                                                if (status) {
                                                  getAddrList.removeAt(index);
                                                } else {
                                                  GlobalToast.show(
                                                      'Something bad happened!');
                                                }
                                                setState(() {
                                                  pageLoader = false;
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      getAddrList[index].lat !=
                                                  profileInfo.lat &&
                                              getAddrList[index].long !=
                                                  profileInfo.lng
                                          ? InkWell(
                                              onTap: () async {
                                                print('click');
                                                setState(() {
                                                  pageLoader = true;
                                                });
                                                Map<String, dynamic>
                                                    update_address = {
                                                  'lat': getAddrList[index]
                                                      .lat
                                                      .toString(),
                                                  'long': getAddrList[index]
                                                      .long
                                                      .toString(),
                                                };
                                                print(update_address);
                                                await DataApiService.instance
                                                    .updateAddress(
                                                        update_address,
                                                        context);
                                                await DataApiService.instance
                                                    .getprofileinfo(context);
                                                setState(() {
                                                  pageLoader = false;
                                                });
                                              },
                                              child: Container(
                                                width: 24.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                  'Change Primary',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
  });
  String? useraddress;
  String? hashcode;
  String? city;
  String? country;
}
