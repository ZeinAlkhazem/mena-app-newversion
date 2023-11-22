import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../models/api_model/blogs_info_model.dart';
import '../../cubit/feeds_cubit.dart';
import '../../widgets/icon_with_text.dart';



class GeneralBlogActionBar extends StatefulWidget {
   GeneralBlogActionBar({
    Key? key,
    required this.article,
    this.isMyBlog,

    // this.alreadyInComments = false,
  }) : super(key: key);
   MenaArticle article;
  // final dynamic article;
  final bool? isMyBlog;

  @override
  State<GeneralBlogActionBar> createState() => _BlogActionBarState();
}
// Future<void> shareProduct(String Link) async {
//   try {
//     await Share.share(Link);
//   } catch (e, s) {
//     log("$e $s");
//   }
// }
class _BlogActionBarState extends State<GeneralBlogActionBar> {

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    log(widget.article.isLiked.toString());
    log('//////////');
    // return BlocConsumer<FeedsCubit, FeedsState>(
    //   listener: (context, state) {
    //     // TODO: implement listener
    //   },
    //   builder: (context, state) {
    return BlocBuilder<FeedsCubit,FeedsState>(builder: (context,state){
      return Padding(
        padding:
        EdgeInsets.symmetric(horizontal: defaultHorizontalPadding / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                log('////////General Bar ///////');
                log(widget.article.isLiked.toString());
                bool result = await feedsCubit.toggleLikeBlogStatus(
                    blogId: widget.article.id.toString(),
                    isLiked: widget.article.isLiked);
                log( "////////General Bar /////// "+result.toString());
              },

              child: IconWithText(
                text: getFormattedNumberWithKandM(widget.article.likesCount.toString()
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
              feedsCubit .shareProduct( context , widget.article.shareLink ,widget.article.id.toString() );
              },
              child: IconWithText(
                text: widget.article.sharesCount.toString(),
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
    });
    //   },
    // );
  }
}
