import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/modules/tools/cubit/tools_state.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';

class ToolsCubit extends Cubit<ToolsState> {
  ToolsCubit() : super(ToolsInitial());

  static ToolsCubit get(context) => BlocProvider.of(context);

  Future<void> getEServices({String? platformId,String? text}) async {
    // feedsModel = null;
    if (state is! GettingEServicesState) {
      emit(GettingEServicesState());
      ////
      Map<String, String?> toSendData = {
        'limit': '15',
        'offset': '1',
      };
      if (platformId != null) {
        toSendData['platform_id'] = '${platformId}';
      }
      if (text != null) {
        toSendData['text'] = '${text}';
      }
      logg('to send data: ${toSendData}');
      await MainDioHelper.getData(
        url: getEServicesInfoEnd,
        query: toSendData,
      ).then((value) {
        logg('EServices items fetched...');
        logg(value.toString());
        logg('EServices items filled');
        emit(SuccessGettingEServicesState());
      }).catchError((error,stack) {
        logg('an error occurred');
        logg(error.toString());
        logg(stack.toString());
        emit(ErrorGettingEServicesState());
      });
    }
  }
}
