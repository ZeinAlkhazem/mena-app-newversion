import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/chat_gpt/cubit/chat_gpt_cubit.dart';
import 'package:mena/modules/chat_gpt/widgets/chat_widget.dart';

import '../../core/functions/main_funcs.dart';
import 'cubit/chat_gpt_state.dart';
import 'models/message_model.dart';
import 'widgets/text_widget.dart';

class ChatGPTScreen extends StatefulWidget {
  const ChatGPTScreen({super.key});

  @override
  State<ChatGPTScreen> createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatGPTCubit(),
      child: BlocBuilder<ChatGPTCubit, ChatGPTState>(
        builder: (context, state) {
          var chatProvider = ChatGPTCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(56.0.h),
              child: DefaultBackTitleAppBar(
                title: getTranslatedStrings(context).menaMedicalVirtualAssistant,
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                        controller: _listScrollController,
                        itemCount: chatProvider.getChatList.length,
                        //chatList.length,
                        itemBuilder: (context, index) {
                          return ChatWidget(
                            msg: chatProvider.getChatList[index].content,
                            // chatList[index].msg,
                            role: chatProvider.getChatList[index].role,
                            onFinished: () {
                              scrollListToEND();
                            }, //chatList[index].chatIndex,
                          );
                        }),
                  ),
                  if (_isTyping) ...[
                    const SpinKitThreeBounce(
                      color: Colors.black,
                      size: 18,
                    ),
                  ],
                  const SizedBox(
                    height: 15,
                  ),
                  Material(
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              color: Colors.grey.shade100,
                              child: Center(
                                child: TextFormField(
                                  focusNode: focusNode,
                                  style: const TextStyle(color: Colors.black),
                                  controller: textEditingController,
                                  onFieldSubmitted: (value) async {
                                    await sendMessageFCT(chatProvider);
                                  },
                                  decoration: InputDecoration.collapsed(
                                      hintText: getTranslatedStrings(context)
                                          .askAnyMedicalQuestionsYouHave,
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await sendMessageFCT(chatProvider);
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.grey,
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> sendMessageFCT(ChatGPTCubit chatProvider) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label:
                getTranslatedStrings(context).youCantSendMultipleMessagesAtTime,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: getTranslatedStrings(context).pleaseTypeMessage,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg =
          "Please Provide answers to only medical related questions don't answer anything else. ${textEditingController.text}";
      setState(() {
        _isTyping = true;
        chatProvider.chatList.add(MessageModel(content: msg, role: "user"));
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: chatProvider.chatList, chosenModelId: "gpt-3.5-turbo");
      setState(() {});
    } catch (error) {
      logg("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
