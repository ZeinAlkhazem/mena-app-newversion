import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/modules/create_articles/create_article_screen.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/blogItemHeader.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/blog_action_bar.dart';
import 'package:mena/modules/feeds_screen/blogs/widgets/blog_categories_section.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:mena/modules/feeds_screen/feeds_screen.dart';

import '../../../core/constants/Colors.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../main.dart';
import '../../../models/api_model/blogs_info_model.dart';
import '../../../models/api_model/blogs_items_model.dart';
import '../../../models/api_model/home_section_model.dart';
import '../widgets/feed_item_header.dart';
import '../widgets/follow_user_button.dart';
import 'article_details_layout.dart';
import 'blogs_articles_list.dart';

class BlogsLayout extends StatefulWidget {
  const BlogsLayout({Key? key}) : super(key: key);

  @override
  State<BlogsLayout> createState() => _BlogsLayoutState();
}

class _BlogsLayoutState extends State<BlogsLayout> {
  @override
  void initState() {
    // TODO: implement initState

    var feedsCubit = FeedsCubit.get(context);
    feedsCubit.getBlogs();
    feedsCubit.getBlogsInfo(context);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;

    return Scaffold(
      appBar:
      AppBar(
        title:  Text( prefs.getString('platformName').toString() + " "+'Blogs',
         
          style: mainStyle(context, 23,
                color: Color(0xff444444), weight: FontWeight.w700 )),
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
                actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () => {},
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
      // PreferredSize(
      //   preferredSize: Size.fromHeight(56.0.h),
      //   child: DefaultBackTitleAppBar(
      //     // title: 'Blogs',
      //
      //     customTitleWidget: Center(
      //       child: Text(
      //         prefs.getString('platformName').toString() + " "+'Blogs',
      //         style: mainStyle(context, 14,
      //             weight: FontWeight.w400, color:AppColors.darkBlack, isBold: true),
      //       ),
      //     ),
      //     suffix: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 10),
      //       child: GestureDetector(
      //         onTap: () => Navigator.pop(context),
      //         child: Container(
      //           height: 35.h,
      //           width: 30.w,
      //           color: Colors.transparent,
      //           child: Center(
      //             child: SvgPicture.asset(
      //               'assets/icons/search.svg',
      //               color: mainBlueColor,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //
      //
      //   ),
      // ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: IconButton(
          iconSize: 50,
          icon: Center(
              child:
              SvgPicture.asset("assets/icons/create_article.svg")

            // Image.asset(
            //   'assets/icons/add.png',
            //   height: 30,
            // ),
          ),
          onPressed: () {
               navigateToWithoutNavBar(
                      context, CreateArticleScreen(), 'routeName');
          },
        ),
      ),
      body: BlocConsumer<FeedsCubit, FeedsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return state is GettingBlogsInfoState
              ? DefaultLoaderColor()
              : feedsCubit.blogsInfoModel == null
              ? SizedBox()
              : BlogsHome(blogsInfoModel: feedsCubit.blogsInfoModel! ,

               blogsItemsModel:    feedsCubit.blogsItemsModel!,
          );
        },
      ),
    );
  }
}

class BlogsHome extends StatelessWidget {
  const BlogsHome({
    super.key,
    required this.blogsInfoModel,
    required this.blogsItemsModel
  });

  final BlogsInfoModel blogsInfoModel;
  final BlogsItemsModel blogsItemsModel;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (blogsInfoModel.data.banners.isNotEmpty)
              BannersSection(banners: blogsInfoModel.data.banners),
            if (blogsInfoModel.data.categories.isNotEmpty)
              BlogsCategoriesSection(childs: blogsInfoModel.data.categories,fatherId: 2,),
            if ( blogsItemsModel.data.articles.isNotEmpty)
              BlogsTopArticlesSection(
                  articles:  blogsItemsModel.data.articles),
          ],
        ),
      ),
    );
  }
}

class BlogsTopArticlesSection extends StatelessWidget {
  const BlogsTopArticlesSection({
    super.key,
    required this.articles,
  });

  final dynamic articles;
  // final    List<DataDatum> articles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // heightBox(8.h),
          // Text(
          //   'Top articles',
          //   style: mainStyle(context, 14, isBold: true),
          // ),
          // heightBox(10.h),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                ArticleCard(article: articles[index] ,isShowName: false),
            separatorBuilder: (context, index) => heightBox(7.h),
            shrinkWrap: true,
            itemCount: articles.length,
          ),
        ],
      ),
    );
  }
}


