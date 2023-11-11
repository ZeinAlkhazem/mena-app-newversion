import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../models/api_model/blogs_info_model.dart';
import '../../cubit/feeds_cubit.dart';
import '../../widgets/icon_with_text.dart';



class ShareActionBar extends StatelessWidget {
  const ShareActionBar({
    Key? key,
    required this.text,
    required this.image,required this.onTap,

    // required this.isMyFeed,
    // this.alreadyInComments = false,
  }) : super(key: key);
  final String text;
  final String image;
final    Function()? onTap;
  // final bool isMyFeed;
  // final bool alreadyInComments;

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    // return BlocConsumer<FeedsCubit, FeedsState>(
    //   listener: (context, state) {
    //     // TODO: implement listener
    //   },
    //   builder: (context, state) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap:
           onTap
            ,
            child: CircleAvatar(
              radius: 20.h,
              backgroundColor: Colors.white,
              child: Image.asset(image,height: 18,),
            ),
          ),
         heightBox(7.h),
          Text(
          text,
            style: mainStyle(context,  11,
                weight: FontWeight.w900,
                // letterSpacing: 1,
                color: Colors.black),
          ),


        ],
      ),
    );
    //   },
    // );
  }
}
