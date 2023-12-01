import 'package:absensi/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
        backgroundColor: Colors.lightBlueAccent[200],
        centerTitle: true,
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 26, right: 26, top: 1, bottom: 24),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animated image (replace 'assets/animated_image.gif' with your actual path)
                Image.asset(
                  'assets/loginanimasi.gif',
                  height: 150,
                  width: 150,
                  // You can adjust the height and width as needed
                ),
                SizedBox(height: 10),
                TextField(
                  autocorrect: false,
                  controller: controller.emailC,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.lightGreen[50],
                    prefixIcon: Icon(Icons.person, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  autocorrect: false,
                  controller: controller.passwordC,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.lightGreen[50],
                    prefixIcon: Icon(Icons.person, color: Colors.blue),
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => ElevatedButton.icon(
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        await controller.Login();
                      }
                    },
                    icon: Icon(Icons.login),
                    label: Text(
                        controller.isLoading.isTrue ? 'Loading...' : 'Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent[200],
                      padding: EdgeInsets.all(14),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                  child: Text(
                    'Lupa Password?',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
