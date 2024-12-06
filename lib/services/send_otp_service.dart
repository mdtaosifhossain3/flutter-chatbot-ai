import 'dart:io';

import 'package:chatgpt_clone/screens/authScreen/otp_verify_view.dart';
import 'package:chatgpt_clone/screens/chatScreen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SendOTPService {
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

  Future<void> sendOTP({
    context,
    mobileNumber,
    email,
    password,
    name,
  }) async {
    String mobile = mobileNumber.trim();
    // if (mobile.isEmpty) {
    //   // Show a message if the mobile number is empty
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please enter a mobile number')),
    //   );
    //   return;
    // }

    // if (!_isValidMobile(mobile)) {
    //   // Show error message if the mobile number is invalid
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //         content:
    //             Text('Invalid mobile number. Please enter a valid number')),
    //   );
    //   return;
    // }
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
    // Send HTTP POST request to the API
    try {
      // final response = await http.post(
      //   Uri.parse('${dotenv.env["API_LINK"]}/OTP_request.php'),
      //   body: data,
      // );
      //
      // var body = response.body;
      // final statusCode = _extractValue(body, 'Status code').trim();
      // final result = statusCode.replaceAll(":", "").trim();
      //
      // if (result == "E1351") {
      //   Navigator.pop(context);
      //
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('The Number already Exsist!')),
      //   );
      //   return;
      // } else if (result != "S1000") {
      //   Navigator.pop(context);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //         content: Text('Please Enter a valid Robi/Airtel Number')),
      //   );
      //   return;
      // }
      //

      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user != null) {
        //Store The Data
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString("id", cred.user!.uid);

        //Update DisplayName
        await FirebaseAuth.instance.currentUser!.updateDisplayName(name);

        // Create an user Collection
        await FirebaseFirestore.instance
            .collection("users")
            .doc(cred.user!.uid)
            .set({"name": name, "email": email});
        // sharedPreferences.setString("NUM", result);

        // if (result == "S1000") {
        //   final ref = _extractValue(body, 'Reference number');
        //   final refResult = ref.replaceAll(":", "").trim();
        //   sharedPreferences.setString("REFERENCE_NUMBER", refResult);
        //   sharedPreferences.setString("NUM", result);
        //   //OTP Verification Page
        //   Navigator.push(context, MaterialPageRoute(builder: (_) {
        //     return OtpVerificationView();
        //   }));
        //
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('OTP sent successfully')),
        //   );
        //   return;
        // }
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ChatScreen();
        }));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Welcome to Chatbot Ai')),
        );

        return;
      }

      return;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'weak-password') {
        showAlert(
            title: 'Error',
            text: "The password provided is too weak.",
            context: context);
        return;
      } else if (e.code == 'email-already-in-use') {
        showAlert(
            title: 'Error',
            text: "The account already exists for that email.",
            context: context);

        return;
      } else {
        showAlert(
            title: 'Error', text: "Account Creation Failed", context: context);
        // ignore: avoid_print
        return print(e.message);
      }
    } on SocketException catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Issue ${e.toString()}')),
      );
    } catch (e) {
      Navigator.pop(context);
      // Handle error in case of network issues
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  showAlert({required String title, required String text, required context}) {
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
