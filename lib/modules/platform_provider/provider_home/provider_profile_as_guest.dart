import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/modules/platform_provider/provider_home/provider_profile_Sections.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/home_section_model.dart';

class ProviderProfileAsAGuest extends StatelessWidget {
  const ProviderProfileAsAGuest({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultSearchMessengerAppBar(
        context,
        title: 'Profile',
      ),
      body: Container(
        color: newLightGreyColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AboutSection(
                about: user.moreData!.about,
              ),
              heightBox(10.h),
              EducationSection(
                educations: user.moreData!.educations!.isEmpty ? null : user.moreData!.educations,
              ),
              heightBox(10.h),
              ExperienceSection(
                experiences: user.moreData!.experiences!.isEmpty ? null : user.moreData!.experiences,
              ),
              heightBox(10.h),
              PublicationSection(
                publications: user.moreData!.publications!.isEmpty ? null : user.moreData!.publications,
              ),
              heightBox(10.h),
              CertificationsSection(
                certifications: user.moreData!.certifications!.isEmpty ? null : user.moreData!.certifications,
              ),
              heightBox(10.h),
              MembershipSection(
                memberships: user.moreData!.memberships!.isEmpty ? null : user.moreData!.memberships,
              ),
              heightBox(10.h),
              RewardsSection(
                rewards: user.moreData!.rewards!.isEmpty ? null : user.moreData!.rewards,
              ),
              heightBox(15.h),
            ],
          ),
        ),
      ),
    );
  }
}
