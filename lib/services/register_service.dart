import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatgpt_clone/screens/chatScreen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterService {
  createAccount({context, email, password, name}) async {
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

        //Navigate to ChatScreen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return const ChatScreen();
        }));

        return "Success";
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
      showAlert(
          title: 'Time Out', text: e.message.toString(), context: context);
    } catch (e) {
      Navigator.pop(context);
      showAlert(
          title: 'Something Went Wrong', text: e.toString(), context: context);
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
