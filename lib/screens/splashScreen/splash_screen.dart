import 'dart:async';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:chatgpt_clone/screens/chatScreen/chat_screen.dart';
import 'package:chatgpt_clone/screens/welcomeScreen/welcome_screen.dart';
import 'package:chatgpt_clone/services/assets_manager.dart';
import 'package:chatgpt_clone/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  _user != null ? const ChatScreen() : const WelcomePage()),
          (route) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadedScaleAnimation(child: Image.asset(AssetsManager.splashScreenUrl)),
        const SizedBox(
          height: 10,
        ),
        FadedScaleAnimation(
          child: const TextWidget(
            label: "Hello!",
            fontSize: 24,
          ),
        )
      ],
    )));
  }
}
