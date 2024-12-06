import 'package:chatgpt_clone/constants/constants.dart';
import 'package:chatgpt_clone/screens/authScreen/login_screen.dart';
import 'package:chatgpt_clone/screens/welcomeScreen/welcome_screen.dart';
import 'package:chatgpt_clone/services/register_service.dart';
import 'package:chatgpt_clone/services/send_otp_service.dart';
import 'package:chatgpt_clone/widgets/button_widget.dart';
import 'package:chatgpt_clone/widgets/text_field_widget.dart';
import 'package:chatgpt_clone/widgets/text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();

//SignUp Service
  RegisterService signUpService = RegisterService();
  SendOTPService sendOTPService = SendOTPService();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    mobile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0.00,
        backgroundColor: whiteColor,
        surfaceTintColor: Colors.transparent,
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
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: [
                      const TextWidget(
                        label: "Hello! Register to get started",
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFieldWidget(
                        hintText: 'Enter your Name',
                        controller: name,
                        style: TextStyle(color: buttonColor),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        hintText: 'Enter your email',
                        controller: email,
                        style: TextStyle(color: buttonColor),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        hintText: 'Enter your password',
                        style: TextStyle(color: buttonColor),
                        isObScureText: true,
                        controller: password,
                      ),
                      const SizedBox(
                        height: 52,
                      ),
                      InkWell(
                        onTap: () async {
                          if (email.text == '' ||
                              password.text == "" ||
                              name.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Fields Cant be Empty")));
                          } else {
                            // signUpService.createAccount(
                            //     context: context,
                            //     email: email.text,
                            //     password: password.text,
                            //     name: name.text,
                            //     mobile: mobile.text);

                            sendOTPService.sendOTP(
                              context: context,
                              mobileNumber: mobile.text,
                              email: email.text,
                              password: password.text,
                            );
                          }
                        },
                        child: const ButtonWidget(
                          label: "Register",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TextWidget(
                        label: "Already have an account? ",
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
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const TextWidget(
                          label: "Login here",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
