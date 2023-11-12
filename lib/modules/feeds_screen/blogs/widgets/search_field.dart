import 'package:flutter/material.dart';

import 'package:mena/core/constants/Colors.dart';

import 'custom_form_field.dart';



class FilterField extends StatelessWidget {
  const FilterField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15,bottom: 5),
      child: InkWell(
        onTap: (){
          // Get.toNamed(FiltersPage.routeName);
        },
        child: SizedBox(
          height: 45,
          child:

          TextFormField(
          readOnly: true,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade100,
                filled: true,
                hintText: "Search for Chats and Friends",
                hintStyle: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: AppColors.textGray ,fontSize: 15),
              focusedBorder:  OutlineInputBorder(
                borderRadius:
                const BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide.none,
              ) ,
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                const BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide.none,
              ) ,
              prefixIcon:Icon(Icons.search ,color: AppColors.textGray,size: 25,) ,
              suffixIcon: Icon(Icons.keyboard_voice_outlined ,color: AppColors.textGray,size: 25,),
            ),


          ),


      ),
      )
    );
  }
}
