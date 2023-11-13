// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryPickerDrop extends StatelessWidget {
  final void Function(Country) onValuePicked;
  const CountryPickerDrop({
    Key? key,
    required this.onValuePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CountryPickerDropdown(
      icon: SizedBox(),
      selectedItemBuilder: (country) => Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        child: CountryPickerUtils.getDefaultFlagImage(country),
      ),
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      initialValue: 'AE',
      itemBuilder: (country) => FittedBox(
        child: Row(
          children: [
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.w,
            ),
            Text(
              country.isoCode,
              textDirection: TextDirection.ltr,
              style: Theme.of(context).primaryTextTheme.bodySmall!.copyWith(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
      sortComparator: (a, b) => a.phoneCode.compareTo(b.phoneCode),
      itemFilter: (country) => country.isoCode != "IL",
      // itemFilter: (c) => [
      //   'SY',
      //   'EG',
      //   'SA',
      //   'BR',
      //   'CA',
      //   'CN',
      //   'FR',
      //   'DE',
      //   'IQ',
      //   'IN',
      //   'IT',
      //   'JO',
      //   'KW',
      //   'LB',
      //   'LY',
      //   'MA',
      //   'NL',
      //   'OM',
      //   'PS',
      //   'QA',
      //   'RU',
      //   'SD',
      //   'TN',
      //   'AE',
      //   'YE',
      //   'GB'
      // ].contains(c.isoCode),

      onValuePicked: onValuePicked,
    );
  }
}
