import 'package:flutter/material.dart';
import 'package:otp_application/screens/home_screen.dart';
import 'package:otp_application/screens/user_info_screen.dart';
import 'package:otp_application/utils/utils.dart';
import 'package:otp_application/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
              child: isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    )
                  : Center(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 35),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: const Icon(Icons.arrow_back),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                width: 200,
                                height: 200,
                                padding: const EdgeInsets.all(30),
                                child: Image.asset("assets/two.png"),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Verify your otp",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Once you will will submit the otp you will be redirected",
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
                              Pinput(
                                length: 6,
                                showCursor: true,
                                defaultPinTheme: PinTheme(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.orange.shade200),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                onCompleted: (value) {
                                  setState(() {
                                    otpCode = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: CustomButton(
                                  text: "Verify",
                                  onPressed: () {
                                    if (otpCode != null) {
                                      verifyOtp(context, otpCode!);
                                    } else {
                                      showSnackbar(
                                          context, "Enter 6-digit code");
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Didn't receive any code?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Resend New Code",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ))))),
    );
  }

  //verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSucess: () {
          //check wearther 
          ap.checkExistingUser().then((value) async{
            if(value == true){
   ap.getDataFromFirestore().then(
                    (value) => ap.saveUserDataToSP().then(
                          (value) => ap.setSignIn().then(
                                (value) => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                    (route) => false),
                              ),
                        ),
                  );

              //user exists in our app
            }else{
              //new user
             Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context)=> 
              const UserInformationPage()),
              (route) => false);
            }

          },);
        });
  }
}
