import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white, // Set the background color to white

      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 26, right: 26, top: 1, bottom: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/loginanimasi.gif',
                height: 150,
                width: 150,
                // You can adjust the height and width as needed
              ),
              SizedBox(height: 20),
              _buildEmailTextField(),
              SizedBox(height: 30),
              _buildResetPasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      autocorrect: false,
      controller: controller.emailC,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        icon: Icon(Icons.person), filled: true,
        fillColor: Colors.lightGreen[50],
        prefixIcon:
            Icon(Icons.person, color: Colors.blue), // Set your preferred color
      ),
    );
  }

  Widget _buildResetPasswordButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.isFalse ? controller.sendEmail : null,
        child: Text(
          controller.isLoading.isTrue
              ? 'Loading...'
              : 'Send Reset Password Link',
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.greenAccent,
          padding: EdgeInsets.all(12),
        ),
      ),
    );
  }
}
