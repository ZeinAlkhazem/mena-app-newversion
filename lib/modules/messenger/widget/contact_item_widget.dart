import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';

class ContactItemWidget extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback btnInvite;

  const ContactItemWidget({
    super.key,
    required this.name,
    required this.phone,
    required this.btnInvite,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundColor: AppColors.lineGray,
          child: Icon(Icons.person,color: Colors.white,),),
      title: Text(
        name,
        style: mainStyle(context, 12.sp,
            fontFamily: AppFonts.openSansFont,
            color: Colors.black,
            weight: FontWeight.w700),
      ),
      subtitle: Text(
        phone,
        style: mainStyle(context, 12.sp,
            fontFamily: AppFonts.openSansFont,
            color: Colors.black,
            weight: FontWeight.w400),
      ),
      trailing: TextButton(
        onPressed: btnInvite,
        child: Text(
          getTranslatedStrings(context).messengerInvite,
          style: mainStyle(context, 12.sp,
              fontFamily: AppFonts.openSansFont,
              color: AppColors.lineBlue,
              weight: FontWeight.w700),
        ),
      ),
    );
  }
}
