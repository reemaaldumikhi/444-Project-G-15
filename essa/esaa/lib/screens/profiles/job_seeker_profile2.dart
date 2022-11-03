import 'dart:typed_data';

import 'package:esaa/app.dart';
import 'package:esaa/config/constants.dart';
import 'package:esaa/controllers/controllers.dart';
import 'package:esaa/screens/profiles/jobSeekerProfileView.dart';
import 'package:esaa/screens/shared/shared.dart';
import 'package:esaa/services/services.dart';
import 'package:esaa/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class JobSeekerProfile2 extends StatefulWidget {
  JobSeekerProfile2({Key? key}) : super(key: key) {
    Get.put(EditProfileJFormControllerJs());
  }
  @override
  _JobSeekerProfile2State createState() => _JobSeekerProfile2State();
}

class _JobSeekerProfile2State extends State<JobSeekerProfile2>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool en = false;
  String stroredImg = '';
  setStoredImg() {
    if (App.user.imgUrl == '' || App.user.imgUrl == null) {
      stroredImg = Icons.image as String;
    } else
      stroredImg = App.user.imgUrl;
  }

  Uint8List? _image;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final nidController = TextEditingController();
  final bdateController = TextEditingController();
  final sexController = TextEditingController();
  final bioController = TextEditingController();
  final skillsController = TextEditingController();

  @override
  void initState() {
    _setInitialValues(nameController, emailController, nidController,
        sexController, bdateController, bioController, skillsController);
    super.initState();
  }

  saveNewValues() async {
    App.user.name = nameController.text;
    App.user.nationalID = nidController.text;
    App.user.email = emailController.text;
    App.user.sex = sexController.text;
    App.user.Bdate = bdateController.text;
    App.user.bio = bioController.text;
    App.user.skills = skillsController.text;

    /*String imgUrl = "";
    if (_image != null) {
      imgUrl = await Storage().uploadImageToString("companyLogo ", _image!);
    }
    App.user.imgUrl = imgUrl;*/
    await UserDatabase(App.user.id).updateDetails(App.user.toMap());
  }

  void selectImage() async {
    final pickedFile = await pickImage(ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List image = await pickImage(ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }
    String imgUrl = "";
    if (_image != null) {
      imgUrl = await Storage().uploadImageToString("companyLogo ", _image!);
      App.user.imgUrl = imgUrl;
      await UserDatabase(App.user.id).updateDetails(App.user.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
        title: const Text("تعديل الملف الشخصي",
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis)),
        showLeading: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child:
                  //========== profile img======================================================================
                  Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        App.user.imgUrl != ''
                            ? CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(App.user.imgUrl),
                                child: IconButton(
                                  iconSize: 40,
                                  icon: const Icon(Icons.camera_alt),
                                  onPressed: () => selectImage(),
                                ),
                              )
                            : _image != null
                                ? CircleAvatar(
                                    radius: 70,
                                    backgroundImage: MemoryImage(_image!))
                                : GestureDetector(
                                    onTap: selectImage,
                                    child: SizedBox(
                                      height: 200,
                                      width: 290,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(App.user.imgUrl),
                                        child: IconButton(
                                          iconSize: 40,
                                          icon: const Icon(Icons.camera_alt),
                                          onPressed: () => selectImage(),
                                        ),
                                      ),
                                    ),
                                  ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const SizedBox(height: 10),
                  //====================form ============================================
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: nameController,
                              onSaved: (newValue) =>
                                  nameController.text = newValue!.trim(),
                              validator: (value) {
                                final number = num.tryParse(value!);
                                if (value!.trim().isEmpty) {
                                  return "يجب ان لا يكون الاسم فارغًا";
                                } else if (number != null) {
                                  return 'يجب أن لا يحتوي الاسم على أرقام فقط';
                                }

                                return null;
                              },
                              onChanged: (val) => setState(() {
                                en = true;
                              }),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                //overflow: TextOverflow.ellipsis
                              ),
                              decoration: InputDecoration(
                                labelText: "الاسم",
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //====================id ============================================
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: nidController,
                              onSaved: (newValue) {
                                nidController.text = newValue!.trim();
                              },
                              onChanged: (val) => setState(() {
                                en = true;
                              }),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                //overflow: TextOverflow.ellipsis
                              ),
                              decoration: InputDecoration(
                                labelText: "الهوية الوطنية",
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0)),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  en = false;
                                  return kNationalIdNullError;
                                } else if (val.length != 10) {
                                  return 'يجب ان يتكون رقم الهوية/الاقامة من عشرة ارقام';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //====================bio ============================================
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: bioController,
                              onSaved: (newValue) =>
                                  bioController.text = newValue!.trim(),
                              onChanged: (val) => setState(() {
                                en = true;
                              }),
                              validator: (value) {
                                final number = num.tryParse(value!);
                                if (number != null) {
                                  return 'يجب أن لا تحتوي النبذه التعريفية على أرقام فقط';
                                }

                                return null;
                              },
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                //overflow: TextOverflow.ellipsis
                              ),
                              decoration: InputDecoration(
                                labelText: "النبذة التعريفية",
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //====================skills ============================================
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: skillsController,
                              onSaved: (newValue) =>
                                  skillsController.text = newValue!.trim(),
                              onChanged: (val) => setState(() {
                                en = true;
                              }),
                              validator: (value) {
                                final number = num.tryParse(value!);
                                if (number != null) {
                                  return 'يجب أن لا تحتوي المهارات على أرقام فقط';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                //overflow: TextOverflow.ellipsis
                              ),
                              decoration: InputDecoration(
                                labelText: "المهارات ",
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //====================b date ============================================
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              //keyboardType: TextInputType.datetime,
                              controller: bdateController,
                              onSaved: (newValue) =>
                                  nidController.text = newValue!.trim(),
                              onChanged: (val) => setState(() {
                                en = true;
                              }),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                //overflow: TextOverflow.ellipsis
                              ),
                              decoration: InputDecoration(
                                labelText: "تاريخ الميلاد",
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0)),
                              ),
                              onTap: () async {
                                DateTime? newDate2 = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now());
                                if (newDate2 != null) {
                                  setState(() {
                                    bdateController.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(newDate2);
                                    en = true;
                                  });
                                } else {
                                  if (kDebugMode) {
                                    print(kEndDateNullError);
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //====================sex ============================================
                      /*Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: sexController,
                              onSaved: (newValue) =>
                                  sexController.text = newValue!.trim(),
                              onChanged: (val) => setState(() {
                                en = true;
                                sexController.text = val.toString();
                              }),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                //overflow: TextOverflow.ellipsis
                              ),
                              decoration: InputDecoration(
                                labelText: "الجنس",
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 0.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 28,
                      ),*/
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: en
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        saveNewValues();
                                        //en = false;
                                        Fluttertoast.showToast(
                                            msg: "تم التعديل بنجاح",
                                            backgroundColor: Colors.black54,
                                            toastLength: Toast.LENGTH_LONG,
                                            textColor: kFillColor);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  jobSeekerProfileView()),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor, elevation: 0),
                              child: const Text(
                                "حفظ التعديلات",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

void _setInitialValues(
  TextEditingController nameController,
  TextEditingController emailController,
  TextEditingController nidController,
  TextEditingController sexController,
  TextEditingController bdateController,
  TextEditingController bioController,
  TextEditingController skillsController,
) {
  nameController.text = App.user.name;
  emailController.text = App.user.email;
  nidController.text = App.user.nationalID;
  sexController.text = App.user.sex;
  bdateController.text = App.user.Bdate;
  bioController.text = App.user.bio;
  skillsController.text = App.user.skills;
}

class EditProfileJFormControllerJs extends UserController {}
