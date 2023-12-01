import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/chat_gpt/widgets/rounded_expantion.dart';

import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'chat_gpt_screen.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newLightGreyColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(children: [
            SvgPicture.asset(
              'assets/svg/mena8.svg',
              height: Responsive.isMobile(context) ? 22.w : 12.w,
            ),
            LottieBuilder.asset(
              "assets/json/chatbot_anim.json",
              width: 250.w,
              height: 250.h,
            ),
            Text(
              getTranslatedStrings(context).chat_gpt_intro,
              style: mainStyle(context, 12, isBold: true),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: RoundedExpansionPanel(
                  items: {
                    getTranslatedStrings(context).patientEducation:
                        getTranslatedStrings(context).patientEducationPhrase,
                    getTranslatedStrings(context)
                            .medicalAssistanceAndDecisionSupport:
                        getTranslatedStrings(context)
                            .medicalAssistanceAndDecisionSupportPhrase,
                    getTranslatedStrings(context).remoteMonitoringAndSupport:
                        getTranslatedStrings(context)
                            .remoteMonitoringAndSupportPhrase,
                    getTranslatedStrings(context).enhancingHealthcareEfficiency:
                        getTranslatedStrings(context)
                            .enhancingHealthcareEfficiencyPhrase,
                    getTranslatedStrings(context).continuingMedicalEducation:
                        getTranslatedStrings(context)
                            .continuingMedicalEducationPhase,
                    getTranslatedStrings(context).multilingualSupport:
                        getTranslatedStrings(context).multilingualSupportPhase,
                    getTranslatedStrings(context).disclaimer:
                        getTranslatedStrings(context).disclaimerPhase,
                  },
                ),
              ),
            ),
            DefaultButton(
                text: getTranslatedStrings(context).chatWithAI,
                onClick: () {
                  navigateToWithoutNavBar(
                      context, ChatGPTScreen(), 'routeName');
                }),
          ]),
        ),
      ),
    );
  }
}
