// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/Colors.dart';
// import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/main.dart';
import 'package:mena/models/api_model/blogs_info_model.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/modules/feeds_screen/blogs/blogs_layout.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/blog_action_bar.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/search_field.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/shareActionBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../platform_provider/provider_home/platform_provider_home.dart';
import '../cubit/feeds_cubit.dart';

class ArticleDetailsLayout extends StatefulWidget {
  const ArticleDetailsLayout({Key? key, required this.menaArticleId}) : super(key: key);

  // final MenaArticle menaArticle;
  final String menaArticleId;

  @override
  State<ArticleDetailsLayout> createState() => _ArticleDetailsLayoutState();
}

class _ArticleDetailsLayoutState extends State<ArticleDetailsLayout> {
  @override
  void initState() {
    // TODO: implement initState
    var feedsCubit = FeedsCubit.get(context);

    feedsCubit.getBlogDetails(articleId: widget.menaArticleId.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar:
      AppBar(
        title:  Text(         prefs.getString('platformName')! + " "+'Articles',
        
          style: mainStyle(context, 23,
                color: Color(0xff444444), weight: FontWeight.w700 ) ),
        titleSpacing: 00.0,
        leading:   GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 30.h,
            width: 30.w,
            color: Colors.transparent,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/back_new.svg',
                color: mainBlueColor,
              ),
            ),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        backgroundColor: Colors.white,
        elevation: 0.00,

      ),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(50.0.h),
      //   child: DefaultBackTitleAppBar(
      //     // title: 'back',
      //
      //     customTitleWidget: Center(
      //       child: Text(
      //         prefs.getString('platformName')! + " "+'Articles',
      //         style: mainStyle(context, 14,
      //             weight: FontWeight.w400, color: Colors.black, isBold: true),
      //       ),
      //     ),
      //
      //     suffix: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 10),
      //       child: GestureDetector(
      //         onTap: () {
      //
      //           showModalBottomSheet(
      //     context: context,
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //             topRight:     Radius.circular(15) ,
      //             topLeft:      Radius.circular(15)
      //         ),
      //           ),
      //
      //    builder:  (context) => Container(
      //
      //    // padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      //       height: 250,
      //       decoration: BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: BorderRadius.only(
      //             topRight:     Radius.circular(15) ,
      //             topLeft:      Radius.circular(15)
      //         ),
      //       ),
      //       child: Column(
      //           // mainAxisSize: MainAxisSize.max,
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //
      //            Expanded(
      //              child: Padding(
      //                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      //                child: Column(
      //                  children: [
      //                    Row(
      //                      children: [
      //                        Text(
      //                          'Share',
      //                          style: mainStyle(context, 14,
      //                              weight: FontWeight.w400, color: Colors.black, isBold: true),
      //                        ),
      //                      ],
      //                    ),
      //                    FilterField(),
      //                    SizedBox(height: 10.w,),
      //                    Row(
      //                      children: [
      //                        CircleAvatar(
      //                          radius: 20.h,
      //                          backgroundColor: Colors.grey.shade100,
      //                          child: Icon(Icons.add,color: mainBlueColor,size: 33,),
      //                        ),
      //                        SizedBox(width: 10.w,),
      //                        Text(
      //                          'Create chat',
      //                          style: mainStyle(context, 14,
      //                              weight: FontWeight.w400, color: Colors.black, isBold: true),
      //                        ),
      //                      ],
      //                    ),
      //                  ],
      //                ),
      //              ),
      //            ),
      //
      //             Container(
      //               color: Colors.grey.shade100,
      //               padding: const EdgeInsets.only(top: 10,bottom: 10),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   ShareActionBar(
      //                     onTap: (){},
      //                     image:'assets/icons/myFeed.png' ,
      //                     text: 'My Wall',
      //
      //                   ),
      //                   ShareActionBar(
      //                     onTap: (){},
      //                     image:'assets/icons/copyLink.png' ,
      //                     text: 'Copy link',
      //
      //                   ),
      //                   ShareActionBar(
      //                     onTap: (){},
      //                     image:'assets/icons/more.png' ,
      //                     text: 'More',
      //
      //                   ),
      //
      //                 ],
      //               ),
      //             )
      //
      //           ]
      //       ),
      //     ));
      //
      //
      //         },
      //         child: Container(
      //           height: 35.h,
      //           width: 30.w,
      //           color: Colors.transparent,
      //           child: Center(
      //             child: SvgPicture.asset(
      //               'assets/icons/share.svg',
      //               color: mainBlueColor,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),

      // bottomNavigationBar:

      
      body: SafeArea(
        child: BlocConsumer<FeedsCubit, FeedsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return state is GettingBlogDetailsState
                ? DefaultLoaderColor()
                : feedsCubit.menaArticleDetails == null
                    ? SizedBox()
                    :
      
          Column(
            
              children: [
      
                Padding(
                            padding: EdgeInsets.all(defaultHorizontalPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
      
      
                                DefaultImageFadeInOrSvg(
                                  backGroundImageUrl:feedsCubit.menaArticleDetails!.banner,
                                  isBlog: false,
      
                                  radius: 30,
                                  // borderColor: mainBlueColor,
                                ),
      
                                heightBox(10.h),
                                // SimpleUserCard(
                                //   provider: feedsCubit.menaArticleDetails!.provider  ,
                                //   currentLayout: 'Article details',
                                // ),
                                Text(
                                  feedsCubit.menaArticleDetails!.title,
                                  style: mainStyle(context, 14, isBold: true),
                                ),
                                heightBox(10.h),
      
                                Html( data: feedsCubit.menaArticleDetails!.content,
      
                                onLinkTap: (url, _, __) async{
                                   if (await canLaunch(url.toString())) {
                                      await launch(
                                  url.toString()
      
                                  ,
                            );
                               } else {
                            throw 'Could not launch $url';
                                  }
                                   }
      
                                 ),
      
      
      
                              ],
                            ),
                          ),
      
      
      
                 Spacer(),
                ArticleCard(article: feedsCubit.menaArticleDetails!,
                  isShowImage: true,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
