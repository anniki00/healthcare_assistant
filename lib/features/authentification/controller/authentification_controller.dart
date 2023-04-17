import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthcare_assistant/features/authentification/screens/login_screen.dart';
import 'package:healthcare_assistant/features/home/home_screen.dart';
import 'package:quickalert/quickalert.dart';

class AuthentificationController extends GetxController {
  bool obscureText = true;

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  void showHidePassword() {
    obscureText = !obscureText;
    update();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> login({emailController, passwordController}) async {
    try {
      QuickAlert.show(context: Get.context!, type: QuickAlertType.loading);
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Get.back();
      Get.to(() => HomeScreen(
            user: _auth.currentUser!,
          ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Get.back();
        QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.error,
            title: "Invalid email or password.");
      } else {
        // Handle other errors
        Get.back();
        QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.error,
            title: "Error please try again",
            text: e.toString());
      }
    } catch (e) {
      Get.back();
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: "Error please try againn",
          text: e.toString());
    }
  }

  Future<void> register(
      {emailController, passwordController, nameController}) async {
    try {
      QuickAlert.show(context: Get.context!, type: QuickAlertType.loading);
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _db.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
      });
      Get.back();
      Get.offAll(() => LoginScreen());
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.success,
          title: "Sign Up Success");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.back();
        QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.error,
            title: "The password provided is too weak.");
        // Handle weak password error
      } else if (e.code == 'email-already-in-use') {
        // Handle email already in use error
        Get.back();
        QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.error,
            title: "The account already exists for that email.");
      } else {
        // Handle other errors
        Get.back();
        QuickAlert.show(
            context: Get.context!,
            type: QuickAlertType.error,
            title: "Error please try again",
            text: e.code);
      }
    } catch (e) {
      Get.back();
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          title: "Error please try again",
          text: e.toString());
    }
  }

  void logout() {
    QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.confirm,
        title: "Are you sure to logout?",
        onCancelBtnTap: () => Get.back(),
        onConfirmBtnTap: () {
          _auth.signOut();
          Get.offAll(() => LoginScreen());
        });
  }
}
