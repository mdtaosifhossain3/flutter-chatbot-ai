import 'package:chatgpt_clone/constants/constants.dart';
import 'package:chatgpt_clone/screens/authScreen/login_screen.dart';
import 'package:chatgpt_clone/screens/authScreen/register_screen.dart';
import 'package:chatgpt_clone/services/assets_manager.dart';
import 'package:chatgpt_clone/widgets/button_widget.dart';
import 'package:chatgpt_clone/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //-----------------------Logo-----------------------
              Image.asset(
                AssetsManager
                    .splashScreenUrl, // Replace with your image asset path
                height: 150.0,
              ),

              //-----------------------welcome text-----------------------
              const TextWidget(
                label: 'Welcome to Chatbot App',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),

              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextWidget(
                    label:
                        "Get started with our smart chatbot that can assist you 24/7.",
                    fontSize: 17.00,
                    textAlign: TextAlign.center,
                  )),

              const SizedBox(height: 30.0),

              //-----------------------LOGIN-----------------------
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginScreen();
                    }));
                  },
                  child: const ButtonWidget(label: "Login")),

              const SizedBox(height: 15.0),

              //-----------------------Register-----------------------
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const RegisterScreen();
                  }));
                },
                child: ButtonWidget(
                    label: "Register",
                    bgcolor: whiteColor,
                    textColor: Colors.black,
                    borderColor: buttonColor),
              ),
              //-----------------------Sign Up-----------------------
            ],
          ),
        ),
      ),
    );
  }
}
