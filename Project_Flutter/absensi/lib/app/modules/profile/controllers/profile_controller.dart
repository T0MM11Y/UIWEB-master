import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:absensi/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream() async* {
    String uid = await auth.currentUser!.uid;

    yield* firestore.collection("mahasiswa").doc(uid).snapshots();
  }
  void logout() async {
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
