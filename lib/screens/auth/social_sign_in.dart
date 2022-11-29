import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:co_op/screens/auth/sign_up.dart';

class SocialSignIn extends StatefulWidget {
  const SocialSignIn({Key? key}) : super(key: key);

  @override
  State<SocialSignIn> createState() => _SocialSignInState();
}

class _SocialSignInState extends State<SocialSignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h,),
            Center(child: Text("Let's you in", style: TextStyle(fontSize: 36),)),
            SizedBox(height: 4.h,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocialLoginButton(
                    buttonType: SocialLoginButtonType.google,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  SocialLoginButton(
                    buttonType: SocialLoginButtonType.facebook,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  SocialLoginButton(
                    buttonType: SocialLoginButtonType.appleBlack,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Divider(
                      height: 0,
                    color: Colors.black,
                    ),
                  ),
                  Text("  or  ", style: TextStyle(fontSize: 18),),
                  Expanded(
                    child: Divider(
                      height: 0,
                      color: Colors.black,),
                  )
                ],
              ),
            ),
            SizedBox(height: 4.h,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurpleAccent),
                child: InkWell(
                    child: Center(
                      child: const Text(
                        'Sign in with password',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    onTap: (){
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SelectAge()));

                    }
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUp()));

                      },
                      child: Text("Sign Up", style: TextStyle(color: Colors.deepPurpleAccent),))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
