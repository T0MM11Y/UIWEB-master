import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.nimC.text = user['nim'];
    controller.namaC.text = user['nama'];
    controller.emailC.text = user['email'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[200],
        title: const Text('Update Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      autocorrect: false,
                      controller: controller.nimC,
                      decoration: InputDecoration(
                        labelText: "NIM",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.lightGreen[50],
                        prefixIcon: Icon(Icons.account_box_outlined,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      autocorrect: false,
                      controller: controller.emailC,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.lightGreen[50],
                        prefixIcon:
                            Icon(Icons.email_outlined, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      autocorrect: false,
                      controller: controller.namaC,
                      decoration: InputDecoration(
                        labelText: "Nama",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.lightGreen[50],
                        prefixIcon: Icon(Icons.person_2, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<UpdateProfileController>(
                        builder: (c) {
                          if (c.image != null) {
                            return ClipOval(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                child: Image.file(
                                  File(c.image!.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            if (user["urlphoto"] != null) {
                              return Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      child: Image.network(
                                        user['urlphoto'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      child: Image.network(
                                        "https://ui-avatars.com/api/?name=${user['nama']}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              );
                            }
                          }
                        },
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround, // You can adjust the alignment as needed
                          children: [
                            IconButton(
                              onPressed: () async {
                                controller.deleteProfile(user['uid']);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[400],
                                size: 40,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                controller.pickImage();
                              },
                              icon: Icon(
                                Icons.photo_camera,
                                color: Colors.lightBlueAccent[200],
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => ElevatedButton(
                      onPressed: () async {
                        if (controller.isLoading.isFalse) {
                          await controller.updateProfile(user['uid']);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle, size: 15),
                          SizedBox(width: 5),
                          Text(
                            controller.isLoading.isFalse
                                ? "Update Profile"
                                : "Loading...",
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent[200],
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
