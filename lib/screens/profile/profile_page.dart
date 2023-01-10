import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:co_op/screens/auth/sign_in.dart';
import 'package:co_op/screens/home/bookmarks.dart';
import 'package:co_op/screens/home/notification.dart';
import 'package:co_op/screens/profile/AddressList.dart';
import 'package:co_op/screens/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/screens/profile/packages.dart';

import '../../bottom_navigation_bar.dart';
import '../../constants/constants.dart';
import '../../constants/noInternet.dart';
import '../../provider/dark_theme_provider.dart';
import '../auth/accountsetup/choose_interest.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
  callApi(){
    setState(() {
      DataApiService.instance.getprofileinfo(context);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed(context);
        if (result == null) {
          result = false;
        }
        return result;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(index: 3),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Profile",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        body: connected == false
            ? NoInternet(
                page: ProfilePage(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                height: 20.h,
                                width: 20.h,
                                fit: BoxFit.cover,
                                imageUrl:
                                    'https://becktesting.site/workout-bud/public/storage/user/' +
                                        profileInfo.image.toString(),
                                placeholder: (context, url) => Image.asset(
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
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            /*    profileInfo.image == null
                          ? CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  AssetImage("assets/images/intro1.png"),
                            )
                          : CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                  'https://becktesting.site/workout-bud/public/storage/user/' +
                                      profileInfo.image.toString()),
                            ), */
                            /*    Positioned(
                          bottom: 3,
                          right: 4,
                          child: CircleAvatar(
                              backgroundColor: Colors.deepPurpleAccent,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ))) */
                          ]),
                        ],
                      ),
                      Text(
                        profileInfo.userName.toString(),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(profileInfo.email.toString(),
                          style: TextStyle(fontSize: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AbsorbPointer(
                            absorbing:
                            true,
                            child: RatingBar(
                                tapOnlyMode: false,
                                updateOnDrag: false,
                                initialRating: ratingStars.value == null ? 0.0 : ratingStars.value.toDouble(),


                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 24,
                                ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star, color: secondaryColor),
                                    half: const Icon(
                                      Icons.star_half,
                                      color: secondaryColor,
                                    ),
                                    empty: const Icon(
                                      Icons.star_outline,
                                      color: secondaryColor,
                                    )),
                                onRatingUpdate: (value) {}),
                          ),
                          Container(
                            width: 30,
                            height:
                            30,
                            alignment:
                            Alignment
                                .center,
                            child:
                            Text(
                             ratingStars.value ==
                                  null
                                  ? '0.0'
                                  : ratingStars.value.toString(),

                              style: const TextStyle(
                                  color: secondaryColor,
                                  fontSize:
                                  14,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Divider(
                        height: 20,
                        color: Colors.black,
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Edit Profile'),
                          onTap: () {
                            Get.to(
                              EditProfile(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1),
                              curve: Curves.decelerate,
                            );
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          onTap: () async {
                            Get.to(
                              NotificationPage(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1),
                              curve: Curves.decelerate,
                            );
                          },
                          leading: Icon(Icons.notifications),
                          title: Text('Notifications'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text('Address'),
                          onTap: () {
                            Get.to(
                              AddressList(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1),
                              curve: Curves.decelerate,
                            );
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.bookmark),
                          title: Text('Bookmarks'),
                          onTap: () {
                            Get.to(
                              BookmarksPage(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1),
                              curve: Curves.decelerate,
                            );
                          },
                        ),
                      ),

                      Card(
                        child: ListTile(
                          onTap: () {
                            // themeChange.darkTheme = !themeChange.darkTheme;
                            interestNavigation = true;
                            Get.to(
                              () => ChooseInterest(),
                              transition: Transition.fade,
                              duration: const Duration(seconds: 1),
                              curve: Curves.decelerate,
                            );
                          },
                          leading: Icon(Icons.favorite),
                          title: Text('Interests'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.TOPSLIDE,
                              title: 'Delete Account',
                              desc: 'Are you sure you want to delete account?',
                              btnCancelOnPress: () {},
                              btnCancelText: 'No',
                              btnOkText: 'Yes',
                              btnOkOnPress: () async {
                                setUserLoggedIn(false);
                                firstHome = false;
                                DataApiService.instance.delteAccount(context, profileInfo.id.toString());
                                Get.offAll(SignIn());
                              },
                            ).show();
                          },
                          leading: Icon(
                            Icons.delete,

                          ),
                          title: Text(
                            'Delete Account',

                          ),
                        ),
                      ),

                      Card(
                        child: ListTile(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.question,
                              animType: AnimType.TOPSLIDE,
                              title: 'Logout',
                              desc: 'Are you sure you want to Logout?',
                              btnCancelOnPress: () {},
                              btnCancelText: 'No',
                              btnOkText: 'Yes',
                              btnOkOnPress: () async {
                                setUserLoggedIn(false);
                                firstHome = false;
                                DataApiService.instance.logout(context);
                                Get.offAll(SignIn());
                              },
                            ).show();
                          },
                          leading: Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
