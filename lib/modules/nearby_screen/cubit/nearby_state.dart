part of 'nearby_cubit.dart';

@immutable
abstract class NearbyState {}

class NearbyInitial extends NearbyState {}
class MarkersReadyState extends NearbyState {

}
class CarouselControllerScrollTo extends NearbyState {
  final int id;
  CarouselControllerScrollTo(this.id);
}
