// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/models/api_model/blogs_info_model.dart';
import 'package:mena/modules/feeds_screen/blogs/blogs_layout.dart';
import 'package:flutter_html/flutter_html.dart';
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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: DefaultBackTitleAppBar(
          title: 'back',
        ),
      ),
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
                    : Padding(
                        padding: EdgeInsets.all(defaultHorizontalPadding),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ArticleCard(article: feedsCubit.menaArticleDetails!,isDetails:false),
                              heightBox(10.h),
                              SimpleUserCard(
                                provider: feedsCubit.menaArticleDetails!.provider,
                                currentLayout: 'Article details',
                              ),
                              heightBox(10.h),
                              // Html(data: feedsCubit.menaArticleDetails!.content,
                              
                              // onLinkTap: ,
                              // ),

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

                              Text(
                                feedsCubit.menaArticleDetails!.title,
                                style: mainStyle(context, 14, isBold: true),
                              ),
                              heightBox(10.h),
                              // HtmlContentViewer(
                              //   htmlContent: feedsCubit.menaArticleDetails!.content,
                              // ),
                            ],
                          ),
                        ),
                      );
          },
        ),
      ),
    );
  }
}
