import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mena/core/network/dio_helper.dart';
import 'package:mena/core/network/network_constants.dart';

import '../models/message_model.dart';
import 'chat_gpt_state.dart';

class ChatGPTCubit extends Cubit<ChatGPTState> {
  List<MessageModel> chatList = [];
  String? chatKey;

  List<MessageModel> get getChatList {
    return chatList;
  }

  ChatGPTCubit() : super(ChatGPTInitial()) {
    getChatKey();
  }

  static ChatGPTCubit get(context) => BlocProvider.of(context);

  Future<void> sendMessageAndGetAnswers(
      {required List<MessageModel> msg, required String chosenModelId}) async {
    List<MessageModel> temp = await sendMessage(
      message: msg,
      modelId: chosenModelId,
    );
    chatList.addAll(temp);
    emit(DataLoadedSuccessState());
  }

  Future<void> getChatKey() async {
    await MainDioHelper.getData(url: getKey, query: {}).then((value) {
      chatKey = value.data["data"]["key"];
    });
  }

  Future<List<MessageModel>> sendMessage(
      {required List<MessageModel> message, required String modelId}) async {
    List<MessageModel> chatList = [];
    if (chatKey == null) {
      await getChatKey();
    }
    await MainDioHelper.postData(
            url: "https://api.openai.com/v1/chat/completions",
            data: {
              "model": modelId,
              "messages": message,
              "temperature": 0.7
              // "max_tokens": 300,
            },
            tokenn: chatKey)
        .then((value) {
      if (value.data['error'] != null) {
        throw HttpException(value.data['error']["message"]);
      }
      if (value.data["choices"].length > 0) {
        // log("value.data[choices]text ${value.data["choices"][0]["text"]}");
        chatList = List.generate(
          value.data["choices"].length,
          (index) => MessageModel(
            content: value.data["choices"][index]["message"]["content"],
            role: value.data["choices"][index]["message"]["role"],
          ),
        );
      }
    });
    return chatList;
  }
}
