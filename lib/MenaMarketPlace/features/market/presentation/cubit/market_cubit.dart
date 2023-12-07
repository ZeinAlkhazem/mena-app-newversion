import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  int i = 0;
  String viewType = 'video';
  MarketCubit() : super(MarketInitial());

  void changeCaroselPosition(int pageIndex) {
    i = pageIndex;
    emit(MarketChangeCaroselIndexState(index: pageIndex));
  }

  void changeProductView(String type) {
    viewType = type;
    emit(MarketChangeProductViewState(type: type));
  }
}
