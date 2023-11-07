import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'campaigns_state.dart';

class CampaignsCubit extends Cubit<CampaignsState> {
  CampaignsCubit() : super(CampaignsInitial());
}
