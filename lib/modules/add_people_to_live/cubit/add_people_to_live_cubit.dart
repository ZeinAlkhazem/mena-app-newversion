import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'add_people_to_live_state.dart';

class AddPeopleToLiveCubit extends Cubit<AddPeopleToLiveState> {
  AddPeopleToLiveCubit() : super(AddPeopleToLiveInitial());

  static AddPeopleToLiveCubit get(context) => BlocProvider.of(context);
}
