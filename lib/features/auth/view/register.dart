import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rvaa_1/components/custom_bottom_nav.dart';
import 'package:rvaa_1/features/auth/controller/auth_controller.dart';
import 'package:rvaa_1/features/auth/view/login.dart';
import 'package:rvaa_1/components/appbar.dart';
import 'package:rvaa_1/components/text_field.dart';

class RegisterPage extends StatelessWidget {
  // const RegisterPage({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Hero(
        tag: 'rvaa',
        child: Padding(
          padding: const EdgeInsets.only(bottom: 45),
          child: SvgPicture.asset(
            'assets/svgs/rvaa_logo.svg',
            height: Get.height * 0.05,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthAppbar(
                pageName: 'Sign up',
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              const TextfieldsWidget(
                fieldName: 'Name',
                iconName: Icon(
                  Icons.person_3_outlined,
                ),
                isObscure: false,
              ),
              const TextfieldsWidget(
                fieldName: 'Phone Number',
                keyboardType: TextInputType.phone,
                iconName: Icon(Icons.phone_outlined),
                isObscure: false,
              ),
              TextfieldsWidget(
                controller: emailController,
                fieldName: 'Email',
                keyboardType: TextInputType.emailAddress,
                iconName: const Icon(Icons.email_outlined),
                isObscure: false,
              ),
              // const TextfieldsWidget(
              //   keyboardType: TextInputType.number,
              //   fieldName: 'Vehicle ID',
              //   iconName: Icon(Icons.car_rental),
              //   isObscure: false,
              // ),
              TextfieldsWidget(
                controller: passwordController,
                fieldName: 'Enter Password',
                isObscure: true,
              ),
              TextfieldsWidget(
                controller: confirmpasswordController,
                fieldName: 'Confirm Password',
                isObscure: true,
              ),
              // const Padding(
              //   padding: EdgeInsets.only(right: 40),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(
              //         'forgot password',
              //         style: TextStyle(
              //           fontSize: 14,
              //           color: Color(0xff1773B6),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                width: Get.width * 0.8,
                height: Get.height * 0.07,
                child: Hero(
                  tag: "signup",
                  child: ElevatedButton(
                    onPressed: () async {
                      final message = await AuthController().registration(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      if (message!.contains('Success')) {
                        Get.to(() => const LoginPage());
                      }
                      debugPrint(message.toString());

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                      debugPrint(message.toString());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const Text(
                'or',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: 'Already a user??   ',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign in',
                      style: const TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        color: Color(0xff1773B6),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Replace this with the action you want to perform on tap
                          debugPrint('Sign in text tapped!');
                          // For navigation example:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              ElevatedButton(
                onPressed: () {
                  signinwithGoogle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: SizedBox(
                  width: Get.width * 0.7,
                  height: Get.height * 0.07,
                  child: const Center(
                    child: Text(
                      'Sign up with Google',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: Get.height * 0.4,
              )
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<UserCredential> signinwithGoogle() async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

  debugPrint(
    userCredential.user?.displayName.toString(),
  );

  if (userCredential.user != null) {
    Get.to(() => const CustomBottomNav());
  } else {
    Get.snackbar("Error", "Something went wrong");
  }
  return userCredential;
}
