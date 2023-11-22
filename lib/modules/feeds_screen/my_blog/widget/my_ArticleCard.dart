
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/models/api_model/blogs_info_model.dart';
import 'package:mena/models/api_model/my_blog_info_model.dart';
import 'package:mena/modules/feeds_screen/blogs/article_details_layout.dart';
import 'package:mena/modules/feeds_screen/blogs/my_article_details_layout.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/blogItemHeader.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/blog_action_bar.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/general_blog_action_bar.dart';
import 'package:mena/modules/feeds_screen/my_blog/cubit/myBlog_cubit.dart';
import 'package:mena/modules/feeds_screen/my_blog/widget/my_blog_action_bar.dart';

import '../../../../core/functions/main_funcs.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';



class MyArticleCard extends StatefulWidget {
  const MyArticleCard({
    super.key,
    required this.article,
    this.isShowImage,
    this.isShowName,
    this.data,
    this.isShowFollow
  });

  final MenaArticle article;
  final  bool? isShowImage;
  final  bool? isShowName;
  final  bool? isShowFollow;
  final MyBlogInfoModel? data;
  @override
  State<MyArticleCard> createState() => _MyArticleCardState();
}

class _MyArticleCardState extends State<MyArticleCard> {
  @override
  Widget build(BuildContext context) {
    var myBlogCubit = MyBlogCubit.get(context);
    var mainCubit = MainCubit.get(context);
    return DefaultShadowedContainer(
      childWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget.isShowImage ==true ?
            heightBox(0.h):
            GestureDetector(
              onTap: () {
                widget.isShowImage ==true ?
                logg("djfyyyyyy")

                    :

                navigateToWithoutNavBar(
                    context,
                    MYArticleDetailsLayout(
                      menaArticleId: widget.article.id.toString(),
                    ),
                    'routeName');
              },
              child: DefaultImageFadeInOrSvg(
                backGroundImageUrl: widget.article.banner,
                isBlog: true,
                radius: 0,
                // borderColor: mainBlueColor,
              ),
            )     ,
            heightBox(7.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // widget.isShowImage ==true ?
                      // heightBox(0.h):
                      Text(
                        widget.article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: mainStyle(context, 14, isBold: true),
                      ),
                      heightBox(4.h),
                      widget.isShowName == true ?
                      SizedBox():
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlogItemHeader(
                            article: widget.article,
                          ),


                          widget.isShowImage ==true ?
                          widget.isShowFollow == false ?
                          SizedBox():

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () {


                                if ( widget.article.provider!.isFollowing!) {
                                  /// unfollow
                                  mainCubit.unfollowUser(userId:  widget.article.provider!.id.toString(), userType: widget.article.provider!.roleName ?? '')
                                      .then((value) {
                                    widget.article.provider!.isFollowing = false;
                                  });
                                } else {
                                  /// follow
                                  mainCubit.followUser(userId:  widget.article.provider!.id.toString(), userType: widget.article.provider!.roleName ?? '')
                                      .then((value) {
                                    widget.article.provider!.isFollowing = true;
                                  });
                                }

                                setState(() =>   widget.article.provider!.isFollowing = !  widget.article.provider!.isFollowing!);
                              },
                              child: Container(
                                height: 40.h,
                                width: 30.w,
                                color: Colors.transparent,
                                child: Center(
                                  child:


                                  widget.article.provider!.isFollowing == true ?
                                  SvgPicture.asset(
                                    'assets/icons/follow.svg',
                                    width: 35.sp,
                                  ):
                                  SvgPicture.asset(
                                    'assets/icons/plus.svg',
                                    height: 35,
                                    color: mainBlueColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                              :SizedBox(),
                        ],
                      )
                      ,
                      heightBox(12.h),
                      MyBlogActionBar(
                          article: widget.article ,
                          data:widget.data!,
                          isMyBlog:widget.isShowName),
                      heightBox(10.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          getFormattedDate(widget.article.createdAt),
                          style:
                          mainStyle(context, 11, color: newDarkGreyColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
