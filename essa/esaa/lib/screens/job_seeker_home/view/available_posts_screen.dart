import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esaa/config/constants.dart';
import 'package:esaa/controllers/available_posts_controller.dart';
import 'package:esaa/controllers/controllers.dart';
import 'package:esaa/models/models.dart';
import 'package:esaa/screens/company_home/company_home.dart';
import 'package:esaa/screens/shared/shared.dart';
import 'package:esaa/services/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:esaa/app.dart';
import '../../../app.dart';

class AvailablePostsScreen extends StatelessWidget {
  AvailablePostsScreen({Key? key}) : super(key: key) {
    Get.put(AvailablePostsController());
    Get.find<AvailablePostsController>();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    final controller = Get.find<AvailablePostsController>();

    return CustomAppbar(
      title: const Text("الصفحةالرئيسية",
          style: TextStyle(
              color: kPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis)),
      showNotification: true,
      child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                    height: 1,
                  ),
                  const Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text("مرحبا ",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis)),
                  ),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(App.user.name,
                        style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    controller.searchField = value;
                  },
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    hintTextDirection: TextDirection.rtl,
                    hintText: 'بحث..',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 44,
                  width: 210,
                  decoration: const BoxDecoration(
                      color: kFillColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      )),
                  margin: const EdgeInsets.only(top: 8, right: 20),
                  child: PopupMenuButton<String>(
                    tooltip: "Select Filter",
                    constraints: BoxConstraints(
                      minHeight: 24,
                      maxHeight: MediaQuery.of(context).size.height / 1.35,
                      minWidth: 180,
                      maxWidth: 200,
                    ),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) => controller.filters
                        .map<PopupMenuItem<String>>((String filter) {
                      return PopupMenuItem<String>(
                        value: filter,
                        child: SizedBox(
                          height: 20,
                          child: Text(
                            'تصنيف حسب $filter',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      );
                    }).toList(),
                    onSelected: (String filter) {
                      controller.filterBy = filter;
                    },
                    child: SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              const Icon(
                                Icons.filter_alt,
                                color: KGrey,
                                size: 21,
                              ),
                              SizedBox(
                                height: 20,
                                width: 150,
                                child: GetX<AvailablePostsController>(
                                    builder: (controller) {
                                  return Text(
                                    'عرض حسب ${controller.filterBy}',
                                    style: const TextStyle(
                                        color: KGrey, fontSize: 14),
                                    textAlign: TextAlign.start,
                                  );
                                }),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(child: GetX<AvailablePostsController>(
                builder: (controller) {
                  if (controller.filterBy == " التاريخ الاقرب") {
                    return PostCount(query: _getQuery(controller.filterBy));
                  } else {
                    return PostCount(query: _getQuery(controller.filterBy));
                  }
                },
              )),
              const SizedBox(height: 0),
              GetX<AvailablePostsController>(
                builder: (controller) {
                  if (controller.filterBy == " التاريخ الاقرب") {
                    return AvailablePostList(
                        query: _getQuery(controller.filterBy));
                  } else {
                    return AvailablePostList(
                        query: _getQuery(controller.filterBy));
                  }
                },
              )
            ],
          )),
    );
  }

  Query _getQuery(String filterBy) {
    Query query = PostDatabase.postsCollection
        .where("offerStatus", whereIn: ["pending", "assigned"]);

    if (filterBy == " التاريخ الاقرب") {
      query = query.orderBy("timePosted", descending: true);
    } else {
      query = query.orderBy("payPerHour", descending: true);
    }
    return query;
  }
}

class AvailablePostList extends StatelessWidget {
  final Query query;
  const AvailablePostList({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return FirestoreQueryBuilder(
      query: query,
      pageSize: 10,
      builder: (context, snapshot, _) {
        return GetX<AvailablePostsController>(builder: (controller) {
          return _builder(
              context, snapshot, _, controller.searchField, scrollController);
        });
      },
    );
  }

  Widget _builder(context, snapshot, _, searchField, scrollController) {
    if (snapshot.isFetching) {
      return const Center(
        child: SizedBox(
            height: 50,
            width: 50,
            child: SpinKitRing(
              color: kPrimaryColor,
              size: 50.0,
            )),
      );
    }

    if (snapshot.hasError) return _errorBuilder();

    if (snapshot.docs.isEmpty) return _emptyListBuilder();

    if (!_filterItems(context, snapshot, searchField)) {
      return _emptyListBuilder();
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      shrinkWrap: true,
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) =>
          _itemBuilder(context, index, snapshot, searchField),
    );
  }

  Widget _itemBuilder(BuildContext context, int index,
      FirestoreQueryBuilderSnapshot<Object?> snapshot, String searchField) {
    final isLastItem = index + 1 == snapshot.docs.length;
    if (isLastItem && snapshot.hasMore) snapshot.fetchMore();

    final doc = snapshot.docs[index];
    Post post = Post.fromDocumentSnapshot(doc);

    if (searchField.trim().isEmpty ||
        post.title.contains(searchField.trim()) ||
        post.description.contains(searchField.trim()) ||
        post.city.contains(searchField.trim())) {
      return PostCardJobSeeker(post: post);
    } else {
      return const SizedBox();
    }
  }

  Widget _errorBuilder() {
    return const SizedBox(
      child: Text(
        'ليس هناك أي منشورات في الوقت الحالي',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: kPrimaryColor,
        ),
      ),
    );
  }

  Widget _emptyListBuilder() {
    return const SizedBox(
      height: 100,
      //check the error message
    );
  }

  bool _filterItems(BuildContext context,
      FirestoreQueryBuilderSnapshot<Object?> snapshot, String searchField) {
    int matches = 0;

    for (QueryDocumentSnapshot querySnapshot in snapshot.docs) {
      Post post = Post.fromDocumentSnapshot(querySnapshot);

      if (searchField.trim().isEmpty ||
          post.title.contains(searchField.trim()) ||
          post.description.contains(searchField.trim()) ||
          post.city.contains(searchField.trim())) {
        matches++;
      }
    }

    return matches != 0;
  }
}

class PostCount extends StatelessWidget {
  final Query query;
  const PostCount({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder(
      query: query,
      builder: (context, snapshot, _) {
        return GetX<AvailablePostsController>(builder: (controller) {
          return _builder(context, snapshot, _, controller.searchField);
        });
      },
    );
  }

  Widget _builder(context, snapshot, _, searchField) {
    if (snapshot.isFetching) {
      return const Center(
        child: SizedBox(
            height: 24,
            width: 24,
            child: SpinKitRing(
              color: Colors.black,
              size: 24.0,
            )),
      );
    }

    final matches = _filterItems(context, snapshot, searchField);

    return Text(
      '$matches من المنشورات المتاحة${matches > 1 ? "" : ""}',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: KGrey,
      ),
    );
  }

  int _filterItems(BuildContext context,
      FirestoreQueryBuilderSnapshot<Object?> snapshot, String searchField) {
    int matches = 0;

    for (QueryDocumentSnapshot querySnapshot in snapshot.docs) {
      Post post = Post.fromDocumentSnapshot(querySnapshot);

      if (searchField.trim().isEmpty ||
          post.title.contains(searchField.trim()) ||
          post.description.contains(searchField.trim()) ||
          post.city.contains(searchField.trim())) {
        matches++;
      }
    }
    return matches;
  }
}
