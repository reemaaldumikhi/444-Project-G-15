import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:esaa/config/constants.dart';
import 'package:esaa/controllers/controllers.dart';
import 'package:esaa/models/models.dart';
import 'package:esaa/screens/job_seeker_home/view/SavedOffer.dart';
import 'package:esaa/screens/profiles/company_profile.dart';
import 'package:esaa/screens/profiles/jobSeeker_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import 'company_home/company_home.dart';
import 'job_seeker_home/job_seeker_home.dart';
import 'post_job/post_job.dart';

class Default extends StatefulWidget {
  Default({Key? key}) : super(key: key) {
    Get.find<UserController>().bindUser();
  }

  @override
  State<Default> createState() => _DefaultState();
}

class _DefaultState extends State<Default> {
  @override
  Color _iconColor = Colors.white;
  void initState() {
    registerNotification();

    // For handling notification when the app is in background
    // but not terminated
    checkForInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title ?? "",
        body: message.notification?.body ?? "",
      );
      _showNotification(notification);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: Scaffold(
          backgroundColor: kFillColor,
          body: Stack(
            children: [
              GetX<UserController>(builder: (controller) {
                return Visibility(
                  visible: controller.user.value.userType == "jobSeeker",
                  child: Transform.rotate(
                    origin: const Offset(40, -150),
                    angle: 2.4,
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 75,
                        top: 40,
                      ),
                      height: 400,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        gradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            colors: [kPrimaryColor, kTextColor]),
                      ),
                    ),
                  ),
                );
              }),
              GetX<UserController>(builder: (controller) {
                return Container(
                    child: getSelectedWidget(
                        index: controller.currentIndex,
                        userType: controller.user.value.userType));
              }),
            ],
          ),
          bottomNavigationBar: GetX<UserController>(builder: (controller) {
            final items = getItems(controller.user.value.userType);

            return CurvedNavigationBar(
                backgroundColor: kFillColor,
                color: kPrimaryLightColor,
                animationDuration: const Duration(milliseconds: 60),
                index: controller.currentIndex,
                items: items,
                onTap: controller.changePage);
          }),
        ));
  }

  List<Widget> getItems(String userType) {
    if (userType == "jobSeeker") {
      return const [
        Icon(
          Icons.document_scanner,
          color: KGrey,
        ),
        Icon(
          Icons.work_outline_outlined,
          color: KGrey,
        ),
        Icon(
          Icons.home,
          color: KGrey,
        ),
        Icon(
          Icons.account_circle,
          color: KGrey,
        ),
      ];
    } else if (userType == "company") {
      return const [
        Icon(
          Icons.add_rounded,
          color: KGrey,
        ),
        Icon(
          Icons.home,
          color: KGrey,
        ),
        Icon(
          Icons.document_scanner_rounded,
          color: KGrey,
        ),
        Icon(
          Icons.account_circle,
          color: KGrey,
        ),
      ];
    }
    return const [
      Icon(
        Icons.add_rounded,
        color: KGrey,
      ),
      Icon(
        Icons.home,
        color: KGrey,
      ),
      Icon(
        Icons.document_scanner_rounded,
        color: KGrey,
      ),
      Icon(
        Icons.account_circle,
        color: KGrey,
      ),
    ];
  }

  Widget getSelectedWidget({required int index, required String userType}) {
    Widget widget;

    if (userType == "jobSeeker") {
      switch (index) {
        case 0:
          widget = savedOffers();
          break;
        case 1:
          widget = const JobSeekerTabBarPage();
          break;
        case 2:
          widget = AvailablePostsScreen();
          break;
        case 3:
          widget = jobseekerProfile();
          break;

        default:
          widget = AvailablePostsScreen();
          break;
      }
    } else {
      switch (index) {
        case 0:
          widget = const PostJob(); //post a new job
          break;

        case 1:
          widget =
              const CompanyPosts(); //view all posts... both assigned and unassigned
          break;

        case 2:
          widget =
              const CompanyTabBarPage(); //view all posts... differentiate assigned and unassigned
          break;

        case 3:
          widget = companyProfile();
          break;

        default:
          widget = const CompanyPosts();
          break;
      }
    }

    return widget;
  }

  void registerNotification() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification?.title ?? "",
          body: message.notification?.body ?? "",
        );

        _showNotification(notification);
      });
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title ?? "",
        body: initialMessage.notification?.body ?? "",
      );

      _showNotification(notification);
    }
  }

  void _showNotification(PushNotification notification) {
    if (notification.body != "" && notification.title != "") {
      showSimpleNotification(
        Text(notification.title),
        leading: const Icon(Icons.notifications),
        subtitle: Text(notification.body),
        background: kPrimaryColor,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
