import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/create_articles/cubit/create_article_cubit.dart';
import 'package:mena/modules/create_articles/model/pubish_article_model.dart';
import 'package:mena/modules/create_articles/widget/custom_value_selctor.dart';

class SelectBlogCategoryDropDown extends StatefulWidget {
  const SelectBlogCategoryDropDown({Key? key}) : super(key: key);

  @override
  State<SelectBlogCategoryDropDown> createState() =>
      _SelectBlogCategoryDropDownState();
}

class _SelectBlogCategoryDropDownState
    extends State<SelectBlogCategoryDropDown> {
  @override
  Widget build(BuildContext context) {
    var createArticleCubit = CreateArticleCubit.get(context);

    String selectedItem = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 35,
          padding: EdgeInsetsDirectional.only(start: 20, end: 10),
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Center(
              child: InkWell(
            onTap: () {
              showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return BlocBuilder<CreateArticleCubit, CreateArticleState>(
                        builder: (context, state) {
                      return Dialog(
                          insetPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .7,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: ListView.builder(
                              shrinkWrap: true,

                              itemCount: createArticleCubit
                                  .blogsInfoModel!.data.categories.length,
                              itemBuilder: (context, index) => SizedBox(
                                height: 50,
                                child: CustomValueSelector(
                                  textValue: createArticleCubit.blogsInfoModel!
                                      .data.categories[index].title,
                                  isSelectCountry: true,
                                  onChange: (val) {
                                    createArticleCubit.selectedCategory = val;
                                    for (Category item in createArticleCubit
                                        .blogsInfoModel!.data.categories) {
                                      if (item.title == val) {
                                        createArticleCubit.categoryId =
                                            item.id.toString();
                                      }
                                    }
                                    createArticleCubit.emit(CategoryChanged());
                                      Navigator.pop(context);
                                  },
                                  selected: createArticleCubit.blogsInfoModel!
                                      .data.categories[index].title,
                                  groupValue:
                                      createArticleCubit.selectedCategory ?? "",
                                ),
                              ),
                            ),
                          ));
                    });
                  });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(createArticleCubit.selectedCategory ?? 'Select Blog Topic',
                    style: mainStyle(context, 13,
                        color: AppColors.textGray, weight: FontWeight.w600)),
                Center(
                  child: Image.asset(
                    'assets/icons/Menu.png',
                    height: 20,
                  ),
                ),
              ],
            ),
          )
//

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              // Text('Select Blog Topic',
              // style: mainStyle(context, 13,
              //   color: AppColors.lineGray, weight: FontWeight.w600)),
              //
              //
              //   InkWell(
              //     onTap: (){
              //
              //       Get.bottomSheet(
              //           CustomBottomSheet(
              //               height: 280,
              //               // selectText: "Select Language",
              //               valueWidget: ListView.builder(
              //                 shrinkWrap: true,
              //                 itemCount: createArticleCubit.blogsInfoModel!.data.categories.length,
              //                 itemBuilder: (context, index) => CustomValueSelector(
              //                   textValue: createArticleCubit.blogsInfoModel!.data.categories[index].title.toString(),
              //                   isSelectCountry: false,
              //                   onChange: (val) {
              //                     // controller.selectLanguage(controller.langList[index].name);
              //                   },
              //                   selected: createArticleCubit.blogsInfoModel!.data.categories[index].id.toString(),
              //                   groupValue:createArticleCubit.selectedCategory.toString(),
              //
              //                 ),
              //               ))
              //       );
              //
              //
              //     },
              //     child: Image.asset(
              //       'assets/icons/Menu.png',
              //      height: 20,
              //        ),
              //   ),
              //   ],
              // )
              ),
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          height: 1,
          thickness: .5,
          color: AppColors.textGray,
        )
      ],
    );
  }
}
