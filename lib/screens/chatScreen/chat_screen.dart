import 'package:chatgpt_clone/providers/theme_provider.dart';
import 'package:chatgpt_clone/screens/chatScreen/input_bar.dart';
import 'package:chatgpt_clone/screens/chatScreen/popover_options.dart';
import 'package:chatgpt_clone/screens/chatScreen/spinner.dart';
import 'package:chatgpt_clone/services/assets_manager.dart';
import 'package:chatgpt_clone/widgets/card_widget.dart';
import 'package:chatgpt_clone/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreen> {
  late FocusNode focusNodeController;
  final ScrollController _scrollController = ScrollController();
  final id = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    focusNodeController = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNodeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
            elevation: 3.00,
            //-----------------------leading-----------------------
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.botUrl),
            ),
            //-----------------------title-----------------------
            title: const TextWidget(
              label: "ChatBot",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
            //-----------------------Actions-----------------------
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                      onPressed: () async {
                        await showPopover(
                            context: context,
                            bodyBuilder: (context) => PopoverOptions(
                                  themeProvider: themeProvider,
                                ),
                            width: 200,
                            height: 195,
                            backgroundColor:
                                themeProvider.themeMode == ThemeMode.light
                                    ? Colors.white
                                    : Colors.black,
                            direction: PopoverDirection.bottom);
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ));
                },
              )
            ]),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // //-----------------------Chats-----------------------

              Flexible(
                  flex: 2,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(id)
                          .collection('prompt')
                          .orderBy("date")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: SpinKitThreeInOut(
                            color: themeProvider.themeMode == ThemeMode.light
                                ? Colors.black
                                : Colors.white,
                          ));
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text("Let's Start Chatting With AI"));
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollToBottom();
                          });
                          return ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final prompt = snapshot.data!.docs[index];

                                return CardWidget(
                                    msg: prompt["msg"], idx: prompt["idx"]);
                              });
                        }
                      })),

              //-----------------------sizebox-----------------------
              const SizedBox(
                height: 10,
              ),
              //-----------------------Spinner-----------------------
              const Spinner(),

              //-----------------------Input-----------------------
              InputBar(
                focusNodeController: focusNodeController,
              ),
              //-----------------------sizebox-----------------------
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}
