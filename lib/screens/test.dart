import 'dart:async';
import 'package:flutter/material.dart';
import 'package:furniture_app_project/models/user_model.dart';
import 'package:furniture_app_project/provider/user_provider.dart';
import 'package:furniture_app_project/widgets/bottom_navy_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
// Legacy FirebaseStorage code removed. TODO: implement image upload via REST (multipart) in ApiService.

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

UserProvider userProvider = UserProvider();

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  late String gender;
  List<String> genderList = ['Female', 'Male', 'Unknown'];
  bool isEdit = false;
  int num = 1;

  File? _pickedImage;

  XFile? _image;
  final picker = ImagePicker();
  Future<void> getImage({required ImageSource source}) async {
    _image = await picker.pickImage(source: source);
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image!.path);
      });
    }
  }

  Future<String> _uploadImage({required File image}) async {
    // Placeholder: replace with ApiService multipart upload
    return '';
  }

  Future<void> myDialogBox(context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text("Pick Form Camera"),
                    onTap: () {
                      getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Pick Form Gallery"),
                    onTap: () {
                      getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    if (!isEdit && num == 1) {
      fullNameController.text = userProvider.currentUser.fullName;
      phoneController.text = userProvider.currentUser.phone;
      addressController.text = userProvider.currentUser.address;
      birthDateController.text = userProvider.currentUser.birthDate;
      emailController.text = userProvider.currentUser.email;
      gender = userProvider.currentUser.gender;
      statusController.text = userProvider.currentUser.status;

      num = 2;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff2f9fe),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 260),
              painter: CustomProfilePageShadow(),
            ),
            ClipPath(
              clipper: Clipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/background_profile.jpg"),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            SafeArea(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.settings)),
              ],
            )),
            Positioned(
              top: 250 - 150,
              left: MediaQuery.of(context).size.width / 2 - 75,
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(75)),
                  boxShadow: [
                    BoxShadow(
                        //color: Color.fromRGBO(179, 213, 242, 0.2),
                        color: Color(0xffe3eaef),
                        spreadRadius: 0.02,
                        blurRadius: 12,
                        offset: Offset(4, 4)),
                  ],
                ),
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(75)),
                  child: _pickedImage == null
                      ? userProvider.currentUser.img.isNotEmpty
                          ? FadeInImage(
                              fit: BoxFit.fill,
                              placeholder:
                                  const AssetImage('assets/icons/user.png'),
                              image: NetworkImage(userProvider.currentUser.img),
                            )
                          : const Image(
                              image: AssetImage('assets/icons/user.png'))
                      : Image(
                          image: FileImage(_pickedImage!),
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            isEdit
                ? Positioned(
                    top: 210,
                    right: MediaQuery.of(context).size.width / 2 - 75,
                    child: GestureDetector(
                      onTap: () {
                        myDialogBox(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                //color: Color.fromRGBO(179, 213, 242, 0.2),
                                color: const Color(0xff81221e).withOpacity(0.3),
                                spreadRadius: 0.06,
                                blurRadius: 24,
                                offset: const Offset(4, 4)),
                            const BoxShadow(
                                //color: Color.fromRGBO(179, 213, 242, 0.2),
                                color: Color(0xffffffff),
                                spreadRadius: 0.06,
                                blurRadius: 24,
                                offset: Offset(-4, -4)),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Color(0xff81221e),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Positioned(
              top: 200,
              right: MediaQuery.of(context).size.width / 4.5 - 50,
              child: GestureDetector(
                onTap: () {
                  if (!isEdit) {
                    setState(() {
                      isEdit = true;
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            // The background color
                            backgroundColor: const Color(0xff560f20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CircularProgressIndicator(
                                    color: Color(0xffecd8e0),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });

                    if(_pickedImage != null) {
                      _uploadImage(image: _pickedImage!).then((value) {

                        UserSQ user = UserSQ(
                            status: userProvider.currentUser.status,
                            email: emailController.text,
                            phone: userProvider.currentUser.phone,
                            fullName: fullNameController.text,
                            address: addressController.text,
                            img: value,
                            birthDate: birthDateController.text,
                            idUser: userProvider.currentUser.idUser,
                            dateEnter: userProvider.currentUser.dateEnter,
                            gender: gender);

                        userProvider.updateUser(user).then((value) {

                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  // The background color
                                  backgroundColor: const Color(0xff560f20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Image(image: AssetImage("assets/icons/success.png"),width: 60,),
                                        // Some text
                                        SizedBox(height: 20,),
                                        Text("Update successfully",style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),),
                                        SizedBox(height: 20,),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );

                          Timer(const Duration(milliseconds: 500), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });

                          setState(() {
                            isEdit = false;
                            num = 1;
                          });
                        });
                      });
                    }
                    else {
                      UserSQ user = UserSQ(
                          status: userProvider.currentUser.status,
                          email: emailController.text,
                          phone: userProvider.currentUser.phone,
                          fullName: fullNameController.text,
                          address: addressController.text,
                          img: userProvider.currentUser.img,
                          birthDate: birthDateController.text,
                          idUser: userProvider.currentUser.idUser,
                          dateEnter: userProvider.currentUser.dateEnter,
                          gender: gender);

                      userProvider.updateUser(user).then((value) {

                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              return Dialog(
                                // The background color
                                backgroundColor: const Color(0xff560f20),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Image(image: AssetImage("assets/icons/success.png"),width: 60,),
                                      // Some text
                                      SizedBox(height: 20,),
                                      Text("Update successfully",style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );

                        Timer(const Duration(milliseconds: 500), () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });

                        setState(() {
                          isEdit = false;
                          num = 1;
                        });
                      });
                    }
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: !isEdit ? const Color(0xff81221e) : Colors.green,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                          color: !isEdit
                              ? const Color(0xff81221e).withOpacity(0.3)
                              : Colors.green.withOpacity(0.3),
                          spreadRadius: 0.06,
                          blurRadius: 24,
                          offset: const Offset(12, 12)),
                      const BoxShadow(
                          //color: Color.fromRGBO(179, 213, 242, 0.2),
                          color: Color(0xffffffff),
                          spreadRadius: 0.06,
                          blurRadius: 24,
                          offset: Offset(-12, -12)),
                    ],
                  ),
                  child: !isEdit
                      ? const Icon(Icons.edit)
                      : const Icon(Icons.check),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 300),
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // Full name
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 70,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isEdit ? const Color(0xff81221e) : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: !isEdit
                            ? [
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffe3eaef),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(4, 4)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-4, -4)),
                              ]
                            : [
                                BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: const Color(0xff81221e)
                                        .withOpacity(0.3),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: const Offset(12, 12)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-12, -12)),
                              ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person,
                            size: 30,
                            color: isEdit ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: TextField(
                            enabled: isEdit,
                            cursorColor: const Color(0xff410000),
                            style: TextStyle(
                              fontSize: 18,
                              color: isEdit ? Colors.white : Colors.grey,
                            ),
                            controller: fullNameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //hintText: currentPhoneNumber.format,
                              // prefixIcon: const Icon(
                              //   Icons.phone_android,
                              //   color: Color(0xff7c0019),
                              //   size: 30,
                              // ),
                              border: InputBorder.none,
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Phone
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width - 70,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: Color(0xffe3eaef),
                              spreadRadius: 0.06,
                              blurRadius: 24,
                              offset: Offset(4, 4)),
                          BoxShadow(
                              //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: Color(0xffffffff),
                              spreadRadius: 0.06,
                              blurRadius: 24,
                              offset: Offset(-4, -4)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 30,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: TextField(
                            enabled: false,
                            cursorColor: const Color(0xff410000),
                            style: const TextStyle(
                              letterSpacing: 1,
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              //hintText: currentPhoneNumber.format,
                              // prefixIcon: const Icon(
                              //   Icons.phone_android,
                              //   color: Color(0xff7c0019),
                              //   size: 30,
                              // ),
                              border: InputBorder.none,
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Address
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 70,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isEdit ? const Color(0xff81221e) : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: !isEdit
                            ? [
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffe3eaef),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(4, 4)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-4, -4)),
                              ]
                            : [
                                BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: const Color(0xff81221e)
                                        .withOpacity(0.3),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: const Offset(12, 12)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-12, -12)),
                              ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.map,
                            size: 30,
                            color: isEdit ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: TextField(
                            enabled: isEdit,
                            cursorColor: const Color(0xff410000),
                            style: TextStyle(
                              fontSize: 18,
                              color: isEdit ? Colors.white : Colors.grey,
                            ),
                            controller: addressController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //hintText: currentPhoneNumber.format,
                              // prefixIcon: const Icon(
                              //   Icons.phone_android,
                              //   color: Color(0xff7c0019),
                              //   size: 30,
                              // ),
                              border: InputBorder.none,
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Gender
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 70,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isEdit ? const Color(0xff81221e) : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: !isEdit
                            ? [
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffe3eaef),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(4, 4)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-4, -4)),
                              ]
                            : [
                                BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: const Color(0xff81221e)
                                        .withOpacity(0.3),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: const Offset(12, 12)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-12, -12)),
                              ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.transgender,
                            size: 30,
                            color: isEdit ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          isEdit
                              ? getDropDownButton()
                              : Text(
                                  gender,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // Birth Date
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width - 70,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isEdit ? const Color(0xff81221e) : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: !isEdit
                            ? [
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffe3eaef),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(4, 4)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-4, -4)),
                              ]
                            : [
                                BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: const Color(0xff81221e)
                                        .withOpacity(0.3),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: const Offset(12, 12)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-12, -12)),
                              ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            size: 30,
                            color: isEdit ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: TextField(
                            enabled: isEdit,
                            cursorColor: const Color(0xff410000),
                            style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 18,
                              color: isEdit ? Colors.white : Colors.grey,
                            ),
                            controller: birthDateController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              //hintText: currentPhoneNumber.format,
                              // prefixIcon: const Icon(
                              //   Icons.phone_android,
                              //   color: Color(0xff7c0019),
                              //   size: 30,
                              // ),
                              border: InputBorder.none,
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // Email
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 70,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isEdit ? const Color(0xff81221e) : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: !isEdit
                            ? [
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffe3eaef),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(4, 4)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-4, -4)),
                              ]
                            : [
                                BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: const Color(0xff81221e)
                                        .withOpacity(0.3),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: const Offset(12, 12)),
                                const BoxShadow(
                                    //color: Color.fromRGBO(179, 213, 242, 0.2),
                                    color: Color(0xffffffff),
                                    spreadRadius: 0.06,
                                    blurRadius: 24,
                                    offset: Offset(-12, -12)),
                              ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.email_rounded,
                            size: 30,
                            color: isEdit ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: TextField(
                            enabled: isEdit,
                            cursorColor: const Color(0xff410000),
                            style: TextStyle(
                              fontSize: 18,
                              color: isEdit ? Colors.white : Colors.grey,
                            ),
                            controller: emailController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //hintText: currentPhoneNumber.format,
                              // prefixIcon: const Icon(
                              //   Icons.phone_android,
                              //   color: Color(0xff7c0019),
                              //   size: 30,
                              // ),
                              border: InputBorder.none,
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // Status
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 70,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: Color(0xffe3eaef),
                              spreadRadius: 0.06,
                              blurRadius: 24,
                              offset: Offset(4, 4)),
                          BoxShadow(
                              //color: Color.fromRGBO(179, 213, 242, 0.2),
                              color: Color(0xffffffff),
                              spreadRadius: 0.06,
                              blurRadius: 24,
                              offset: Offset(-4, -4)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            size: 30,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: TextField(
                            enabled: false,
                            cursorColor: const Color(0xff410000),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            controller: statusController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              //hintText: currentPhoneNumber.format,
                              // prefixIcon: const Icon(
                              //   Icons.phone_android,
                              //   color: Color(0xff7c0019),
                              //   size: 30,
                              // ),
                              border: InputBorder.none,
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: getFooter(4, context),
    );
  }

  Widget getDropDownButton() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            decoration: const BoxDecoration(
              //borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.transparent,
              //border: Border.all(width: 1, color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                menuMaxHeight: MediaQuery.of(context).size.height / 2,
                isExpanded: true,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                dropdownColor: const Color(0xff81221e),
                value: gender,
                items: genderList.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                      style: TextStyle(
                          fontSize: 18,
                          color: isEdit ? Colors.white : Colors.grey),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomProfilePage extends CustomPainter {
  // var image;
  //
  // Future<ui.Image> loadUiImage(String imageAssetPath) async {
  //   final ByteData data = await rootBundle.load(imageAssetPath);
  //   final Completer<ui.Image> completer = Completer();
  //   ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
  //     return completer.complete(img);
  //   });
  //   image = completer.future;
  //   return completer.future;
  // }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color(0xff81221e)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height * 0.5);
    path0.quadraticBezierTo(
        size.width * 0.5, size.height, size.width, size.height * 0.5);
    path0.lineTo(size.width, 0);
    path0.lineTo(0, 0);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomProfilePageShadow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color(0xff81221e).withOpacity(0.2)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height * 0.5);
    path0.quadraticBezierTo(
        size.width * 0.5, size.height, size.width, size.height * 0.5);
    path0.lineTo(size.width, 0);
    path0.lineTo(0, 0);

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.5);

    path.quadraticBezierTo(
        size.width * 0.5, size.height, size.width, size.height * 0.5);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
