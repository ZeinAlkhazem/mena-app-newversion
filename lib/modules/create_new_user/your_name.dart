import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/models/api_model/register_model.dart';
import 'package:mena/models/my_models/create_user_model.dart';

import '../../core/constants/validators.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';
import '../auth_screens/pick_user_type_layout.dart';
import '../auth_screens/sign_in_screen.dart';

class YourName extends StatefulWidget {
  final CreateUserModel userInfo;

  const YourName({super.key, required this.userInfo});

  @override
  State<YourName> createState() => _YourNameState();
}

class _YourNameState extends State<YourName> {
  final fullNameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  CreateUserModel? newUserModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/back.png', // Replace with your image path
            scale: 3,
            alignment: Alignment.centerRight, // Adjust the height as needed
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25, top: 5, right: 30),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightBox(15.h),
                      Text(
                        'What\'s Your Name',
                        style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'PNfont',
                          color: Color(0xff303840),
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      heightBox(25.h),
                      heightBox(30.h),
                      DefaultInputField(
                        fillColor: Color(0xffF2F2F2),
                        focusedBorderColor: Color(0xff0077FF),
                        unFocusedBorderColor: Color(0xffC9CBCD),
                        label: 'Full Name',
                        controller: fullNameController,
                        validate: emptyValueValidate,
                        labelTextStyle: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'PNfont',
                            color: Color(0xff999B9D)),
                      ),
                      heightBox(15.h),
                      DefaultButton(
                          text: "Next",
                          onClick: () {
                            if (formKey.currentState!.validate()) {
                              newUserModel = widget.userInfo;
                              newUserModel!.fullName = fullNameController.text;
                              navigateTo(
                                  context,
                                  YourPassword(
                                    userInfo: newUserModel!,
                                  ));
                            }
                          }),
                      heightBox(440.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: TextButton(
                          onPressed: () {
                            navigateTo(context, SignInScreen());
                          },
                          child: Text(
                            textAlign: TextAlign.start,
                            "Already have an account?",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PNfont',
                                color: Color(0xff0077FF),
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
