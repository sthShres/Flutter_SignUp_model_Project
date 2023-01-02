import 'dart:io';

import 'package:flutter/material.dart';
import 'package:otp_application/screens/home_screen.dart';
import 'package:otp_application/utils/utils.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../provider/auth_provider.dart';
import '../widgets/custom_button.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({Key? key}) : super(key: key);

  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }
    // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
     final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
        ? const Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        )
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
        child: Center(
            child: Column(
          children: [
            InkWell(
              onTap: () =>selectImage(),
              child: image == null
                  ? const CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 50,
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  // name field
                  textFeld(
                    hintText: "John Smith",
                    icon: Icons.account_circle,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: nameController,
                  ),

                  // email
                  textFeld(
                    hintText: "abc@example.com",
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    maxLines: 1,
                    controller: emailController,
                  ),

                  // bio
                  textFeld(
                    hintText: "Enter your bio here...",
                    icon: Icons.edit,
                    inputType: TextInputType.name,
                    maxLines: 2,
                    controller: bioController,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: CustomButton(
                      text: "Continue",
                         onPressed: () => storeData(),
                    ),
                  )
                ],
              ),
            )
          ],
        )),
      )),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.orange,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true,
        ),
      ),
    );
  }


   // store user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      bio: bioController.text.trim(),
      profilePic: "",
      createdAt: "",
      phoneNumber: "",
      uid: "",
    );
    if (image != null) {
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackbar(context, "Please upload your profile photo");
    }
  }
}
