import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateProfileController>(
      () => UpdateProfileController(),
    );
  }
}
