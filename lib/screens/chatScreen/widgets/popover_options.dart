import 'package:chatgpt_clone/constants/constants.dart';
import 'package:chatgpt_clone/providers/theme_provider.dart';
import 'package:chatgpt_clone/screens/welcomeScreen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/delete_service.dart';

class PopoverOptions extends StatefulWidget {
  final ThemeProvider? themeProvider;
  const PopoverOptions({super.key, this.themeProvider});

  @override
  State<PopoverOptions> createState() => _PopoverOptionsState();
}

class _PopoverOptionsState extends State<PopoverOptions> {
  // Function to send a message to the SMS app
  Future<void> sendStopMessage() async {
    const phoneNumber = '21213';
    const message = 'STOP chtai';

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message}, // pre-fill message
    );

    // Check if the URL can be launched (i.e., if SMS is available)
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri); // Opens SMS app with pre-filled message
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch SMS')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              widget.themeProvider?.setTheme(ThemeMode.dark);
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.dark_mode_sharp),
                SizedBox(
                  width: 8,
                ),
                Text("Dark mode")
              ],
            )),
        TextButton(
            onPressed: () {
              widget.themeProvider?.setTheme(ThemeMode.light);
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.light_mode_sharp),
                SizedBox(
                  width: 8,
                ),
                Text("Ligth mode")
              ],
            )),
        TextButton(
            onPressed: () async {
              await deleteSubcollection(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  color: redColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Delete Chats",
                  style: TextStyle(color: redColor),
                )
              ],
            )),
        // TextButton(
        //     onPressed: () async {
        //       await sendStopMessage();
        //       await Future.delayed(const Duration(seconds: 6));
        //       Navigator.push(context, MaterialPageRoute(builder: (_) {
        //         return const WelcomePage();
        //       }));
        //     },
        //     child: Row(
        //       children: [
        //         Icon(
        //           Icons.delete,
        //           color: redColor,
        //         ),
        //         const SizedBox(
        //           width: 8,
        //         ),
        //         const Text(
        //           "Unsubscribed",
        //           style: TextStyle(color: Colors.red),
        //         ),
        //       ],
        //     )),
        TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const WelcomePage();
              }));
            },
            child: const Row(
              children: [
                Icon(Icons.logout),
                SizedBox(
                  width: 8,
                ),
                Text("Log Out")
              ],
            )),
      ],
    );
  }
}
