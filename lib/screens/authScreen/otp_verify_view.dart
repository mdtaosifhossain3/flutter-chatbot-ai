import 'package:chatgpt_clone/constants/constants.dart';
import 'package:chatgpt_clone/screens/welcomeScreen/welcome_screen.dart';
import 'package:chatgpt_clone/widgets/button_widget.dart';
import 'package:chatgpt_clone/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

import '../../services/verify_otp_service.dart';

class OtpVerificationView extends StatelessWidget {
  OtpVerificationView({super.key});

  final otpController = TextEditingController();
  final service = VerifyOTPService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const WelcomePage()));
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        backgroundColor: whiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Enter the OTP to activate your account",
                  style: TextStyle(
                      color: buttonColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              Column(
                children: [
                  TextFieldWidget(
                    controller: otpController,
                    hintText: 'Enter your otp...',
                    style: TextStyle(color: buttonColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                      onTap: () async {
                        await service.verifyOTP(context, otpController);
                      },
                      child: const ButtonWidget(label: "Verify")),
                ],
              )
            ],
          ),
        ));
  }
}
