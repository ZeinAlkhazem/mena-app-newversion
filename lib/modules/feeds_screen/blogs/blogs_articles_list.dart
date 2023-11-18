import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/feeds_screen/blogs/blogs_layout.dart';

import '../../../core/constants/constants.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/blogs_info_model.dart';
import '../cubit/feeds_cubit.dart';

class BlogArticlesListLayout extends StatefulWidget {
  const BlogArticlesListLayout({Key? key, required this.category}) : super(key: key);

  final BlogBanner category;

  @override
  State<BlogArticlesListLayout> createState() => _BlogArticlesListLayoutState();
}

class _BlogArticlesListLayoutState extends State<BlogArticlesListLayout> {
  @override
  void initState() {
    // TODO: implement initState

    var feedsCubit = FeedsCubit.get(context);

    // feedsCubit.getBlogsInfo();
    feedsCubit.getBlogs(categoryId: widget.category.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var feedsCubit = FeedsCubit.get(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: widget.category.title,
        ),
      ),
      body: BlocConsumer<FeedsCubit, FeedsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return state is GettingBlogsItemsState
              ? DefaultLoaderColor()
              : feedsCubit.blogsItemsModel!.data.data.isEmpty
                  ? SizedBox()
                  : ListView.separated(
                      padding: EdgeInsets.all(defaultHorizontalPadding),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          ArticleCard(article: feedsCubit.blogsItemsModel!.data.data[index]),
                      separatorBuilder: (context, index) => heightBox(10.h),
                      itemCount: feedsCubit.blogsItemsModel!.data.data.length,
                    );
        },
      ),
    );
  }
}
