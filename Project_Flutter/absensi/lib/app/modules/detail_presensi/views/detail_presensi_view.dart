import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  DetailPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Presensi'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date'].toString()))}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Masuk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // masuk
                  Text(
                      "jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date'].toString()))}"),
                  Text(data['masuk']?['latitude'] == null &&
                          data['masuk']?['longitude'] == null
                      ? "Posisi : -"
                      : "Posisi : ${data['masuk']?['longitude']}, ${data['masuk']?['latitude']}"),
                  Text("Status : ${data['masuk']!['status']}"),
                  Text("Address : ${data['masuk']!['address']}"),
                  Text(
                      "Distance : + - ${data['masuk']!['distance'].toString().split(".").first} meter"),

                  SizedBox(height: 10),

                  // keluar
                  Text(
                    "Keluar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data['keluar']?['date'] == null
                      ? "Jam : -"
                      : "jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']['date'].toString()))}"),
                  Text(data['keluar']?['latitude'] == null &&
                          data['keluar']?['longitude'] == null
                      ? "Posisi : -"
                      : "Posisi : ${data['keluar']?['longitude']}, ${data['keluar']?['latitude']}"),
                  Text(data['keluar']?['status'] == null
                      ? "Status : -"
                      : "Status : ${data['keluar']!['status']}"),
                  Text(data['keluar']?['address'] == null
                      ? "Address : -"
                      : "Address : ${data['keluar']!['address']}"),
                  Text(data['keluar']?['distance'] == null
                      ? "Distance : -"
                      : "Distance : + - ${data['keluar']!['distance'].toString().split(".").first} meter"),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
            ),
          ],
        ));
  }
}
