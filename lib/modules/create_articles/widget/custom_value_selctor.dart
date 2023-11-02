import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/Colors.dart';



class CustomValueSelector extends StatelessWidget {
  const CustomValueSelector(
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
  final String groupValue;
  // final String image;
  final void Function(String?)? onChange;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              SizedBox(
                // width: 180,
                child: Center(
                  child: Text(
                    textValue,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Transform.scale(
                scale: 1.5,
                child: Radio(
                    value: selected, groupValue: groupValue, onChanged: onChange),
              )
            ],
          ),

          Divider(
            color: AppColors.gray,
          )
          ,
        ],
      ),
    );
  }
}
