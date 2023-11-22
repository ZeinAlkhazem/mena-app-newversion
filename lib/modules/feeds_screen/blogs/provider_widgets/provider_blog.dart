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

import '../../../../core/constants/constants.dart';
import '../../../../models/api_model/my_blog_info_model.dart' as myBlogModel;
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/Colors.dart';
import '../../../../core/functions/main_funcs.dart';
import '../../../../core/shared_widgets/shared_widgets.dart';
import '../../../../models/api_model/blogs_info_model.dart';
import '../../../../models/api_model/home_section_model.dart';
import '../../cubit/feeds_cubit.dart';
import '../article_details_layout.dart';
import '../blogs_layout.dart';
import 'Provider_Action_Bar.dart';
import '../widgets/blogItemHeader.dart';

class ProviderBlogLayout extends StatefulWidget {
  const ProviderBlogLayout(
      {super.key, this.providerId, this.type, this.providerInfo});

  final String? providerId;
  final String? type;
  final dynamic providerInfo;

  @override
  State<ProviderBlogLayout> createState() => _ProviderBlogLayoutState();
}

class _ProviderBlogLayoutState extends State<ProviderBlogLayout> {
  void initState() {
    // TODO: implement initState

    var feedsCubit = FeedsCubit.get(context);
    feedsCubit.myBlogInfoModel = null;
    feedsCubit.getBlogsInfo(context);

    feedsCubit.getProviderBlogs(context, providerId: widget.providerId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.providerInfo.fullName.toString() + "..." + 'Blog',
            style: mainStyle(context, 23,
                color: Color(0xff444444), weight: FontWeight.w700)),
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
      body: BlocConsumer<FeedsCubit, FeedsState>(
        listener: (BuildContext context, FeedsState state) {},
        builder: (context, state) {
          return (state is GettingMyBlogsInfoState ||
                  feedsCubit.myBlogInfoModel == null)
              ? DefaultLoaderColor()
              : feedsCubit.myBlogInfoModel == null
                  ? SizedBox()
                  : ProviderBlogsHome(
                      myBlogsInfoModel: feedsCubit.myBlogInfoModel!,
                      blogsInfoModel: feedsCubit.blogsInfoModel!,
                      type: widget.type,
                      providerId: widget.providerId,
                    );
        },
      ),
    );
  }
}

class ProviderBlogsHome extends StatefulWidget {
  const ProviderBlogsHome(
      {super.key,
      required this.myBlogsInfoModel,
      required this.blogsInfoModel,
      this.type,
      this.providerId});

  final MyBlogInfoModel myBlogsInfoModel;
  final BlogsInfoModel blogsInfoModel;

  final String? type;
  final String? providerId;

  @override
  State<ProviderBlogsHome> createState() => _ProviderBlogsHomeState();
}

class _ProviderBlogsHomeState extends State<ProviderBlogsHome> {
  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyBlogSimpleUserCard(
              provider: widget.myBlogsInfoModel.data,
              justView: true,
              isInEdit: true,
              currentLayout: 'provider',
              customBubbleCallback: () {
                if (widget.myBlogsInfoModel.data.provider!.isFollowing!) {
                  /// unfollow
                  mainCubit
                      .unfollowUser(
                          userId: widget.myBlogsInfoModel.data.provider!.id
                              .toString(),
                          userType:
                              widget.myBlogsInfoModel.data.provider!.roleName ??
                                  '')
                      .then((value) {
                    widget.myBlogsInfoModel.data.provider!.isFollowing = false;
                  });
                } else {
                  /// follow
                  mainCubit
                      .followUser(
                          userId: widget.myBlogsInfoModel.data.provider!.id
                              .toString(),
                          userType:
                              widget.myBlogsInfoModel.data.provider!.roleName ??
                                  '')
                      .then((value) {
                    widget.myBlogsInfoModel.data.provider!.isFollowing = true;
                  });
                }

                setState(() =>
                    widget.myBlogsInfoModel.data.provider!.isFollowing =
                        !widget.myBlogsInfoModel.data.provider!.isFollowing!);
              },
            ),
            if (widget.blogsInfoModel.data.categories.isNotEmpty)
              BlogsCategoriesSection(
                childs: widget.blogsInfoModel.data.categories,
                fatherId: 2,
                type: widget.type,
                providerId: widget.providerId,
              ),
            if (widget.myBlogsInfoModel.data.data.isNotEmpty)
              ProviderBlogArticlesSection(
                  articles: widget.myBlogsInfoModel.data),
          ],
        ),
      ),
    );
  }
}

class ProviderBlogArticlesSection extends StatelessWidget {
  const ProviderBlogArticlesSection({
    super.key,
    required this.articles,
  });

  final myBlogModel.Data articles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                ArticleProviderCard(
                article: articles.data[index], data: articles),
            separatorBuilder: (context, index) => heightBox(7.h),
            shrinkWrap: true,
            itemCount: articles.data.length,
          ),
        ],
      ),
    );
  }
}

class ArticleProviderCard extends StatefulWidget {
  ArticleProviderCard(
      {super.key,
      required this.article,
      this.isShowImage,
      this.isShowName,
      this.data,
      this.isShowFollow});

  MenaArticle article;
  final bool? isShowImage;
  final bool? isShowName;
  final bool? isShowFollow;
  final myBlogModel.Data? data;

  @override
  State<ArticleProviderCard> createState() => _ArticleProviderCardState();
}

class _ArticleProviderCardState extends State<ArticleProviderCard> {
  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    return DefaultShadowedContainer(
      childWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            widget.isShowImage == true
                ? heightBox(0.h)
                : GestureDetector(
                    onTap: () {
                      navigateToWithoutNavBar(
                          context,
                          ArticleDetailsLayout(
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
                  ),
            heightBox(7.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: mainStyle(context, 14, isBold: true),
                      ),
                      heightBox(4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.isShowImage == true
                              ? widget.isShowFollow == false
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() => feedsCubit.isFollow =
                                              !feedsCubit.isFollow);
                                        },
                                        child: Container(
                                          height: 40.h,
                                          width: 30.w,
                                          color: Colors.transparent,
                                          child: Center(
                                            child: feedsCubit.isFollow == true
                                                ? SvgPicture.asset(
                                                    'assets/icons/follow.svg',
                                                    width: 35.sp,
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/icons/plus.svg',
                                                    height: 35,
                                                    color: mainBlueColor,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    )
                              : SizedBox(),
                        ],
                      ),
                      heightBox(12.h),

                      ProviderBlogActionBar(
                          article: widget.article,
                          isMyBlog: widget.isShowName),
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
