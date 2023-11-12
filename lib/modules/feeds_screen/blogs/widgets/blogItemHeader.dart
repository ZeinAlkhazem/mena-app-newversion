import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../../core/functions/main_funcs.dart';
import '../../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';

import '../../../../models/api_model/blogs_info_model.dart';
import '../../cubit/feeds_cubit.dart';


class BlogItemHeader extends StatelessWidget {
  const BlogItemHeader({
    Key? key,
    required this.article,

  }) : super(key: key);
  // final MenaArticle article;
  final dynamic article;
  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);

    // return BlocConsumer<FeedsCubit, FeedsState>(
    //   listener: (context, state) {
    //     // TODO: implement listener
    //   },
    //   builder: (context, state) {
        return GestureDetector(
          onTap: () {

          },
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileBubble(
                isOnline: false,
                radius: 21.sp,
                pictureUrl: article.provider!.personalPicture,
              ),
              widthBox(10.w),
              SizedBox(
                height: 44.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // color: Colors.red,
                              constraints: BoxConstraints(maxWidth: 133.w),
                              child: Text(
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                '${article.provider  == null ? '' : '${article.provider!.fullName} '}',
                                style: mainStyle(context, 13, weight: FontWeight.w800),
                              ),
                            ),
                            (article.provider!.verified == '1')
                                ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                Icons.verified,
                                color: Color(0xff01BC62),
                                size: 16.sp,
                              ),
                            )
                                : SizedBox()
                          ],
                        ),
                        // Text.rich(
                        //   maxLines: 2,softWrap: true,
                        //   overflow: TextOverflow.ellipsis,
                        //   TextSpan(
                        //     children: [
                        //       TextSpan(
                        //         text:
                        //             "${chat.user!.abbreviation == null ? '' : chat.user!.abbreviation!.name} ${chat.user!.fullName}",
                        //         style:
                        //             mainStyle(context, 13, weight: FontWeight.w600),
                        //         // spellOut: false
                        //       ),
                        //       if (chat.user!.verified == '1')
                        //         WidgetSpan(
                        //           child: Padding(
                        //             padding:
                        //                 const EdgeInsets.symmetric(horizontal: 3.0),
                        //             child: Icon(
                        //               Icons.verified,
                        //               color: Color(0xff01BC62),
                        //               size: 16.sp,
                        //             ),
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                        // ),
                        // Text(
                        //   chat.user!.fullName.toString(),
                        //   style: mainStyle(
                        //       context, 14, weight: FontWeight.w800),
                        // ),
                      ],
                    ),
                    Text(
                      article.provider!.speciality == null
                          ? article.provider!.specialities!.isNotEmpty
                          ?article.provider!.specialities![0].name
                          : '--'
                          : article.provider!.speciality,
                      style: mainStyle(context, 10, color: AppColors.darkBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    //   },
    // );
  }
}
