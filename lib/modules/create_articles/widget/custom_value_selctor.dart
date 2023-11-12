import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mena/core/constants/constants.dart';

import '../../../core/constants/Colors.dart';



class CustomValueSelector extends StatelessWidget {
   CustomValueSelector(
      {super.key,
      required this.textValue,
      required this.isSelectCountry,
      this.onChange,
      required this.selected,
      required this.groupValue,
      // required this.image
      });
  final String textValue;
  final bool isSelectCountry;
  final String selected;
   String groupValue;
  // final String image;
  final void Function(String?)? onChange;
  @override
  Widget build(BuildContext context) {
    log(selected);
    return Column(
      children: [

        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  // width: 180,
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        textValue,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 14,
                          color: AppColors.textGray
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Theme(
                data:  ThemeData(unselectedWidgetColor: AppColors.textGray),
                child: Radio(

                    value: selected,
                    groupValue: groupValue,
                    onChanged: onChange,
                    activeColor: mainBlueColor ,


                ),
              )
            ],
          ),
        ),

        Divider(
          color: AppColors.textGray,
        )
        ,
      ],
    );
  }
}
