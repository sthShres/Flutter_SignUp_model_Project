import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:otp_application/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();

  Country SelectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");
  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(30),
                  child: Image.asset("assets/one.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  "Registration Login",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Regiser or loign by you number we will",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      phoneController.text = value;
                    });
                  },
                  cursorColor: Colors.orange,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: "Enter phone number",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade600),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.orange),
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 500),
                              onSelect: (value) {
                                setState(() {
                                  SelectedCountry = value;
                                });
                              });
                        },
                        child: Text(
                          "${SelectedCountry.flagEmoji} + ${SelectedCountry.phoneCode}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: phoneController.text.length > 9
                        ? Container(
                            height: 25,
                            width: 25,
                            margin: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.green),
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: "Login",
                    onPressed: () => sendPhoneNumber(),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );

  }

  void sendPhoneNumber(){
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${SelectedCountry.phoneCode}$phoneNumber");
  
  }
}
