import 'package:esaa/models/models.dart';
import 'package:esaa/screens/profiles/widgets/tob_bar.dart';
import 'package:flutter/material.dart';
import 'package:esaa/config/constants.dart';
import 'package:esaa/controllers/controllers.dart';
import 'package:esaa/screens/shared/shared.dart';
import 'package:esaa/services/services.dart';
import '../../../app.dart';
import '../../review_page.dart';
import '../company_profile.dart';
import '../utils/custom_clipper.dart';
import 'package:get/get.dart';

class StackContainer extends StatelessWidget {
  final String imgUrl;
  final String reviewID;
  final bool logout;
  StackContainer(
      {Key? key,
      required this.imgUrl,
      required this.reviewID,
      this.logout = false})
      : super(key: key);

  String name = App.user.name;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://i.pinimg.com/originals/f3/43/b5/f343b5388f3035b6453e662fd1ce1f0f.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // ignore: prefer_const_constructors
                CircleAvatar(
                    radius: 70, backgroundImage: NetworkImage(this.imgUrl)),
                const SizedBox(height: 4.0),

                /*
                GestureDetector(
                    onTap: () => CompanyProfile(),
                    child: Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 56, 146, 220),
                    )),
                Text(
                  "تعديل الملف الشخصي",
                  style: TextStyle(color: Color.fromARGB(255, 56, 146, 220)),
                ),*/
              ],
            ),
          ),
          TopBar(logout: this.logout),
        ],
      ),
    );
  }
}
