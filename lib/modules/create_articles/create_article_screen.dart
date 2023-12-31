import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/Colors.dart';
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

import '../../core/constants/constants.dart';
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
  createArticleCubit.imagePath =='';
    createArticleCubit.categoryId = '';
    createArticleCubit.title.clear();
    createArticleCubit.getBlogsInfo();
    createArticleCubit.content.clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var createArticleCubit = CreateArticleCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading:
      //
      //
      //   InkWell(
      //     onTap: () => Navigator.pop(context),
      //     child:
      //
      //       // Icon(
      //       //   Icons.arrow_back,
      //       //   color: AppColors.lineBlue,
      //       //   size: 30,
      //       // ),
      // SvgPicture.asset(
      //       'assets/icons/back.svg',
      //       color: mainBlueColor,
      //
      //     ),
      //   ),
      //   //  GestureDetector(
      //   //   onTap: () => Navigator.pop(context),
      //   //   child: Container(
      //   //     height: 10.h,
      //   //     width: 10.w,
      //   //     color: Colors.transparent,
      //   //     child: Center(
      //   //       child: SvgPicture.asset(
      //   //         'assets/icons/back.svg',
      //   //         color: mainBlueColor,
      //   //       ),
      //   //     ),
      //   //   ),
      //   // ),
      //   title: Text(
      //     "Create Article",
      //     style: mainStyle(context, 16,
      //         color: AppColors.gray, weight: FontWeight.w700),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //
      //     // IconButton(
      //     //   onPressed: () {},
      //     //   icon: SvgPicture.asset(
      //     //     'assets/svg/icons/Menu 3 dot - blue.svg',
      //     //     height: 18,
      //     //     color: Colors.blue,
      //     //   ),
      //     // ),
      //   ],
      // ),


      appBar:
      // PreferredSize(
      //   preferredSize: Size.fromHeight(50.0.h),
      //   child: DefaultBackTitleAppBar(
      //     // title: 'Blogs',
      //
      //     customTitleWidget: Center(
      //       child: Text(
      //         "Create Article",
      //         style: mainStyle(context, 14,
      //             weight: FontWeight.w400, color:AppColors.darkBlack, isBold: true),
      //       ),
      //     ),
      //
      //     suffix: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 12),
      //       child: SizedBox(),
      //     ),
      //
      //
      //   ),
      // ),


      AppBar(
        title:  Text("Create Article" ,

          style: mainStyle(context, 23,
                color: Color(0xff444444), weight: FontWeight.w700 )
                ,),
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
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        backgroundColor: Colors.white,
        elevation: 0.00,

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
                                  label: 'Start Creating Your Article...',
                                  enabled: false,
                                  minLines: 5,
                                  maxLines: 50,
                                  controller:
                                      createArticleCubit.content.text != ''
                                          ? TextEditingController(
                                              text: "Your Article is Here")
                                          : createArticleCubit.content,
                                  validate: normalInputValidate(context,
                                      customText: 'It cannot be empty'),
                                ),
                              ),
                            ),
                            SelectBlogCategoryDropDown(),
                            AddServiceImagePicker(),
                            PrivacyText(),
                            // heightBox(200.h),
                            Expanded(child: SizedBox()),
                            state is ArticleLoadingState
                                ? DefaultLoaderGrey()
                                : Container(
                                    // height: 90,
                              padding: EdgeInsets.only(
                                left: 20.w,
                                right: 20.w,
                                bottom:  20.w,
                              ),
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
        ),
      ),
    );
  }
}