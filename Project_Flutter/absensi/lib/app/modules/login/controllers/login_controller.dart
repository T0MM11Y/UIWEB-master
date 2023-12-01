import 'package:absensi/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> Login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passwordC.text);

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passwordC.text == "12345678") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
              Get.snackbar("Berhasil", "Login berhasil");
            }
          } else {
            Get.defaultDialog(
                title: "Belum verifikasi",
                middleText: "Silahkan verifikasi email anda terlebih dahulu",
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      isLoading:
                      false;
                      Get.back();
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await userCredential.user!.sendEmailVerification();
                        Get.back();
                        Get.snackbar(
                            "Berhasil", "Email verifikasi berhasil dikirim");
                        isLoading:
                        false;
                      } catch (e) {
                        isLoading:
                        false;
                        Get.snackbar("Terjadi kesalahan ",
                            "Tidak dapat mengirim email verifikasi hubungi admin atau coba lagi nanti");
                      }
                    },
                    child: Text("Kirim Email Verifikasi"),
                  ),
                ]);
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          Get.snackbar("Error", "Akun tidak ditemukan.");
        } else {
          print('Wrong password provided for that user.');
          Get.snackbar("Error", "Password salah.");
        }
      } catch (e) {
        print(e);
        isLoading.value = false;

        Get.snackbar("Error", "Terjadi kesalahan: $e");
      }
    } else {
      Get.snackbar("Error", "Semua data harus diisi");
    }
  }
}
