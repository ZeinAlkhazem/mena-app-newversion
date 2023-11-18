import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../models/api_model/blogs_info_model.dart';
import '../../../../models/api_model/my_blog_info_model.dart' as myBlogModel;
import '../../cubit/feeds_cubit.dart';
import '../../widgets/icon_with_text.dart';



class BlogActionBar extends StatefulWidget {
  BlogActionBar({
    Key? key,
    required this.article,
    this.isMyBlog,
    this.data,
    // this.alreadyInComments = false,
  }) : super(key: key);

  // final dynamic article;
  myBlogModel.Data? data;
  final bool? isMyBlog;
  MenaArticle article;

  @override
  State<BlogActionBar> createState() => _BlogActionBarState();
}

Future<void> shareProduct(String Link) async {
  try {
    await Share.share(Link);
  } catch (e, s) {
    log("$e $s");
  }
}
class _BlogActionBarState extends State<BlogActionBar> {
  // final bool isMyFeed;
  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return BlocConsumer<FeedsCubit, FeedsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding:
          EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              widget.isMyBlog == true ?
              IconWithText(


                text: getFormattedNumberWithKandM(

                  widget.article.likesCount.toString()
                ),
                customColor:
                 null,
                customSize: 18.sp,
                svgAssetLink:
                widget.article.likesCount != 0
                    ? 'assets/svg/icons/like_solid.svg'
                    :
                'assets/svg/icons/heart.svg',
              ):
              GestureDetector(
                onTap: () async {
                  widget.article.isLiked != widget.article.isLiked;
                  log('heretttt');
                  log('////////Blog Action Bar ///////');
                  log(widget.article.isLiked.toString());
                  bool result = await feedsCubit.toggleLikeBlogStatus(
                      blogId: widget.article.id.toString(),
                      isLiked: widget.article.isLiked);
                  log( "resulttttt "+result.toString());
                },
                child: IconWithText(


                  text: getFormattedNumberWithKandM(
                      widget.article.likesCount.toString()
                ),
                  customColor:
                  widget.article.isLiked ?
                  mainBlueColor : null,
                  customSize: 18.sp,
                  svgAssetLink:
                  widget.article.isLiked
                      ? 'assets/svg/icons/like_solid.svg'
                      :
                  'assets/svg/icons/heart.svg',
                ),
              ),
              widthBox(15.w),

              GestureDetector(
                onTap: (){
                  feedsCubit .shareProduct( context ,
                    widget.article.shareLink ,
                    widget.article.id.toString() ,


                  );
                },
                child: IconWithText(
                 text:
                 widget.isMyBlog == true ?

               widget.data!.totalShares.toString():
                 widget.article.sharesCount.toString(),
                  // text: widget.data.totalShares.toString(),
                  customSize: 18.sp,
                  svgAssetLink: 'assets/svg/icons/share_outline.svg',
                  customIconColor: newDarkGreyColor,
                ),
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
                    '${widget.article.view != null ? getFormattedNumberWithKandM(widget.article.view.toString()) : 0}',
                    style: mainStyle(context, 13,
                        color: newDarkGreyColor, weight: FontWeight.w700),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
