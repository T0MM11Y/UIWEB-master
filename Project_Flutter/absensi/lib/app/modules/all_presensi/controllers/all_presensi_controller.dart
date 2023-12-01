import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresensiController extends GetxController {
  DateTime? start;
  DateTime end = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {
    String uid = auth.currentUser!.uid;

    print(start);
    print(end);
    if (start == null) {
      //get seluruh presensi sampai saat inia
      return await firestore
          .collection("mahasiswa")
          .doc(uid)
          .collection("presence")
          .where("date", isLessThanOrEqualTo: end.toIso8601String())
          .orderBy("date", descending: true)
          .get();
    } else {
      return await firestore
          .collection("mahasiswa")
          .doc(uid)
          .collection("presence")
          .where("date", isGreaterThanOrEqualTo: start!.toIso8601String())
          .where("date", isLessThanOrEqualTo: end.add(Duration(days: 1)).toIso8601String())
          .orderBy("date", descending: true)
          .get();
    }
  }

  void pickDate(DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end = pickEnd;
    update();
    Get.back();
  }
}
