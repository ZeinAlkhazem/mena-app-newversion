import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/network_constants.dart';
import '../../../../models/api_model/my_messages_model.dart';
import 'new_message_state.dart';

class NewMessageCubit extends Cubit<NewMessageState> {
  NewMessageCubit() : super(NewMessageInitial());

  static NewMessageCubit get(context) => BlocProvider.of(context);


  MyMessagesModel? primaryMessagesModel;

  Future<void> fetchPrimaryMessages() async {
    log("==== fetch Primary message ====");
    emit(GettingPrimaryMessagesData());
    ////
    await MainDioHelper.getData(
      url: getPrimaryMessageEnd,
      query: {
        'limit': '15',
        'offset': '1',
      },
    ).then((value) {
      logg('My Messages fetched...');
      logg(value.toString());
      primaryMessagesModel = MyMessagesModel.fromJson(value.data);
      // chatMessagesModel=ChatMessagesModel.fromJson(value.data);
      // logg(value.toString());
      emit(SuccessGettingPrimaryMessagesDataState());
    }).catchError((error) {
      logg('an error occurred === fetch my message');
      logg(error.toString());
      emit(ErrorGettingPrimaryMessagesDataState());
    });
  }

}