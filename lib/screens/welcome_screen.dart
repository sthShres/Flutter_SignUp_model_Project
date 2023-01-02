import 'package:flutter/material.dart';
import 'package:otp_application/provider/auth_provider.dart';
import 'package:otp_application/screens/home_screen.dart';
import 'package:otp_application/screens/register_screen.dart';
import 'package:otp_application/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/three.png",
                    height: 300,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Let's Get Started",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Do this by first of jan because its important",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: CustomButton(
                        onPressed: () async {
                      if (ap.isSignedIn == true) {
                        await ap.getDataFromSP().whenComplete(
                              () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              ),
                            );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      }
                    },
                      text: "Get started",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
