import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  int i = 0;
  MarketCubit() : super(MarketInitial());

  changeCaroselPosition(int pageIndex) {
    i = pageIndex;
    emit(MarketChangeCaroselIndexState(index: pageIndex));
  }
}
