import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/modules/add_people_to_live/widget/add_people_card.dart';

import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../create_live/widget/live_input_field.dart';

class AddPeopleToLiveScreenPage extends StatefulWidget {
  const AddPeopleToLiveScreenPage({super.key});

  @override
  State<AddPeopleToLiveScreenPage> createState() =>
      _AddPeopleToLiveScreenPageState();
}

class _AddPeopleToLiveScreenPageState extends State<AddPeopleToLiveScreenPage> {
  @override
  Widget build(BuildContext context) {
    // AddPeopleToLiveCubit addPeopleToLiveCubit =
    //     AddPeopleToLiveCubit.get(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Back',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              heightBox(20.h),
              const SearchBar(),
              heightBox(40.h),
              Text(
                "Co-host",
                style: mainStyle(context, 16.sp),
              ),
              heightBox(20.h),
              const AddPeopleCard(
                  name: "Dr.NaKaren A",
                  subName: "Specialist",
                  pictureUrl:
                      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                  isOnline: true,
                  isCoHost: true,
                  isverified: true),
              heightBox(20.h),
              Text(
                "Online",
                style: mainStyle(context, 16.sp),
              ),
              heightBox(20.h),
              const AddPeopleCard(
                  name: "Dr.NaKaren A",
                  subName: "Specialist",
                  pictureUrl:
                      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                  isOnline: false,
                  isCoHost: false,
                  isverified: false),
            ]),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, this.onFieldChanged}) : super(key: key);

  final Function(String)? onFieldChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: LiveInputField(
          label: "search",
          onFieldChanged: onFieldChanged,
          customHintText: 'Search by provider name',
          suffixIcon: SvgPicture.asset(
            'assets/svg/search.svg',
            width: 20.w,
          ),
        )),
      ],
    );
  }
}
