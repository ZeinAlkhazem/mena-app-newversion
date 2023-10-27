import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/appointments/appointments_layouts/appointment_saved_success.dart';
import 'package:mena/modules/create_articles/create_article_editor_screen.dart';
import 'package:mena/modules/create_articles/cubit/create_article_cubit.dart';
import 'package:mena/modules/create_articles/widget/article_input_field.dart';
import 'package:mena/modules/create_articles/widget/create_article_privacy_text.dart';
import 'package:mena/modules/create_articles/widget/select_blog_category_drop_down.dart';
import 'package:mena/modules/create_articles/widget/underline_input_widget.dart';
import 'package:mena/modules/create_articles/widget/upload_cover_picker.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';

import '../../core/shared_widgets/shared_widgets.dart';

class CreateArticleScreen extends StatefulWidget {
  const CreateArticleScreen({super.key});

  static String routeName = 'createarticle';

  @override
  State<CreateArticleScreen> createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState

    var createArticleCubit = CreateArticleCubit.get(context);

    createArticleCubit.getBlogsInfo();
    // feedsCubit.getBlogs();

    super.initState();
  }

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
              color: Colors.blue,
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: 90,
      //   padding: EdgeInsets.all(20),
      //   child: DefaultButton(
      //     onClick: () {

      //     },
      //     text: 'Publish',
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: BlocConsumer<CreateArticleCubit, CreateArticleState>(
              listener: (context, state) {
                //         if (state is SuccessGettingArticleState) {
                //   navigateTo(
                //     context,
                //     AppointmentSavedSuccess(),
                //   );
                // }
              },
              builder: (context, state) {
                return state is GettingArticleInfoState
                    ? DefaultLoaderColor()
                    : createArticleCubit.blogsInfoModel == null
                        ? SizedBox()
                        : Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.only(top: 5),
                                  child: ArticleUnderLineInputField(
                                    label: 'Article Title',
                                    maxLines: 2,
                                    edgeInsetsGeometry:
                                        EdgeInsetsDirectional.only(
                                            start: 20, bottom: 10),
                                    controller: createArticleCubit.title,
                                    validate: normalInputValidate(context,
                                        customText: 'It cannot be empty'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      top: 40, bottom: 20, start: 10, end: 10),
                                  child: InkWell(
                                    onTap: () {
                                      navigateTo(context, const EditorScreen());
                                    },
                                    child: ArticleInputField(
                                      label: 'Start creating your article...',
                                      enabled: false,
                                      minLines: 5,
                                      maxLines: 50,
                                      controller:
                                          createArticleCubit.content != ''
                                              ? TextEditingController(
                                                  text: "your article is here")
                                              : createArticleCubit.content,
                                      validate: normalInputValidate(context,
                                          customText: 'It cannot be empty'),
                                    ),
                                  ),
                                ),
                                SelectBlogCategoryDropDown(),
                                AddServiceImagePicker(),
                                PrivacyText(),
                                heightBox(35.h),
                                // Expanded(child: SizedBox()),
                                state is ArticleLoadingState
                                    ? DefaultLoaderGrey()
                                    : Container(
                                        height: 90,
                                        padding: EdgeInsets.all(20),
                                        child: DefaultButton(
                                          onClick: () {
                                            logg('userLogin started');
                                            createArticleCubit
                                                .toggleAutoValidate(true);
                                            createArticleCubit
                                                .checkValidation();
                                            if (formKey.currentState!
                                                    .validate() &&
                                                (createArticleCubit
                                                    .checkValidation())) {
                                              logg('validate');
                                              createArticleCubit
                                                  .publishArticle(context);
                                            }
                                          },
                                          text: 'Publish',
                                        ),
                                      ),
                              ],
                            ),
                          );
              },
            )),
      ),
    );
  }
}
