import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/models/api_model/blogs_info_model.dart';
import 'package:mena/modules/create_articles/cubit/create_article_cubit.dart';

import 'custom_bottom_sheet.dart';
import 'custom_value_selctor.dart';

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
          height:35,
          padding: EdgeInsetsDirectional.only(start: 20, end: 10),
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Center(
            child:

            DropdownButton(
              underline: SizedBox(),
              isExpanded: true,
              iconSize: 25,
              icon: Center(
                child: Image.asset(
                  'assets/icons/Menu.png',
                  height: 20,
                ),
              ),
              hint: Text('Select Blog Topic',
                  style: mainStyle(context, 13,
                      color: AppColors.lineGray, weight: FontWeight.w600)),
              borderRadius: BorderRadius.circular(10),
              elevation: 0,

              onChanged: (value) {
                createArticleCubit.selectedCategory=value as String;
                setState(() {

                });
                log(value.toString());
                createArticleCubit.categoryId = value.toString();
                     log(     createArticleCubit.categoryId.toString());
              },
               value: createArticleCubit.selectedCategory,
              items:


              createArticleCubit.blogsInfoModel!.data.categories
                  .map<DropdownMenuItem<String>>((value) {
                return

                  DropdownMenuItem<String>(
                  value: value.id.toString(),
                  child:

                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey,
                 borderRadius: BorderRadius.circular(12)
                    ),
                    // width: 80,
                    height:380,
                    child:
                    // CustomValueSelector(
                    //   textValue: value.title.toString(),
                    //   isSelectCountry: false,
                    //   onChange: (value) {
                    //     createArticleCubit.selectedCategory=value as String;
                    //     setState(() {
                    //
                    //     });
                    //     log(value.toString());
                    //     createArticleCubit.categoryId = value.toString();
                    //          log(     createArticleCubit.categoryId.toString());
                    //   },
                    //   selected:value.id.toString(),
                    //   groupValue: createArticleCubit.selectedCategory.toString(),
                    //
                    // ),
                    Row(
                      children: [
                        Text(value.title.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    overflow: TextOverflow.fade,
                                    color: newDarkGreyColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300)),

                      ],
                    ),
                  ),
                );
              }).toList(),



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
        )
      ],
    );
  }
}
