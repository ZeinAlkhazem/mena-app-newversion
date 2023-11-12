import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit() : super(MarketInitial());
}
