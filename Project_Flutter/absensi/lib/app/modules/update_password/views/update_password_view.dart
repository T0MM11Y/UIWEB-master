import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Password'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              controller: controller.currentPasswordC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
                icon: Icon(Icons.lock), // Tambahkan ikon
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.newPasswordC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
                icon: Icon(Icons.lock), // Tambahkan ikon
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.confirmNewPasswordC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                border: OutlineInputBorder(),
                icon: Icon(Icons.lock), // Tambahkan ikon
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                
                
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.isLoading.value = true;
                    controller.updatePassword();
                    controller.isLoading.value = false;
                  }
                  
                },
                
                child: Text((controller.isLoading.isFalse)
                    ? "Change Password"
                    : "Loading..."),
                    
              ),
            ),
          ],
        ));
  }
}
