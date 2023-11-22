import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/models/api_model/my_blog_info_model.dart';
import 'package:mena/modules/create_articles/create_article_screen.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/blog_categories_section.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/myBlogSimpleUserCard.dart';


import 'package:share_plus/share_plus.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../main.dart';
import '../../../models/api_model/blogs_info_model.dart';
import '../../../models/api_model/home_section_model.dart';
import '../cubit/feeds_cubit.dart';
import 'blogs_layout.dart';

class MyBlogLayout extends StatefulWidget {
  const MyBlogLayout(
      {super.key,
      required this.isMyBlog,
      this.providerId,
      this.type,
      this.providerInfo});

  final bool isMyBlog;
  final String? providerId;
  final String? type;
  final dynamic providerInfo;

  @override
  State<MyBlogLayout> createState() => _MyBlogLayoutState();
}

class _MyBlogLayoutState extends State<MyBlogLayout> {
  void initState() {
    // TODO: implement initState

    var feedsCubit = FeedsCubit.get(context);
    feedsCubit.myBlogInfoModel = null;
    feedsCubit.getBlogsInfo(context);
    widget.isMyBlog == true
        ? feedsCubit.getMyBlogs(context)
        : feedsCubit.getProviderBlogs(context, providerId: widget.providerId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isMyBlog == true
                ? user.fullName.toString() + "..." + 'Blog'
                : widget.providerInfo.fullName.toString() + "..." + 'Blog',
           


          style: mainStyle(context, 23,
                color: Color(0xff444444), weight: FontWeight.w700 )),
        titleSpacing: 00.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 30.h,
            width: 30.w,
            color: Colors.transparent,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/back_new.svg',
                color: AppColors.blackColor,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 37.h,
                width: 30.w,
                color: Colors.transparent,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/search28.svg',
                    color: AppColors.blackColor,

                  ),
                ),
              ),
            ),
          ),
        ],
    
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        backgroundColor: Colors.white,
        elevation: 0.00,
      ),
      floatingActionButton: widget.isMyBlog == true
          ? Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: IconButton(
                iconSize: 50,
                icon: Center(
                    child:      SvgPicture.asset("assets/icons/create_article.svg" ,       height: 50,)
           
                ),
                onPressed: () {
                  navigateToWithoutNavBar(
                      context, CreateArticleScreen(), 'routeName');
                },
              ),
            )
          : SizedBox(),
      body: BlocConsumer<FeedsCubit, FeedsState>(
        listener: (BuildContext context, FeedsState state) {},
        builder: (context, state) {
          return (state is GettingMyBlogsInfoState || feedsCubit.myBlogInfoModel == null)
              ? DefaultLoaderColor()
              : feedsCubit.myBlogInfoModel == null
                  ? SizedBox()
                  : MyBlogsHome(
                      myBlogsInfoModel: feedsCubit.myBlogInfoModel!,
                      blogsInfoModel: feedsCubit.blogsInfoModel!,
                      isMyBlog: widget.isMyBlog,
                      type: widget.type,
                      providerId: widget.providerId,
                    );
        },
      ),
    );
  }
}

class MyBlogsHome extends StatefulWidget {
  const MyBlogsHome(
      {super.key,
      required this.myBlogsInfoModel,
      required this.blogsInfoModel,
      required this.isMyBlog,
      this.type,
      this.providerId});

  final MyBlogInfoModel myBlogsInfoModel;
  final BlogsInfoModel blogsInfoModel;
  final bool isMyBlog;
  final String? type;
  final String? providerId;

  @override
  State<MyBlogsHome> createState() => _MyBlogsHomeState();
}

class _MyBlogsHomeState extends State<MyBlogsHome> {
  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    var feedsCubit = FeedsCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;
    log("tyyyype" + widget.isMyBlog.toString());
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // if (myBlogsInfoModel.data.provider ! = null)
            widget.isMyBlog == true
                ? MyBlogSimpleUserCard(
                    provider: widget.myBlogsInfoModel.data,
                    justView: true,
                    currentLayout: 'provider',
                  )
                : MyBlogSimpleUserCard(
                    provider: widget.myBlogsInfoModel.data,
                    justView: true,
                    isInEdit: true,
                    currentLayout: 'provider',
                    customBubbleCallback: () {
                      setState(() =>
                          feedsCubit.isChangeIcon != feedsCubit.isChangeIcon);
                      // feedsCubit.isChangeIcon !=  feedsCubit.isChangeIcon;
                    },
                  ),
            if (widget.blogsInfoModel.data.categories.isNotEmpty)
              BlogsCategoriesSection(
                childs: widget.blogsInfoModel.data.categories,
                fatherId: 2,
                type: widget.type,
                isMyBlogEnd: widget.isMyBlog,
                providerId: widget.providerId,
              ),
            if (widget.myBlogsInfoModel.data.data.isNotEmpty)
              BlogsMyArticlesSection(
                  articles: widget.myBlogsInfoModel.data),
          ],
        ),
      ),
    );
  }
}
