import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

FirebaseFirestore firestore = FirebaseFirestore.instance;
s.FirebaseStorage storage = s.FirebaseStorage.instance;

class UpdateProfileController extends GetxController {
  //TODO: Implement UpdateProfileController
  RxBool isLoading = false.obs;

  TextEditingController nimC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePickerPlatform picker = ImagePickerPlatform.instance;

  Future<void> updateProfile(String uid) async {
    if (nimC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;

      try {
        Map<String, dynamic> data = {
          "nama": namaC.text,
        };
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.path.split(".").last;
          await storage // upload image to firebase storage
              .ref("$uid/urlphoto.$ext")
              .putFile(file);
          String urlImage = await storage // upload image to firebase storage
              .ref("$uid/urlphoto.$ext")
              .getDownloadURL();
          data.addAll({"urlphoto": urlImage});
        }
        await firestore.collection("mahasiswa").doc(uid).update(data);
        Get.back();
        Get.snackbar("Berhasil", "Berhasil mengupdate profile");
      } catch (e) {
        Get.snackbar("Terjadi kesalahan ", "Tidak dapat mengupdate profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  PickedFile? image;
  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print(image!.path);

      // Extracting the file name from the path
      String fileName = image!.path.split('/').last;
      print(fileName);

      // If you want to get the file extension
      String fileExtension = fileName.split('.').last;

      print(fileExtension);
    } else {
      print(image);
    }
    update();
  }

  void deleteProfile(String uid) async {
    try {
      // Get the document reference
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("mahasiswa").doc(uid);

      // Check if the document exists before updating
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        // Update the document by deleting the "urlphoto" field
        await documentReference.update({
          "urlphoto": FieldValue.delete(),
        });
        update();
        Get.back();
        image = null;
        Get.snackbar("Sukses", "Profile berhasil dihapus");
      } else {
        Get.snackbar("Error", "Dokumen tidak ditemukan");
      }
    } catch (e) {
      // Handle errors
      print("Error: $e");
      Get.snackbar("Terjadi kesalahan", "Tidak dapat menghapus profile");
    }
  }
}
