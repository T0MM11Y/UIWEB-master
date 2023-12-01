import 'package:get/get.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllPresensiController>(
      () => AllPresensiController(),
    );
  }
}
