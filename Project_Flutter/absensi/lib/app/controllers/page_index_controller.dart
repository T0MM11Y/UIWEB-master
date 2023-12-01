import 'package:absensi/app/modules/update_profile/controllers/update_profile_controller.dart';
import 'package:absensi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    print("click index $i");
    switch (i) {
      case 1:
        Map<String, dynamic> dataResponse = await _determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address =
              "${placemarks[2].street},  ${placemarks[2].locality},${placemarks[2].administrativeArea}";
          await updatePosition(position, address);
          //cek distance beetween position and campus
          double distance = Geolocator.distanceBetween(
              2.383225, 99.1485293, position.latitude, position.longitude);

          await presensi(position, address, distance);
        } else {
          Get.snackbar("Error", dataResponse["message"]);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("mahasiswa").doc(uid).collection("presence");
    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");
    String status = "Diluar Area";
    if (distance <= 100) {
      status = "Didalam Area";
    }

    if (snapPresence.docs.length == 0) {
      // belum pernah absen dan set absen masuk pertama kali
      await Get.defaultDialog(
        title: "Validasi Presensi",
        middleText: "Apakah anda yakin ingin absen masuk?",
        actions: [
          OutlinedButton(onPressed: () => Get.back(), child: Text("Batal")),
          OutlinedButton(
              onPressed: () async {
                await colPresence.doc(todayDocID).set({
                  "date": now.toIso8601String(),
                  "masuk": {
                    "date": now.toIso8601String(),
                    "latitude": position.latitude,
                    "longitude": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                  }
                });
                Get.back();
                    Get.snackbar("Sukses", "Absen masuk berhasil");
              },
              child: Text("Yes")),
        ],
      );
    } else {
      // sudah pernah absen, cek hari ini sudah absen masuk atau belum?
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        // absen keluar atau sudah absen masuk dan keluar
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          // sudah absen masuk dan keluar
          Get.snackbar("Informasi Penting", "Anda sudah absen masuk dan keluar tidak dapat mengubah data lagi");
        } else {
          // sudah absen masuk, belum absen keluar
          await Get.defaultDialog(
            title: "Validasi Presensi",
            middleText: "Apakah anda yakin ingin absen keluar?",
            actions: [
              OutlinedButton(onPressed: () => Get.back(), child: Text("Batal")),
              OutlinedButton(
                  onPressed: () async {
                    await colPresence.doc(todayDocID).update({
                      "keluar": {
                        "date": now.toIso8601String(),
                        "latitude": position.latitude,
                        "longitude": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    });
                    Get.back();
                    Get.snackbar("Sukses", "Absen keluar berhasil");
                  },
                  child: Text("Yes")),
            ],
          );
        }
      } else {
        await Get.defaultDialog(
          title: "Validasi Presensi",
          middleText: "Apakah anda yakin ingin absen masuk?",
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("Batal")),
            OutlinedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocID).set({
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "latitude": position.latitude,
                      "longitude": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  });
                  Get.back();
                    Get.snackbar("Sukses", "Absen masuk berhasil");
                },
                child: Text("Yes")),
          ],
        );
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;

    await firestore.collection("mahasiswa").doc(uid).update({
      "position": {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
      "address": address
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        "message":
            "Tidak dapat mengakses lokasi, silahkan aktifkan GPS pada settingan hapemu",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "message":
              "Izin menggunakan GPS ditolak, silahkan izinkan  GPS pada settingan hapemu",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        "message":
            "Settingan hapemu tidak mengizinkan aplikasi mengakses lokasi",
        "error": true,
      };
    }
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "berhasil mendapat posisi device",
      "error": false,
    };
  }
}
