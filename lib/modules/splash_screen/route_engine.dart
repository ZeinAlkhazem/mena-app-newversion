import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/auth_screens/sign_in_screen.dart';

import '../../core/functions/main_funcs.dart';
import '../complete_info_subscribe/complete_info_subscribe.dart';
import '../initial_onboarding/initial_choose_lang.dart';
import '../main_layout/main_layout.dart';

class RouteEngine extends StatelessWidget {
  const RouteEngine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context)..checkSetUpData();

    /// login status, subscribe status...
    logg('_RouteEngineState build');
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (mainCubit.setUpChecked) {
            logg('setUpChecked');
            if (getCachedFirstApplicationRun() == null) {
              ///Todo: change this to ==, != is for testing purpose
              logg('mainCubit.firstRun null');
              return const InitialChooseLang();
            }
            ///Todo: decide about default return
            else {
              if (mainCubit.isUserLoggedIn) {
                ///Todo: remove !, ! is for testing purpose
                  ///Todo: remove !, ! is for testing purpose
                  return const MainLayout();
                                // return tablet;
              } else {
                ///user not logged in
                return const SignInScreen();
              }
              // logg('Something Went wrong');
              // return const Center(child: Text(
              //     'Something Went wrong'
              // ));
            }
          } else {
            return const Center(child: SizedBox());
          }
        },
      ),
    );
  }
}


