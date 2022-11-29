import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_op/api/auth_workout_bud.dart';
import 'package:co_op/api/global_variables.dart';
import 'package:co_op/screens/auth/sign_in.dart';
import 'package:co_op/screens/home/bookmarks.dart';
import 'package:co_op/screens/profile/AddressList.dart';
import 'package:co_op/screens/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:co_op/screens/profile/packages.dart';

import '../../bottom_navigation_bar.dart';
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
                      SizedBox(
                        height: 20,
                      ),
                      /*   InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PackagesScreen()),
                    );
                  },
                  child: Container(
                    height: 10.h,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.deepPurpleAccent,
                            Color(0xff994ef5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 24,
                                width: 44,
                                decoration: BoxDecoration(
                                    color: Color(0xffffd700),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Center(
                                    child: Text(
                                  "PRO",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Upgrade to Premium",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Spacer(),
                              Icon(
                                Icons.navigate_next_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ],
                          ),
                          Text(
                            "Enjoy workout access without ads and restrictions",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ),
                ), */
                      Divider(
                        height: 20,
                        color: Colors.black,
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Edit Profile'),
                          onTap: () {
                            Get.to(EditProfile());
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          onTap: () async {
                            Map<String, dynamic> interestFilter = {
                              'ids': '1',
                            };
                            print(interestFilter);
                            getUsersList.clear();

                            await DataApiService.instance
                                .getUsersPreference(interestFilter, context);
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
                            Get.to(AddressList());
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.bookmark),
                          title: Text('Bookmarks'),
                          onTap: () {
                            Get.to(BookmarksPage());
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          onTap: () {
                            DataApiService.instance.getUsers(context);
                          },
                          leading: Icon(Icons.security),
                          title: Text('Security'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.help_outline),
                          title: Text('Help'),
                          onTap: () {
                            DataApiService.instance.getFiltersList(context);
                          },
                        ),
                      ),
                      Card(
                        child: ListTile(
                          onTap: () {
                            // themeChange.darkTheme = !themeChange.darkTheme;
                            interestNavigation = true;
                            Get.to(() => ChooseInterest());
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
                              title: 'Logout',
                              desc: 'Are you sure you want to Logout?',
                              btnCancelOnPress: () {},
                              btnCancelText: 'No',
                              btnOkText: 'Yes',
                              btnOkOnPress: () async {
                                setUserLoggedIn(false);
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
                      // SizedBox(
                      //   height: 25.h,
                      //   child: ListView(
                      //     //physics: NeverScrollableScrollPhysics(),
                      //     children: const <Widget>[
                      //       Card(
                      //         child: ListTile(
                      //           leading: Icon(Icons.person),
                      //           title: Text('Edit Profile'),
                      //         ),
                      //       ),
                      //       Card(
                      //         child: ListTile(
                      //           leading: Icon(Icons.notifications),
                      //           title: Text('Notifications'),
                      //         ),
                      //       ),
                      //       Card(
                      //         child: ListTile(
                      //           leading: Icon(Icons.security),
                      //           title: Text('Security'),
                      //         ),
                      //       ),
                      //       Card(
                      //         child: ListTile(
                      //           leading: Icon(Icons.help_outline),
                      //           title: Text('Help'),
                      //         ),
                      //       ),
                      //       Card(
                      //         child: ListTile(
                      //           leading: Icon(Icons.remove_red_eye),
                      //           title: Text('Dark Theme'),
                      //         ),
                      //       ),
                      //       Card(
                      //         child: ListTile(
                      //           leading: Icon(Icons.logout),
                      //           title: Text('Logout', style: TextStyle(color:Colors.red),),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
