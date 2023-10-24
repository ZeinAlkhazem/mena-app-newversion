
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/models/api_model/online_users.dart';
import 'package:meta/meta.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';
import '../../../models/api_model/chat_messages_model.dart';
import '../../../models/api_model/my_messages_model.dart';
import '../../../models/api_model/users_chat_model.dart';

part 'messenger_state.dart';

class MessengerCubit extends Cubit<MessengerState> {
  MessengerCubit() : super(MessengerInitial());

  static MessengerCubit get(context) => BlocProvider.of(context);

  ChatMessagesModel? chatMessagesModel;
  OnlineUsersModel? onlineUsersModel;

  UsersToChatModel? usersChatModel;
  MyMessagesModel? myMessagesModel;
  XFile? recorderVoice;
  List<XFile> attachedFiles = [];

  int selectedMessengerNewMessageLayout = 0;

  // bool expandChatTools=false;
  // bool isRecording=false;
  void updateAttachedFile(XFile? file) {
    // resetAttachedFile();
    if (file != null) {
      attachedFiles.add(file);
    }
    logg('attached files: ${attachedFiles}');

    emit(AttachedFilesUpdated());
  }

  void updateVoiceFile(XFile? file) {
    // resetAttachedFile();

    recorderVoice = file;

    logg('attached files: ${attachedFiles}');

    emit(VoiceFilesUpdated());
  }

  void resetAttachedFile() {
    attachedFiles = [];
    recorderVoice = null;
    emit(AttachedFilesUpdated());
  }

  void removeAttachedFile(int index) {
    attachedFiles.removeAt(index);
    emit(AttachedFilesUpdated());
  }

  void toggleExpandChatTools(bool? newVal) {
    if (newVal == null) {
      // expandChatTools=!expandChatTools;
    } else {
      // expandChatTools = newVal;
    }
    emit(ExpandChangedState());
  }

  void toggleRecording(bool? newVal) {
    // if(newVal==null){
    //   isRecording=!isRecording;
    // }
    //
    // else{
    //   isRecording = newVal;
    // }
    emit(ToggleRecordingState());
  }

  Future<void> deleteChat({
    required String chatId,
    // File? attachedFile,
  }) async {
    emit(DeletingMsgState());
    await MainDioHelper.postData(url: deleteChatEnd, data: {'chat_id': chatId}).then((value) {
      logg('Successfully DeletingMsgState');
      logg(value.toString());
      emit(SuccessDeletingMsgState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorDeletingMsgState());
    });
  }

  Future<void> markAsRead({
    required String chatId,
  }) async {
    emit(DeletingMsgState());
    await MainDioHelper.postData(url: markAsReadChatEnd, data: {'chat_id': chatId}).then((value) {
      logg('Successfully DeletingMsgState');
      logg(value.toString());
      emit(SuccessDeletingMsgState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorDeletingMsgState());
    });
  }

  Future<void> reportToMENA({
    required String chatId,
  }) async {
    emit(DeletingMsgState());
    await MainDioHelper.postData(url: reportToMENAChatEnd, data: {'chat_id': chatId}).then((value) {
      logg('Successfully DeletingMsgState');
      logg(value.toString());
      emit(SuccessDeletingMsgState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorDeletingMsgState());
    });
  }

  Future<void> blockUserChat({
    required String chatId,
  }) async {
    emit(DeletingMsgState());
    await MainDioHelper.postData(url: blockUserChatEnd, data: {'chat_id': chatId}).then((value) {
      logg('Successfully DeletingMsgState');
      logg(value.toString());
      emit(SuccessDeletingMsgState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorDeletingMsgState());
    });
  }

  Future<void> clearChat({
    required String chatId,
  }) async {
    emit(DeletingMsgState());
    await MainDioHelper.postData(url: clearChatEnd, data: {'chat_id': chatId}).then((value) {
      logg('Successfully DeletingMsgState');
      logg(value.toString());
      emit(SuccessDeletingMsgState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorDeletingMsgState());
    });
  }

