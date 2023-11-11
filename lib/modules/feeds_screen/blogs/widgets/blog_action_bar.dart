import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../models/api_model/blogs_info_model.dart';
import '../../cubit/feeds_cubit.dart';
import '../../widgets/icon_with_text.dart';



class BlogActionBar extends StatelessWidget {
  const BlogActionBar({
    Key? key,
    required this.article,
    // required this.isMyFeed,
    // this.alreadyInComments = false,
  }) : super(key: key);
  // final MenaArticle article;
  final dynamic article;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // feedsCubit.toggleLikeStatus(
                  //     feedId: article.id.toString(),
                  //     isLiked: article.isLiked);
                },
                child: IconWithText(


                  text: getFormattedNumberWithKandM(
                      article.provider!.likes.toString()),
                  customColor:null,
                  // article.provider!.isLiked ?
                  // mainBlueColor : null,
                  customSize: 18.sp,
                  svgAssetLink:
                  // article.provider!.isLiked
                  //     ? 'assets/svg/icons/like_solid.svg'
                  //     :
                  'assets/svg/icons/heart.svg',
                ),
              ),
              widthBox(15.w),
              IconWithText(
                text: '167',
                customSize: 18.sp,
                svgAssetLink: 'assets/svg/icons/share_outline.svg',
                customIconColor: newDarkGreyColor,
              ),

              widthBox(20.w),
              Row(
                children: [
                 Image.asset(
                    'assets/icons/eye.png',
                    height: 15,
                    // color: newDarkGreyColor,
                  ),
                  widthBox(7.w),
                  Text(
                    '${article.view != null ? getFormattedNumberWithKandM(article.view.toString()) : 0}',
                    style: mainStyle(context, 13,
                        color: newDarkGreyColor, weight: FontWeight.w700),
                  )
                ],
              )
            ],
          ),
        );
    //   },
    // );
  }
}
