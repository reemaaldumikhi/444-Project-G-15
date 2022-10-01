import 'package:esaa/app.dart';
import 'package:esaa/config/constants.dart';
import 'package:esaa/models/models.dart';
import 'package:esaa/screens/company_home/company_home.dart';
import 'package:esaa/screens/shared/shared.dart';
import 'package:esaa/services/services.dart';
import 'package:flutter/material.dart';

class CompanyTabBarPage extends StatefulWidget {
  const CompanyTabBarPage({Key? key}) : super(key: key);

  @override
  CompanyTabBarPageState createState() => CompanyTabBarPageState();
}

class CompanyTabBarPageState extends State<CompanyTabBarPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 150,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),

                Container(
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TabBar(
                          unselectedLabelColor: kPrimaryColor,
                          labelColor: const Color.fromARGB(255, 75, 73, 73),
                          indicatorColor: Colors.white,
                          indicatorWeight: 2,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          controller: tabController,
                          tabs: const [
                            Tab(
                              text: 'عروض قيد الانتظار',
                            ),
                            Tab(
                              text: 'العروض تم اسنادها',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: const [_TabOne(), _TabTwo()]),
                ),

                const SizedBox(height: 20),

              ],
            ),
        ),
        ),
    );
  }
}

class _TabOne extends StatelessWidget {
  const _TabOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListView(
      query: PostDatabase.postsCollection
          .where("companyID", isEqualTo: App.user.id)
          .where("offerStatus", isEqualTo: "pending")
          .orderBy("timePosted", descending: true),
      emptyListWidget: const SizedBox(
        child: Text(
          'No unassigned post',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: kPrimaryColor,
          ),
        ),
      ),
      itemBuilder: (context, querySnapshot) {
        Post post = Post.fromDocumentSnapshot(querySnapshot);
        return PostCardCompany(post: post);
      },
    );
  }
}

class _TabTwo extends StatelessWidget {
  const _TabTwo ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListView(
      query: PostDatabase.postsCollection
          .where("companyID", isEqualTo: App.user.id)
          .where("offerStatus", isEqualTo: "assigned")
          .orderBy("timePosted", descending: true),
      emptyListWidget: const SizedBox(
        child: Text(
          'No assigned post',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: kPrimaryColor,
          ),
        ),
      ),
      itemBuilder: (context, querySnapshot) {
        Post post = Post.fromDocumentSnapshot(querySnapshot);
        return PostCardCompany(post: post);
      }
    );
  }

}