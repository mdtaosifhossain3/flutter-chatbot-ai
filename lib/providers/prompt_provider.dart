import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PromptProvider with ChangeNotifier {
  final _controller = TextEditingController();

  bool isLoading = false;
  get controller => _controller;

  // Input Data
  void onSubmit(val) {
    _controller.text = val;
  }

  //This function helps to add data on Firebase.
  void addPrompt(prompt) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getString("id");

    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .collection("prompt")
          .add(prompt)
          .then((val) {
        if (kDebugMode) {
          print("Data Added");
        }
      }).catchError((e, trace) {
        if (kDebugMode) {
          print("Error: $e");
        }
        if (kDebugMode) {
          print(trace);
        }
      });

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //This function helps to sent prompt data on Firebase.
  Future sendPrompt() async {
    isLoading = true;
    try {
      var response = await http.post(
          Uri.parse(
            "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=${dotenv.env["API_KEY"]}",
          ),
          headers: {
            "Content-Type": "application/json",
            "x-goog-api-key": "${dotenv.env["API_KEY"]}"
          },
          body: jsonEncode({
            "contents": [
              {
                "role": "user",
                "parts": [
                  {"text": _controller.text}
                ]
              }
            ]
          }));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var prompt = {
          "idx": 1,
          "msg": data["candidates"][0]["content"]["parts"][0]["text"],
          "date": DateTime.now()
        };
        isLoading = false;
        addPrompt(prompt);

        _controller.clear();
        return;
      }

      return;
    } on SocketException catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print(e.toString());
      }
      return;
    } catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
