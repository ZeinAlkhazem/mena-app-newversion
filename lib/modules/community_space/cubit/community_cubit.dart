import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';


part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit() : super(CommunityInitial());

  static CommunityCubit get(context) => BlocProvider.of(context);

  String currentLayout='live';

  Future<void> changeCurrentView(String val) async {
    currentLayout=val;
    emit(CurrentViewChanged());
  }


}
