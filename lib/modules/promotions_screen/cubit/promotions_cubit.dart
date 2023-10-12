import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'promotions_state.dart';

class PromotionsCubit extends Cubit<PromotionsState> {
  PromotionsCubit() : super(PromotionsInitial());

  static PromotionsCubit get(context) => BlocProvider.of(context);

  String liveNowLayout = 'all';

  Future<void> changeCurrentView(String val) async {
    liveNowLayout = val;
    emit(CurrentViewChanged());
  }
}
