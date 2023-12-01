import 'package:absensi/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';
import '../../../controllers/page_index_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.lightBlueAccent[200],
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Image.network(
                            user['urlphoto'] != null
                                ? user['urlphoto']
                                : "https://ui-avatars.com/api/?name=${user['nama']}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                width: 250,
                                child: Text(
                                  user["position"] != null
                                      ? "${user['address']}"
                                      : "Belum ada lokasi",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${user['role']}".toUpperCase(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("${user['nim']}",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("${user['nama']}", style: TextStyle(fontSize: 15)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller.streamTodayPresence(),
                        builder: (context, snapToday) {
                          if (snapToday.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          Map<String, dynamic>? dataToday =
                              snapToday.data?.data();
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text("Masuk ",
                                        style: TextStyle(
                                            color: dataToday?["masuk"] != null
                                                ? Colors.green
                                                : Colors.black)),
                                    SizedBox(height: 7),
                                    Text(
                                      dataToday?["masuk"] == null
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(dataToday?['masuk']['date']))}",
                                      style: TextStyle(
                                          color: dataToday?["masuk"] != null
                                              ? Colors.green
                                              : Colors.black),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.grey[400],
                                ),
                                Column(
                                  children: [
                                    Text("Keluar ",
                                        style: TextStyle(
                                            color: dataToday?["keluar"] != null
                                                ? Colors.red
                                                : Colors.black)),
                                    SizedBox(height: 7),
                                    Text(
                                      dataToday?["keluar"] == null
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(dataToday?['keluar']['date']))}",
                                      style: TextStyle(
                                          color: dataToday?["keluar"] != null
                                              ? Colors.red
                                              : Colors.black),
                                    ),
                                  ],
                                ),
                              ]);
                        }),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Last 5 days Ago",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Spacer(),
                      TextButton(
                          onPressed: () => Get.toNamed(Routes.ALL_PRESENSI),
                          child: Text("See All"))
                    ],
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.streamLastPresence(),
                      builder: (context, snapPresence) {
                        if (snapPresence.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapPresence.data?.docs.length == 0) {
                          return SizedBox(
                              height: 150,
                              child: Center(
                                  child: Text("Belum ada history presence")));
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapPresence.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data =
                                  snapPresence.data!.docs[index].data();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Material(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Get.toNamed(Routes.DETAIL_PRESENSI,
                                          arguments: data);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Masuk",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Text(
                                                "${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}",
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            data['masuk']?['date'] == null
                                                ? "-"
                                                : "${DateFormat.jms().format(DateTime.parse(data['masuk']?['date']))}",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(height: 10),
                                          Text("Keluar",
                                              style: TextStyle(fontSize: 20)),
                                          Text(
                                            data['keluar'] != null
                                                ? "${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}"
                                                : "-",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                ],
              );
            } else {
              return Center(child: Text("Tidak dapat memuat database user. "));
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
