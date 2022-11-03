import 'package:esaa/config/constants.dart';
import 'package:esaa/models/models.dart';
import 'package:esaa/screens/company_home/company_home.dart';
import 'package:esaa/screens/review_page.dart';
import 'package:esaa/screens/shared/shared.dart';
import 'package:esaa/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'widgets/stack_container.dart';

class CompanyJobSeekerProfile extends StatelessWidget {
  const CompanyJobSeekerProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailsController>();

    return CustomAppbar(
        title: const Text("الملف الشخصي للباحث عن العمل ",
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis)),
        showLeading: true,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                StackContainer(
                  imgUrl: controller.user.value.imgUrl,
                  reviewID: controller.user.value.id,
                ),
                //================ reviews===============
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GetX<OrderDetailsController>(builder: (controller) {
                      return RatingBar.builder(
                        initialRating: _sumRating(controller.reviews),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: (double value) {},
                      );
                    }),
                    const SizedBox(width: 10),
                    GetX<OrderDetailsController>(builder: (controller) {
                      return Text(
                        '(${controller.reviews.isNotEmpty ? controller.reviews.length : 'لا يوجد تقييمات'})',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: controller.reviews.isNotEmpty ? 24 : 16,
                            fontWeight: FontWeight.w500),
                      );
                    })
                  ],
                ),
                /*
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () => Get.to(
                          () => ReviewPage(userID: controller.user.value.id)),
                      child: const Text(
                        "عرض التقييمات",
                        style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),*/
                const SizedBox(height: 10),
                Card(
                  child: Row(
                    children: [
                      const SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "الاسم",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            controller.user.value.name,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    children: [
                      const SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "النبذة التعريفية",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            controller.user.value.bio,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    children: [
                      const SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "المهارات ",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            controller.user.value.skills,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    children: [
                      const SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "الايميل",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            controller.user.value.email,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Card(
                  child: Row(
                    children: [
                      const SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "الجنس",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            controller.user.value.sex,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Row(
                    children: [
                      const SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "تاريخ الميلاد",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            controller.user.value.Bdate,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "الأعمال السابقة",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                CustomListView(
                    query: OrderDatabase.ordersCollection
                        .where("userID", isEqualTo: controller.user.value.id)
                        .where("orderStatus", isEqualTo: "accepted")
                        .orderBy("timeApplied", descending: true),
                    emptyListWidget: const SizedBox(
                      height: 300,
                      child: Center(
                        child: Text(
                          "لا يوجد أعمال سابقة",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    itemBuilder: (context, querySnapshot) {
                      Order order = Order.fromDocumentSnapshot(querySnapshot);
                      return OrderCard(order: order, showPaymentStatus: false);
                    }),
              ],
            ),
          ),
        ));
  }

  double _sumRating(List<Review> reviews) {
    double totalValue = 0;
    for (Review review in reviews) {
      totalValue = totalValue + review.rating;
    }

    if (totalValue == 0 || reviews.isEmpty) return 0;

    return totalValue / reviews.length;
  }
}