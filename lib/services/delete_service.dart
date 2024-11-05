import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> deleteSubcollection(context) async {
  Navigator.pop(context);
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getString("id");
    CollectionReference subcollectionRef = FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("prompt");

    // Get all documents in the subcollection
    QuerySnapshot snapshot = await subcollectionRef.get();

    // Loop through each document and delete it
    for (QueryDocumentSnapshot document in snapshot.docs) {
      await document.reference.delete();
    }
    if (kDebugMode) {
      print('Subcollection deleted successfully');
    }

    return "Success";
  } on SocketException catch (e) {
    Navigator.pop(context);
    showAlert(title: 'Time Out', text: e.message.toString(), context: context);
    return 'Error';
  } catch (e) {
    Navigator.pop(context);
    showAlert(
        title: 'Something Went Wrong', text: e.toString(), context: context);
    if (kDebugMode) {
      print('Failed to delete subcollection: $e');
    }
    return 'Error';
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
