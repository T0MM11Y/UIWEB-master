import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_mahasiswa_controller.dart';

class AddMahasiswaView extends GetView<AddMahasiswaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Mahasiswa'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.account_box_outlined),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      autocorrect: false,
                      controller: controller.nimC,
                      decoration: InputDecoration(
                        labelText: "NIM",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      autocorrect: false,
                      controller: controller.namaC,
                      decoration: InputDecoration(
                        labelText: "Nama",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      autocorrect: false,
                      controller: controller.emailC,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    if (controller.isLoading.isFalse) {
                      await controller.AddMahasiswa();
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 17),
                      SizedBox(width: 7),
                      Text(controller.isLoading.isFalse
                          ? "Add Mahasiswa"
                          : "Loading..."),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
