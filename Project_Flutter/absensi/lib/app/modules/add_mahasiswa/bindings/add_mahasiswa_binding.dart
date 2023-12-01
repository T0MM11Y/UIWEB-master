import 'package:get/get.dart';

import '../controllers/add_mahasiswa_controller.dart';

class AddMahasiswaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMahasiswaController>(
      () => AddMahasiswaController(),
    );
  }
}
