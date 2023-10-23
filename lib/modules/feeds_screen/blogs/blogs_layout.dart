import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:mena/modules/feeds_screen/feeds_screen.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/blogs_info_model.dart';
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

    feedsCubit.getBlogsInfo();
    // feedsCubit.getBlogs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Blogs',
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
                  : BlogsHome(blogsInfoModel: feedsCubit.blogsInfoModel!);
        },
      ),
    );
  }
}

class BlogsHome extends StatelessWidget {
  const BlogsHome({
    super.key,
    required this.blogsInfoModel,
  });

  final BlogsInfoModel blogsInfoModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (blogsInfoModel.data.banners.isNotEmpty)
              BannersSection(banners: blogsInfoModel.data.banners),
            if (blogsInfoModel.data.categories.isNotEmpty)
              BlogsCategoriesSection(categories: blogsInfoModel.data.categories),
            if (blogsInfoModel.data.topArticles.isNotEmpty)
              BlogsTopArticlesSection(articles: blogsInfoModel.data.topArticles),
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

  final List<MenaArticle> articles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightBox(8.h),
          Text(
            'Top articles',
            style: mainStyle(context, 14, isBold: true),
          ),
          heightBox(10.h),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => ArticleCard(article: articles[index]),
            separatorBuilder: (context, index) => heightBox(7.h),
            shrinkWrap: true,
            itemCount: articles.length,
          ),
        ],
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    this.isDetails
  });

  final MenaArticle article;
  final bool? isDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isDetails ==false ?
            SizedBox()
            :
        navigateToWithoutNavBar(
            context,
            ArticleDetailsLayout(
              menaArticleId: article.id.toString(),
            ),
            'routeName');
      },
      child: DefaultShadowedContainer(
        childWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DefaultImageFadeInOrSvg(
                backGroundImageUrl: article.banner,
                borderColor: mainBlueColor,
              ),
              heightBox(7.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: mainStyle(context, 12, isBold: true),
                  ),
                  heightBox(7.h),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  DefaultSoftButton(
                    label: article.category.title ?? '',
                  ),
                  Text(
                    getFormattedDateWithDayName(article.createdAt),
                    style: mainStyle(context, 12, weight: FontWeight.w300),
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

class BlogsCategoriesSection extends StatelessWidget {
  const BlogsCategoriesSection({
    super.key,
    required this.categories,
  });

  final List<BlogBanner> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightBox(8.h),
          Text(
            'Blog categories',
            style: mainStyle(context, 14, isBold: true),
          ),
          heightBox(10.h),
          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: categories
                .map((e) => GestureDetector(
                      onTap: () {
                        navigateToWithoutNavBar(
                            context,
                            BlogArticlesListLayout(
                              category: e,
                            ),
                            'routeName');
                      },
                      child: Column(
                        children: [
                          Expanded(child: DefaultImageFadeInOrSvg(backGroundImageUrl: e.image)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(e.title ?? ''),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class BannersSection extends StatelessWidget {
  const BannersSection({
    super.key,
    required this.banners,
  });

  final List<BlogBanner> banners;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: (9 / 16).sw,
        width: double.maxFinite,
        child: CarouselSlider.builder(
          itemCount: banners.length,
          // carouselController: carouselController,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => GestureDetector(
            onTap: () {
              navigateToWithoutNavBar(
                  context,
                  ArticleDetailsLayout(
                    menaArticleId: banners[itemIndex].articleBlogId.toString(),
                  ),
                  'routeName');
            },
            child: DefaultImageFadeInOrSvg(
              backGroundImageUrl: banners[itemIndex].image,
              boxFit: BoxFit.cover,
              width: double.maxFinite,
              borderColor: mainBlueColor,
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
