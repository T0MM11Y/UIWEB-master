import 'package:get/get.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPresensiController>(
      () => DetailPresensiController(),
    );
  }
}
