import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/create_articles/cubit/create_article_cubit.dart';

class AddServiceImagePicker extends StatelessWidget {
  const AddServiceImagePicker({Key? key}) : super(key: key);

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
              createArticleCubit.pickFile(context);
            },
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 20, end: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload article header cover',
                    style: mainStyle(context, 13,
                        color: newDarkGreyColor, weight: FontWeight.w600),
                  ),
                  Spacer(),
                 Image.asset('assets/icons/Gallery - Gray.png',height: 20,),
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
            color: newDarkGreyColor,
          ),
          BlocBuilder<CreateArticleCubit, CreateArticleState>(
              builder: (context, state) {
            return state is ImageUploaded || state is ArticleLoadingState
                ? Container(
                    height: 200,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(
                          createArticleCubit.imagePath,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox();
          }),
        ],
      ),
    );
  }
}
