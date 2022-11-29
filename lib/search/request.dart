import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAzRcyCeA:APA91bEA4IpoUeQImdVaj43zfcccOr-OJttVcfDv6t8XP1f6HyVsJZ5MF1c_Y8yYKXeIkZx1479d0h4qJdW-vdgxpRmAeCHu1gp-WsBlOB-kHJ3UldAxA1i-7aeUBAhDNaWjqjrLgXRa',
        },
        body: jsonEncode(
          <String, dynamic>{
            /*  'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '2',
              'status': 'done'
            }, */
            'priority': 'high',
            "to": "_some_fcm_token_",
            'data': <String, dynamic>{
              'title': title,
              'body': body,
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '2',
              'status': 'done'
            },
            "type": "post_like",
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Request'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      print('click');
                      // showNotification();
                      String name = 'user1';
                      String titleText = 'Averial accept your request';
                      String bodyText = 'Request Accepted';

                      if (name != "") {
                        DocumentSnapshot snap = await FirebaseFirestore.instance
                            .collection("UserTokens")
                            .doc(name)
                            .get();

                        String token = snap['token'];
                        print(token);

                        sendPushMessage(token, titleText, bodyText);
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green),
                      child: Text(
                        'Accept',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () async {
                      print('click');
                      // showNotification();
                      String name = 'user1';
                      String titleText = 'user2 decline your request';
                      String bodyText = 'Request Declined';

                      if (name != "") {
                        DocumentSnapshot snap = await FirebaseFirestore.instance
                            .collection("UserTokens")
                            .doc(name)
                            .get();

                        String token = snap['token'];
                        print(token);

                        sendPushMessage(token, titleText, bodyText);
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red),
                      child: Text(
                        'Decline',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
