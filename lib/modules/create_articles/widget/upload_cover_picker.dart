import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/create_articles/cubit/create_article_cubit.dart';

import '../../../core/shared_widgets/shared_widgets.dart';
import '../../create_live/widget/default_button.dart';

class AddServiceImagePicker extends StatefulWidget {
  const AddServiceImagePicker({Key? key}) : super(key: key);

  @override
  State<AddServiceImagePicker> createState() => _AddServiceImagePickerState();
}

class _AddServiceImagePickerState extends State<AddServiceImagePicker> {
  @override
  Widget build(BuildContext context) {
    var createArticleCubit = CreateArticleCubit.get(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      // height: 0.22.sh,
                      color: Colors.white,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Pick Image",
                                style: mainStyle(context, 14,
                                    color: newDarkGreyColor, isBold: true),
                              ),
                              heightBox(15.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: DefaultButton(
                                        // color: Colors.white,
                                        backColor: newLightGreyColor,
                                        borderColor: Colors.transparent,
                                        height: 0.07.sh,
                                        // width: 33.w,
                                        text:
                                            getTranslatedStrings(context).image,
                                        customChild: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Gallery",
                                              style: mainStyle(context, 13,
                                                  color: newDarkGreyColor,
                                                  isBold: true),
                                            ),
                                            widthBox(7.w),
                                            SvgPicture.asset(
                                                'assets/svg/icons/camera.svg')
                                          ],
                                        ),
                                        onClick: () async {
                                          createArticleCubit
                                              .pickFromGallery(context);
                                        }),
                                  ),
                                  widthBox(10.w),
                                  Expanded(
                                    child: DefaultButton(
                                        // color: Colors.white,
                                        backColor: newLightGreyColor,
                                        borderColor: Colors.transparent,
                                        height: 0.07.sh,
                                        // width: 33.w,
                                        text:
                                            getTranslatedStrings(context).image,
                                        customChild: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTranslatedStrings(context)
                                                  .images,
                                              style: mainStyle(context, 13,
                                                  color: newDarkGreyColor,
                                                  isBold: true),
                                            ),
                                            widthBox(7.w),
                                            SvgPicture.asset(
                                                'assets/svg/icons/camera.svg')
                                          ],
                                        ),
                                        onClick: () async {
                                          createArticleCubit
                                              .pickFromCamera(context);
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 20, end: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Article Header Cover',
                    style: mainStyle(context, 13,
                        color: AppColors.textGray, weight: FontWeight.w600),
                  ),
                  Spacer(),
                  Image.asset(
                    'assets/icons/Gallery.png',
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 1,
            thickness: .5,
            color: AppColors.textGray,
          ),
          BlocBuilder<CreateArticleCubit, CreateArticleState>(
              builder: (context, state) {
            return  (state is ImageUploaded ||
                    state is ArticleLoadingState) &&
                    createArticleCubit.imagePath != ''
                ? Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 200,
                        width: double.maxFinite,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(
                              createArticleCubit.imagePath,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                  createArticleCubit.deleteImage();
                          },
                     
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22 ,vertical: 13),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 30,
                            ),
                          )),
                    ],
                  )
                : SizedBox();
          }),
        ],
      ),
    );
  }
}