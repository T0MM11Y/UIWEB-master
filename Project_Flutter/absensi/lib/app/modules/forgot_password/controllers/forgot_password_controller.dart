import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.snackbar("Success", "Password reset email sent successfully");

      try {
        await auth.sendPasswordResetEmail(email: emailC.text);

        // Clear the email field after successful email sending
        emailC.clear();

        Get.back(); // Close the current screen or dialog
      } catch (e) {
        print("Error sending reset email: $e");
        Get.snackbar("Error",
            "Unable to send password reset email. Contact admin or try again later");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Please enter your email address");
    }
  }
}
