import 'package:chatgpt_clone/constants/constants.dart';
import 'package:chatgpt_clone/screens/authScreen/register_screen.dart';
import 'package:chatgpt_clone/screens/welcomeScreen/welcome_screen.dart';
import 'package:chatgpt_clone/services/login_service.dart';
import 'package:chatgpt_clone/widgets/button_widget.dart';
import 'package:chatgpt_clone/widgets/text_field_widget.dart';
import 'package:chatgpt_clone/widgets/text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController number = TextEditingController();
  //Login Service
  final loginService = LoginService();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0.00,
        backgroundColor: whiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const WelcomePage();
            }));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: buttonColor,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    const TextWidget(
                      label: "Welcome back! Glad to see you, Again!",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFieldWidget(
                      hintText: 'Enter your email',
                      controller: email,
                      style: TextStyle(color: buttonColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFieldWidget(
                      hintText: 'Enter your Robi/Airtel Number',

                      controller: number,
                      style: TextStyle(color: buttonColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFieldWidget(
                      hintText: 'Enter your password',
                      isObScureText: true,
                      controller: password,
                      style: TextStyle(color: buttonColor),
                    ),
                    const SizedBox(
                      height: 52,
                    ),
                    InkWell(
                      onTap: () {
                        if (email.text == '' || password.text == "" || number.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Fields Cant be Empty")));
                        } else {
                          loginService.login(
                              context: context,
                              email: email.text,
                              password: password.text,
                              mobileNumber: number.text);
                        }
                      },
                      child: const ButtonWidget(
                        label: "Login",
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TextWidget(
                      label: "Don’t have an account?",
                      fontSize: 15,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: const TextWidget(
                        label: "Regiser Now",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
