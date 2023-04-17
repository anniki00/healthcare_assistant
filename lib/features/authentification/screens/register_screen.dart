import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_assistant/features/authentification/controller/authentification_controller.dart';
import 'package:healthcare_assistant/features/authentification/screens/login_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:icons_plus/icons_plus.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  AuthentificationController controller =
      Get.put(AuthentificationController(), permanent: true);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(HeroIcons.chevron_left)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 46.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: TextFormField(
                  controller: controller.registerEmailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
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
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: TextFormField(
                  controller: controller.nameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    if (value.length < 3) {
                      return 'Password must be at least 3 characters long';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: GetBuilder<AuthentificationController>(
                  builder: (controller) => TextFormField(
                    controller: controller.registerPasswordController,
                    obscureText: controller.obscureText,
                    style: const TextStyle(color: Colors.black),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!value.contains(RegExp(r'[a-z]'))) {
                        return 'Password must contain at least one lowercase letter';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Password must contain at least one digit';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: IconButton(
                        onPressed: () => controller.showHidePassword(),
                        icon: Icon(
                          controller.obscureText
                              ? HeroIcons.eye
                              : HeroIcons.eye_slash,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: GetBuilder<AuthentificationController>(
                  builder: (controller) => TextFormField(
                    obscureText: controller.obscureText,
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm the password';
                      }
                      if (value != controller.registerPasswordController.text) {
                        return "Passwords don't match";
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: IconButton(
                        onPressed: () => controller.showHidePassword(),
                        icon: Icon(
                          controller.obscureText
                              ? HeroIcons.eye
                              : HeroIcons.eye_slash,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: TextButton(
                  onPressed: () => Get.off(() => LoginScreen(),
                      transition: Transition.rightToLeft),
                  child: const Text(
                    "Already registred?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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
                      controller.register(
                        emailController: controller.registerEmailController,
                        passwordController:
                            controller.registerPasswordController,
                        nameController: controller.nameController,
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
                        'SIGN UP',
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
    );
  }
}
