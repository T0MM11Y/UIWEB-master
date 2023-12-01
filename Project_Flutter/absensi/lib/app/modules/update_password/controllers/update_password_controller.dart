import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController currentPasswordC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController confirmNewPasswordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  void updatePassword() async {
    if (currentPasswordC.text.isEmpty ||
        newPasswordC.text.isEmpty ||
        confirmNewPasswordC.text.isEmpty) {
      Get.snackbar("Error", "Semua field harus diisi");
      return;
    }

    if (newPasswordC.text != confirmNewPasswordC.text) {
      Get.snackbar("Error", "Password tidak sama");
      return;
    }

    isLoading.value = true;
    try {
      String emailUser = auth.currentUser!.email!;
      await auth.signInWithEmailAndPassword(
        email: emailUser,
        password: currentPasswordC.text,
      );

      await auth.currentUser!.updatePassword(newPasswordC.text);
      Get.back();
      Get.snackbar("Sukses", "Password berhasil diperbarui");
    } on FirebaseAuthException catch (e) {
      String errorMessage = (e.code == "wrong-password")
          ? "Wrong Password"
          : "${e.code.toLowerCase()}";
      Get.snackbar("Error", "Passsword anda salah");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat update Password");
    } finally {
      isLoading.value = false;
    }
  }
}
