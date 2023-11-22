
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/models/api_model/my_blog_info_model.dart';
import 'package:mena/modules/create_articles/create_article_screen.dart';
import 'package:mena/modules/feeds_screen/my_blog/cubit/myBlog_cubit.dart';
import 'package:mena/modules/feeds_screen/my_blog/widget/MyBlogUserCard.dart';
import 'package:mena/modules/feeds_screen/my_blog/widget/myBlogsArticlePart.dart';
import 'package:mena/modules/feeds_screen/my_blog/widget/my_blog_categories_section.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import 'cubit/myBlog_state.dart';


class MyBlogPage extends StatefulWidget {
  const MyBlogPage(
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
  State<MyBlogPage> createState() => _MyBlogPageState();
}

class _MyBlogPageState extends State<MyBlogPage> {
  void initState() {
    // TODO: implement initState

    var myBlogCubit = MyBlogCubit.get(context);
    myBlogCubit.getMyBlogs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var myBlogCubit = MyBlogCubit.get(context);
    var mainCubit = MainCubit.get(context);
    User user = mainCubit.userInfoModel!.data.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.fullName.toString() + "..." + 'Blog',
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: IconButton(
          iconSize: 50,
          icon: Center(
              child: SvgPicture.asset(
            "assets/icons/create_article.svg",
            height: 50,
          )),
          onPressed: () {
            navigateToWithoutNavBar(
                context, CreateArticleScreen(), 'routeName');
          },
        ),
      ),
      body: BlocConsumer<MyBlogCubit, MyBlogState>(
        listener: (BuildContext context, MyBlogState state) {},
        builder: (context, state) {
          return (state is GettingMyBlogsInfoState)
              ? DefaultLoaderColor()
              : myBlogCubit.myBlogsInfoModel == null
                  ? SizedBox()
                  : MyBlogsHome(
                      myBlogsInfoModel: myBlogCubit.myBlogsInfoModel!,
                    );
        },
      ),
    );
  }
}

class MyBlogsHome extends StatefulWidget {
  const MyBlogsHome({
    super.key,
    required this.myBlogsInfoModel,
  });

  final MyBlogInfoModel myBlogsInfoModel;

  @override
  State<MyBlogsHome> createState() => _MyBlogsHomeState();
}

class _MyBlogsHomeState extends State<MyBlogsHome> {
  @override
  Widget build(BuildContext context) {
    // var mainCubit = MainCubit.get(context);
    // var myBlogCubit = MyBlogCubit.get(context);
    return SafeArea(
      child: BlocBuilder<MyBlogCubit,MyBlogState>(builder:(context,state){
        return SingleChildScrollView(
          child: Column(
            children: [
              MyBlogUserCard(
                provider: widget.myBlogsInfoModel,
                justView: true,
                currentLayout: 'provider',
              ),
              if (widget.myBlogsInfoModel.data.categories.isNotEmpty)
                MyBlogsCategoriesSection(
                  childs: widget.myBlogsInfoModel.data.categories,
                  fatherId: 2,
                ),
              if (widget.myBlogsInfoModel.data.data.isNotEmpty)
                BlogsMyArticlesPart(articles: widget.myBlogsInfoModel),
            ],
          ),
        );
      }),
    );
  }
}
