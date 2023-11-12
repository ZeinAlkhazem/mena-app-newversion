import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'actions_state.dart';

class ActionsCubit extends Cubit<ActionsState> {
  ActionsCubit() : super(ActionsInitial());
}
