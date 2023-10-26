import 'package:flutter/material.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
class SelectBlogCategoryDropDown extends StatelessWidget {
  const SelectBlogCategoryDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 35,
          padding: EdgeInsetsDirectional.only(start: 20,end: 10),
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 2),

          child: Center(
            child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                iconSize: 25,
                icon: Center(
                  child: Image.asset('assets/addedbyzein/arrow.png',height: 20,),
                ),
                hint: Text('Select Blog Category',
                    style:mainStyle(context, 14,
                        color: newDarkGreyColor, weight: FontWeight.w700)),
                borderRadius: BorderRadius.circular(10),
                elevation: 0,
                items: [].map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width: 80,
                      child: Text(value,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                              overflow: TextOverflow.fade,
                              color: newDarkGreyColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w300)),
                    ),
                  );
                }).toList(),
                onChanged: (val) {}),
          ),
        ),
        SizedBox(height: 5,),
        Divider(height: 1,thickness: .5,color: newDarkGreyColor,)
      ],
    );
  }
}
