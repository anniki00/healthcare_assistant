import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_assistant/features/authentification/controller/authentification_controller.dart';
import 'package:healthcare_assistant/features/authentification/screens/register_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  AuthentificationController controller =
      Get.put(AuthentificationController(), permanent: true);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("3c5aca"),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 350,
                  width: double.infinity,
                  child:
                      Image.asset("assets/images/login.jpeg", fit: BoxFit.fill),
                ),
                const SizedBox(height: 22.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: TextFormField(
                    controller: controller.loginEmailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: GetBuilder<AuthentificationController>(
                    builder: (controller) => TextFormField(
                      controller: controller.loginPasswordController,
                      obscureText: controller.obscureText,
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: const TextStyle(color: Colors.white),
                        helperStyle: const TextStyle(color: Colors.red),
                        suffixIcon: IconButton(
                          onPressed: () => controller.showHidePassword(),
                          icon: Icon(
                            controller.obscureText
                                ? HeroIcons.eye
                                : HeroIcons.eye_slash,
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: TextButton(
                    onPressed: () => Get.to(() => RegisterScreen(),
                        transition: Transition.rightToLeft),
                    child: const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: InkWell(
                    radius: 22.0,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        controller.login(
                          emailController: controller.loginEmailController,
                          passwordController:
                              controller.loginPasswordController,
                        );
                      }
                    },
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: HexColor("4ce3b0"),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: const Center(
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
