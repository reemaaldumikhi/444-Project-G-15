import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esaa/config/constants.dart';
import 'package:esaa/models/models.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esaa/controllers/controllers.dart';
import 'package:get/get.dart';
import '../../../app.dart';
import '../../../models/models.dart';
import '../../../models/post.dart';
import '../../../services/database/post_database.dart';
import '../view/post_details.dart';

class savedCardJobSeeker extends StatelessWidget {
  final Post post;
  final bool canApply;
  savedCardJobSeeker({required this.post, this.canApply = true, Key? key})
      : super(key: key) {
    Get.put(savedCardController());
    Get.find<savedCardController>().bindUserWithID(post.id);
  }
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var nMon = now.month;
    var nDay = now.day;
    var nYear = now.year;
    var postDate = DateTime.parse(post.startDate);

    var postMon = postDate.month;
    var postDay = postDate.day;
    var postYear = postDate.year;
    final controller = Get.find<savedCardController>();
    return InkWell(
        onTap: () {
          if (post.offerStatus == "fully_assigned" ||
              (postMon > nMon && postYear > nYear && postDay > nDay)) {
          } else
            Get.to(() => PostDetails(post: post, canApply: canApply));
        },
        child: Card(
          color: _disableCard(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 7,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 50,
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 20,
                          ),
                          IconButton(
                              onPressed: () {
                                _unsave(post, controller);
                              },
                              icon: Icon(Icons.bookmark)),
                          const Icon(
                            Icons.work_outline,
                            color: kSPrimaryColor,
                            size: 35,
                          ),
                          const SizedBox(
                            height: 20,
                            width: 20,
                          ),
                          Text(
                            post.title,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 6, 6, 6),
                                fontSize: 18,
                                fontFamily: 'ElMessiri',
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.fade),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 237, 229, 109),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 10,
                        ),
                        Text(post.city,
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: defaultFontSize,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.fade))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                      width: 15,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Color.fromARGB(255, 3, 77, 138),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 10,
                        ),
                        Text(post.startDate,
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: defaultFontSize,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _save(Post post, savedCardController controller) async {
    if (controller.saved.value = false) {
      controller.saved.value = true;
      await PostDatabase().updatePostDetails({
        "id": post.id,
        "saved": FieldValue.arrayUnion([App.user.id])
      });
    } else
      await PostDatabase().updatePostDetails({
        "id": post.id,
        "saved": FieldValue.arrayRemove([App.user.id])
      });
  }

  void _unsave(Post post, savedCardController controller) async {
    await PostDatabase().updatePostDetails({
      "id": post.id,
      "saved": FieldValue.arrayRemove([App.user.id])
    });
    controller.saved.value = false;
  }

  _disableCard() {
    var now = DateTime.now();
    var nMon = now.month;
    var nDay = now.day;
    var nYear = now.year;
    var postDate = DateTime.parse(post.startDate);

    var postMon = postDate.month;
    var postDay = postDate.day;
    var postYear = postDate.year;
    if (post.offerStatus == "fully_assigned" ||
        (postMon > nMon && postYear > nYear && postDay > nDay)) {
      return Colors.grey.withOpacity(0.3);
    } else {
      return Colors.white;
      // return [
      //Color.fromARGB(255, 177, 186, 189).withOpacity(0),
      // Color.fromARGB(255, 67, 77, 81).withOpacity(0.2)
      //];
    }
  }
}

class savedCardController extends UserController {
  RxBool saved = false.obs;
}
