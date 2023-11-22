// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'market_cubit.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object> get props => [];
}

class MarketInitial extends MarketState {}

class MarketChangeCaroselIndexState extends MarketState {
  final int index;
  MarketChangeCaroselIndexState({
    required this.index,
  });
    @override
  List<Object> get props => [index];
}
