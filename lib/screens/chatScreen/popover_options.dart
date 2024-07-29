import 'package:chatgpt_clone/providers/theme_provider.dart';
import 'package:chatgpt_clone/screens/welcomeScreen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PopoverOptions extends StatefulWidget {
  final ThemeProvider? themeProvider;
  const PopoverOptions({super.key, this.themeProvider});

  @override
  State<PopoverOptions> createState() => _PopoverOptionsState();
}

class _PopoverOptionsState extends State<PopoverOptions> {
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