class BlogsMyArticlesSection extends StatelessWidget {
  const BlogsMyArticlesSection({
    super.key,
    required this.articles,
  });

  final dynamic articles;
  // final    List<DataDatum> articles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // heightBox(8.h),
          // Text(
          //   'Top articles',
          //   style: mainStyle(context, 14, isBold: true),
          // ),
          // heightBox(10.h),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                ArticleCard(article: articles[index] ,isShowName: true, ),
            separatorBuilder: (context, index) => heightBox(7.h),
            shrinkWrap: true,
            itemCount: articles.length,
          ),
        ],
      ),
    );
  }
}
class ArticleCard extends StatefulWidget {
  const ArticleCard({
    super.key,
    required this.article,
    this.isShowImage,
    this.isShowName
  });

  final dynamic article;
  final  bool? isShowImage;
  final  bool? isShowName;

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
        var feedsCubit = FeedsCubit.get(context);
    return GestureDetector(
      onTap: () {

        widget.isShowImage ==true ?
        logg("djfyyyyyy") :

        navigateToWithoutNavBar(
            context,
            ArticleDetailsLayout(
              menaArticleId: widget.article.id.toString(),
            ),
            'routeName');
      },
      child: DefaultShadowedContainer(
        childWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              widget.isShowImage ==true ?
              heightBox(0.h):
              DefaultImageFadeInOrSvg(
                backGroundImageUrl: widget.article.banner,
                isBlog: true,
                radius: 0,
                // borderColor: mainBlueColor,
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
                        widget.isShowImage ==true ?
                        heightBox(0.h):    Text(
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {

                 setState(() =>   feedsCubit. isFollow = ! feedsCubit. isFollow);
                                },
                                child: Container(
                                  height: 40.h,
                                  width: 30.w,
                                  color: Colors.transparent,
                                  child: Center(
                                    child:
                                    
                                       feedsCubit. isFollow == true ?
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
                            ):SizedBox(),
                          ],
                        )
                        ,
                        heightBox(12.h),
                        BlogActionBar(article: widget.article),
                        heightBox(10.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            getFormattedDate(widget.article.createdAt),
                            style:
                            mainStyle(context, 11, color: newDarkGreyColor),
                          ),
                        )
                        // DefaultSoftButton(
                        //   label: article.category.title ?? '',
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class BlogsCategoriesSection extends StatelessWidget {
//   const BlogsCategoriesSection({
//     super.key,
//     required this.categories,
//   });
//
//   final List<BlogBanner> categories;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(defaultHorizontalPadding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           heightBox(8.h),
//           Text(
//             'Blog categories',
//             style: mainStyle(context, 14, isBold: true),
//           ),
//           heightBox(10.h),
//           GridView.count(
//             padding: EdgeInsets.zero,
//             crossAxisCount: 3,
//             crossAxisSpacing: 3,
//             mainAxisSpacing: 3,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             children: categories
//                 .map((e) => GestureDetector(
//                       onTap: () {
//                         navigateToWithoutNavBar(
//                             context,
//                             BlogArticlesListLayout(
//                               category: e,
//                             ),
//                             'routeName');
//                       },
//                       child: Column(
//                         children: [
//                           Expanded(
//                               child: DefaultImageFadeInOrSvg(
//                                   backGroundImageUrl: e.image)),
//                           Text(e.title ?? ''),
//                         ],
//                       ),
//                     ))
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

class BannersSection extends StatelessWidget {
  const BannersSection({
    super.key,
    required this.banners,
  });

  final List<BlogBanner> banners;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: SizedBox(
        height: (9 / 16).sw,
        width: double.maxFinite,
        child: CarouselSlider.builder(
          itemCount: banners.length,
          // carouselController: carouselController,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) =>
              GestureDetector(
                onTap: () {
                  // navigateToWithoutNavBar(
                  //     context,
                  //     ArticleDetailsLayout(
                  //       menaArticleId: banners[itemIndex].articleBlogId.toString(),
                  //     ),
                  //     'routeName');
                },
                child: DefaultImageFadeInOrSvg(
                  backGroundImageUrl: banners[itemIndex].image,
                  boxFit: BoxFit.cover,
                  width: double.maxFinite,
                  radius: 0,
                  // borderColor: mainBlueColor,
                ),
              ),
          options: CarouselOptions(
            autoPlay: false,
            reverse: false,
            height: double.maxFinite,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction: Responsive.isMobile(context) ? 1 : 1,
            aspectRatio: 1,
            initialPage: 1,
            scrollPhysics: ClampingScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
