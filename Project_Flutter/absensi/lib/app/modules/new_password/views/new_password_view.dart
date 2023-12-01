import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Password'),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.newPasswordC,
            obscureText: true,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: "New Password",
              border: OutlineInputBorder(),
              icon: Icon(Icons.lock), // Tambahkan ikon
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.saveNewPassword();
            },
            child: Text("Simpan"),
            style: ElevatedButton.styleFrom(
              primary: Colors.orangeAccent,
              padding: EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
