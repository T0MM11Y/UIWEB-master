import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMahasiswaController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  TextEditingController nimC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddMahasiswa() async {
    final passwordAdmin = passwordAdminC.text;

    if (passwordAdmin.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        final emailAdmin = auth.currentUser!.email!;

        // Mencoba login sebagai admin
        await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passwordAdmin,
        );

        // Mencoba membuat akun mahasiswa
        final UserCredential mahasiswaCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "12345678",
        );

        if (mahasiswaCredential.user != null) {
          final uid = mahasiswaCredential.user!.uid;

          await firestore.collection("mahasiswa").doc(uid).set({
            "nim": nimC.text,
            "nama": namaC.text,
            "email": emailC.text,
            "uid": uid,
            "role": "mahasiswa",
            "createdAt": DateTime.now().toIso8601String(),
          });
          await mahasiswaCredential.user!.sendEmailVerification();

          await auth.signOut();

          // Login kembali sebagai admin
          await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passwordAdmin,
          );

          Get.back(); // Kembali ke dialog
          Get.back(); // Kembali ke halaman utama

          Get.snackbar("Berhasil", "Mahasiswa berhasil ditambahkan");
        }
        isLoadingAddPegawai.value = false;
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if (e.code == 'email-already-in-use') {
          Get.snackbar("Error", "Akun dengan email tersebut sudah ada.");
        } else {
          Get.snackbar("Error", "Password Admin salah");
        }
      } catch (e) {
        isLoadingAddPegawai.value = false;

        Get.snackbar(
            "Error", "Terjadi kesalahan: Tidak dapat menambahkan mahasiswa");
      }
    } else {
      isLoading.value = false;

      Get.snackbar("Error", "Password Admin tidak boleh kosong");
    }
  }

  Future<void> AddMahasiswa() async {
    if (nimC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: "Validasi Admin ",
        content: Column(
          children: [
            Text("Masukkan password untuk validasi admin"),
            SizedBox(height: 10),
            TextField(
              controller: passwordAdminC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: Text("Cancel"),
          ),
          Obx(() => ElevatedButton(
                onPressed: () async {
                  if (isLoadingAddPegawai.isFalse) {
                    await prosesAddMahasiswa();
                  }
                  isLoading.value = false;
                },
                child: Text(isLoadingAddPegawai.isFalse
                    ? "Add Mahasiswa"
                    : "Loading..."),
              )),
        ],
      );
    } else {
      Get.snackbar("Error", "Semua data harus diisi");
    }
  }
}
