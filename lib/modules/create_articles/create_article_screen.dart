import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/create_articles/create_article_editor_screen.dart';
import 'package:mena/modules/create_articles/cubit/create_article_cubit.dart';
import 'package:mena/modules/create_articles/widget/article_input_field.dart';
import 'package:mena/modules/create_articles/widget/create_article_privacy_text.dart';
import 'package:mena/modules/create_articles/widget/select_blog_category_drop_down.dart';
import 'package:mena/modules/create_articles/widget/underline_input_widget.dart';
import 'package:mena/modules/create_articles/widget/upload_cover_picker.dart';

import '../../core/shared_widgets/shared_widgets.dart';

class CreateArticleScreen extends StatelessWidget {
  const CreateArticleScreen({super.key});

  static String routeName = 'createarticle';

  @override
  Widget build(BuildContext context) {
    var createArticleCubit = CreateArticleCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/addedbyzein/back.png', // Replace with your image path
            scale: 3,
            alignment: Alignment.centerRight, // Adjust the height as needed
          ),
          // SvgPicture.asset(
          //   'assets/svg/back_icon.svg',
          //   color: mainBlueColor,
          // ),
        ),
        title: Text(
          "Create Article",
          style: mainStyle(context, 16,
              color: Colors.black, weight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/svg/icons/Menu 3 dot - blue.svg',
              height: 18,
            ),
          ),
        ],
      ),
      bottomNavigationBar:  Container(
        height: 90,
        padding: EdgeInsets.all(20),
        child: DefaultButton(
          onClick: () {

          },
          text: 'Publish',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: BlocConsumer<CreateArticleCubit, CreateArticleState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return Form(
                  // key: ,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: 5),
                        child: ArticleUnderLineInputField(
                          label: 'Article Title',
                          maxLines: 2,
                          edgeInsetsGeometry:EdgeInsetsDirectional.only(start: 20,bottom: 10),
                          controller: createArticleCubit.title,
                          validate: normalInputValidate(context,
                              customText: 'It cannot be empty'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                            top: 40, bottom: 20, start: 10, end: 10),
                        child: InkWell(
                          onTap: (){
                            navigateTo(context, const EditorScreen());
                          },
                          child: ArticleInputField(
                            label: 'Start creating your article...',
                             enabled: false,
                            minLines: 5,
                            maxLines: 50,
                            controller: createArticleCubit.content,
                            validate: normalInputValidate(context,
                                customText: 'It cannot be empty'),
                          ),
                        ),
                      ),
                      SelectBlogCategoryDropDown(),
                      AddServiceImagePicker(),
                      PrivacyText(),




                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
