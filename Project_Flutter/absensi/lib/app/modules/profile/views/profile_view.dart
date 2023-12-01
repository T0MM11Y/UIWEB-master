import 'package:absensi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../../../controllers/page_index_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent[200],
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.userStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData && !snapshot.hasError) {
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${snapshot.data?.data()?['nama']}";
              Map<String, dynamic>? userData = snapshot.data?.data();
              Map<String, dynamic> user = userData ?? {};
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Image.network(
                              user['urlphoto'] != null
                                  ? user['urlphoto'] != ""
                                      ? user['urlphoto']
                                      : defaultImage
                                  : defaultImage,
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    "${user['nama'].toString().toUpperCase()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "${user['email']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ListTile(
                    onTap: () =>
                        Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                    leading: Icon(Icons.person),
                    title: Text("Update Profile"),
                  ),
                  ListTile(
                    onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                    leading: Icon(Icons.vpn_key),
                    title: Text("Update Password"),
                  ),
                  if (user['role'] == 'admin')
                    ListTile(
                      onTap: () => Get.toNamed(Routes.ADD_MAHASISWA),
                      leading: Icon(Icons.person_add),
                      title: Text("Add Mahasiswa"),
                    ),
                  ListTile(
                    onTap: () => controller.logout(),
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  )
                ],
              );
            } else {
              return const Center(
                child: Text("Tidak dapat memuat Data User "),
              );
            }
          },
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.lightBlueAccent[200],
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
