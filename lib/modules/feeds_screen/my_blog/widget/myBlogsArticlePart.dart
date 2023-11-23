import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/models/api_model/my_blog_info_model.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/functions/main_funcs.dart';
import 'my_ArticleCard.dart';


class BlogsMyArticlesPart extends StatelessWidget {
  const BlogsMyArticlesPart({
    super.key,
    required this.articles,
  });


  final    MyBlogInfoModel articles;

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
                MyArticleCard(
                    article: articles.data.data[index]
                    ,isShowName: true,
                    data :articles),
            separatorBuilder: (context, index) => heightBox(7.h),
            shrinkWrap: true,
            itemCount: articles.data.data.length,
          ),
        ],
      ),
    );
  }
}