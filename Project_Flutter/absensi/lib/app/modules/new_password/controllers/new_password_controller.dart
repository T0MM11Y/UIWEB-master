import 'package:absensi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController newPasswordC = TextEditingController();

  void saveNewPassword() async {
    if (newPasswordC.text.isNotEmpty) {
      if (newPasswordC.text != "12345678") {
        try {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPasswordC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: newPasswordC.text);
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
            Get.snackbar("Error",
                "Password terlalu lemah. Setidaknya 6 character.");
          }
        } catch (e) {
          print(e);
          Get.snackbar("Error", "Terjadi kesalahan: $e");
        }
      } else {
        Get.snackbar(
            "Error", "Password tidak boleh sama dengan password sebelumnya");
      }
    } else {
      Get.snackbar("Error", "Password tidak boleh kosong");
    }
  }
}