  Future<void> sendMessage({
    required String toId,
    required String toType,
    required dynamic msg,
  }) async {
    String responseMsg = '';
    emit(SendingMsgState());
    FormData formData;

    List<MultipartFile> files = [];

    if (recorderVoice != null) {
      MultipartFile file = await MultipartFile.fromFile(
        recorderVoice!.path,
        filename: recorderVoice!.path.split('/').last,
      );
      files.add(file);
    } else if (attachedFiles.isNotEmpty) {
      logg('files not empty');
      for (var element in attachedFiles) {
        logg('path: ${element.name}\n');
        MultipartFile file = await MultipartFile.fromFile(
          element.path,
          filename: element.path.split('/').last,
        );
        files.add(file);
      }
      // attachedFiles.forEach((element) {
      //   logg('adding: ${element.path.split('/').last}');
      // files.add(await MultipartFile.fromFile(
      //     element.path,
      //     filename: element.path.split('/').last,
      //   ).then((value) {
      //
      //     logg('added: ${element.path.split('/').last}');
      //     return value;
      //   }));
      // });
    }

    ///
    Map<String, dynamic> toSendData = {
      'to_id': toId,
      'to_type': toType,
      'message': msg,
      'files[]': files,
    };
    ////
    logg('to send data: ' + toSendData.toString());
    formData = FormData.fromMap(toSendData);
    await MainDioHelper.postDataWithFormData(url: sendMsgEnd, data: formData).then((value) {
      logg('Msg sent');
      logg(value.toString());
      responseMsg = 'Successfully sent';
      emit(SuccessSendingMsgState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorSendingMsgState());
      responseMsg = 'an error occurred';
    });
  }

  void resetChatModel() {
    chatMessagesModel = null;
    emit(ChatResetState());
  }

  /// fetch messages
  Future<void> fetchChatMessagesByIdType({
    required String toIdProviderId,
    required String toTypeRoleName,
  }) async {
    emit(GettingMessagesData());
    ////
    await MainDioHelper.getData(
      url: getChatMessagesEnd,
      query: {
        'to_id': toIdProviderId,
        'to_type': toTypeRoleName,
        'limit': '15',
        'offset': '1',
      },
    ).then((value) {
      logg('Messages fetched...gh');
      logg(value.toString());
      chatMessagesModel = ChatMessagesModel.fromJson(value.data);
      emit(SuccessGettingMessagesDataState());
    }).catchError((error,stack) {
      logg('an error occurred');
      logg(error.toString());
      logg(stack.toString());
      emit(ErrorGettingMessagesDataState());
    });
  }

  /// fetch messages by chat id
  Future<void> fetchChatMessagesByChatId({
    required String chatId,
  }) async {
    emit(GettingMessagesData());
    ////
    await MainDioHelper.getData(
      url: getChatMessagesEnd,
      query: {
        'chat_id': chatId,
        'limit': '15',
        'offset': '1',
      },
    ).then((value) {
      logg('Messages fetched...');
      logg(value.toString());
      chatMessagesModel = ChatMessagesModel.fromJson(value.data);

      emit(SuccessGettingMessagesDataState());
    }).catchError((error,s) {
      logg('an error occurred');
      logg(error.toString());
      logg(s.toString());
      emit(ErrorGettingMessagesDataState());
    });
  }

  /// get users
  Future<void> getUsers({
    required String usersType,
    String? searchQuery,
  }) async {
    emit(GettingUsersData());
    ////
    log("# user messenger  url:$getChatUsersEnd/$usersType?search=${searchQuery ?? ''} ");
    await MainDioHelper.getData(
      url: '$getChatUsersEnd/$usersType?search=${searchQuery ?? ''}',
      query: {
        // 'chat_id': chatId,
        'limit': '150',
        // 'offset': '1',
      },
    ).then((value) {
      logg('users fetched...');
      logg('# user all : $value');
      usersChatModel = UsersToChatModel.fromJson(value.data);
      logg(value.toString());
      emit(SuccessGettingUsersDataState());
    }).catchError((error,stack) {
      logg('an error occurred');
      logg(error.toString());
      logg(stack.toString());
      emit(ErrorGettingUsersDataState());
    });
  }

  /// fetch My messages
  Future<void> fetchMyMessages() async {
    emit(GettingMyMessagesData());
    ////
    await MainDioHelper.getData(
      url: getMyMessagesEnd,
      query: {
        'limit': '15',
        'offset': '1',
      },
    ).then((value) {
      logg('My Messages fetched...');
      logg(value.toString());
      myMessagesModel = MyMessagesModel.fromJson(value.data);
      // chatMessagesModel=ChatMessagesModel.fromJson(value.data);
      // logg(value.toString());
      emit(SuccessGettingMyMessagesDataState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorGettingMessagesDataState());
    });
  }

  void changeMessengerNewMessageLayout(int index) {
    selectedMessengerNewMessageLayout = index;
    emit(ChangedMessengerNewMessageLayout());
  }

  /// fetch online users
  Future<void> fetchOnlineUsers() async {
    emit(GettingMyMessagesData());
    ////
    await MainDioHelper.getData(
      url: getOnlineUsersEnd,
      query: {
        // 'limit': '15',
        // 'offset': '1',
      },
    ).then((value) {
      logg('online users fetched...');
      // myMessagesModel = MyMessagesModel.fromJson(value.data);
      logg(value.toString());
      onlineUsersModel = OnlineUsersModel.fromJson(value.data);
      emit(SuccessGettingMyMessagesDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.toString());
      logg(stack.toString());
      emit(ErrorGettingMessagesDataState());
    });
  }
}
