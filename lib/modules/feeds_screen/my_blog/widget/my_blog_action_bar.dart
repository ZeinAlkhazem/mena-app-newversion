import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/models/api_model/my_blog_info_model.dart';
import 'package:mena/modules/feeds_screen/my_blog/cubit/myBlog_cubit.dart';
import 'package:mena/modules/feeds_screen/my_blog/cubit/myBlog_state.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../models/api_model/blogs_info_model.dart';

import '../../cubit/feeds_cubit.dart';
import '../../widgets/icon_with_text.dart';

class MyBlogActionBar extends StatefulWidget {
  MyBlogActionBar({
    Key? key,
    required this.article,
    this.isMyBlog,
   this.data,
  }) : super(key: key);

  MyBlogInfoModel? data;
  final bool? isMyBlog;
  MenaArticle article;

  @override
  State<MyBlogActionBar> createState() => _MyBlogActionBarState();
}

class _MyBlogActionBarState extends State<MyBlogActionBar> {
  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    // return BlocConsumer<FeedsCubit, FeedsState>(
    //   listener: (context, state) {
    //     // TODO: implement listener
    //   },
    //   builder: (context, state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // widget.isMyBlog == true
          //     ?
          IconWithText(
                  text: getFormattedNumberWithKandM(
                      widget.article.likesCount.toString()),
                  customColor: null,
                  customSize: 18.sp,
                  svgAssetLink: widget.article.likesCount != 0
                      ? 'assets/svg/icons/like_solid.svg'
                      : 'assets/svg/icons/heart.svg',
                ),
              // :
          // GestureDetector(
          //         onTap: () async {
          //           widget.article.isLiked != widget.article.isLiked;
          //           log('heretttt');
          //           log(widget.article.isLiked.toString());
          //
          //           // widget.article.isLiked != widget.article.isLiked;
          //           bool result = await feedsCubit.toggleLikeBlogStatus(
          //               blogId: widget.article.id.toString(),
          //               isLiked: widget.article.isLiked);
          //           log("resulttttt" + result.toString());
          //           if (!result) {
          //             widget.article.isLiked != widget.article.isLiked;
          //           }
          //           setState(() {});
          //         },
          //         child: IconWithText(
          //           text: getFormattedNumberWithKandM(
          //               // "10"
          //               widget.article.likesCount.toString()),
          //           customColor: widget.article.isLiked ? mainBlueColor : null,
          //           customSize: 18.sp,
          //           svgAssetLink: widget.article.isLiked
          //               ? 'assets/svg/icons/like_solid.svg'
          //               : 'assets/svg/icons/heart.svg',
          //         ),
          //       ),
          widthBox(15.w),
          BlocBuilder<MyBlogCubit, MyBlogState>(builder: (context, state) {
            return GestureDetector(
              onTap: () {
                log('tap');
                MyBlogCubit.get(context).shareProduct(context,
                    widget.article.shareLink, widget.article.id.toString(),
                    isMyBlog: true);
              },
              child: IconWithText(
                text: widget.article.sharesCount.toString(),
                customSize: 18.sp,
                svgAssetLink: 'assets/svg/icons/share_outline.svg',
                customIconColor: newDarkGreyColor,
              ),
            );
          }),
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
                '${widget.article.view != null ? getFormattedNumberWithKandM(widget.article.view.toString()) : 0}',
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
