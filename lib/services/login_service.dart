import 'dart:io';
import 'package:chatgpt_clone/screens/chatScreen/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../screens/authScreen/otp_verify_view.dart';

class LoginService {
  // Function to validate if the input is a valid mobile number
  bool _isValidMobile(String mobile) {
    // Check if the input contains only digits (0-9) and is at least 11 digits long
    final regex = RegExp(r'^\d{11,15}$');
    return regex.hasMatch(mobile);
  }

  // Helper function to extract values
  String _extractValue(String body, String key) {
    final startIndex = body.indexOf(key);
    if (startIndex != -1) {
      final substring = body.substring(startIndex);
      final endIndex = substring.indexOf('\n');
      if (endIndex != -1) {
        return substring.substring(key.length, endIndex).trim();
      }
      return substring.substring(key.length).trim();
    }
    return '';
  }

  login({context, email, password, mobileNumber}) async {
    String mobile = mobileNumber.trim();
    if (mobile.isEmpty) {
      // Show a message if the mobile number is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a mobile number')),
      );
      return;
    }

    if (!_isValidMobile(mobile)) {
      // Show error message if the mobile number is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Invalid mobile number. Please enter a valid number')),
      );
      return;
    }
    // Prepare the request data
    Map<String, String> data = {
      'user_mobile': mobile,
    };
    //Loading Effect
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SpinKitThreeInOut(
                    color: Colors.black,
                  ),
                ]),
          );
        });
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env["API_LINK"]}/request_otp_chtai.php'),
        body: data,
      );

      var body = response.body;
      final statusCode = _extractValue(body, 'Status code').trim();
      final result = statusCode.replaceAll(":", "").trim();

      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user != null) {
        //Store the uid
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString("id", cred.user!.uid);

        if (result == "S1000") {
          final ref = _extractValue(body, 'Reference number');
          final refResult = ref.replaceAll(":", "").trim();
          sharedPreferences.setString("REFERENCE_NUMBER", refResult);

          //OTP Verification Page
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return OtpVerificationView();
          }));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP sent successfully')),
          );
          return;
        } else if (result == "E1351") {
        //   //OTP Verification Page
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return const ChatScreen();
        }));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Welcome Back!')),
          );
          return;
        }else if (result == "E1600") {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(' Sorry, the CHTAI application is temporarily  unavailable. Please try again later')),
          );
          return;
        }
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong')),
        );
        return;
      }
      Navigator.pop(context);
      return;
    } on FirebaseAuthException catch (e) {


      if (e.code == 'user-not-found') {
        Navigator.pop(context);
        showAlert(
            title: 'Error',
            text: "No user found for that email.",
            context: context);
        return;
      } else if (e.code == 'wrong-password') {
        Navigator.pop(context);
        showAlert(
            title: 'Error',
            text: "Wrong password provided for that user.",
            context: context);

        return;
      } else {
        Navigator.pop(context);
        showAlert(title: 'Error', text: "Login Failed", context: context);
        // ignore: avoid_print
        return print(e.message);
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      showAlert(
          title: 'Time Out', text: "Network issue", context: context);
    } catch (e) {
      Navigator.pop(context);
      showAlert(
          title: 'Something Went Wrong', text: e.toString(), context: context);
    }
  }

  showAlert({required String title, required String text, context}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }
}
