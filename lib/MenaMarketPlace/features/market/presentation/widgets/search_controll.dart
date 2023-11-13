import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../../../../core/constants/Colors.dart';
import 'search_box.dart';

class SearchControll extends StatelessWidget {
  const SearchControll({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () async {
            await FlutterBarcodeScanner.scanBarcode(
                "#ff6666", "Cancel", false, ScanMode.QR);
          },
          child: SvgPicture.asset(
            "assets/menamarket/qr_code_outline_28.svg",
            color: AppColors.whiteCreamColor,
          ),
        ),
        widthBox(8.w),
        Flexible(child: SearchBox()),
        widthBox(8.w),
         SvgPicture.asset(
          "assets/menamarket/menu_28.svg",
          color: AppColors.whiteCreamColor,
        ),
      ],
    );
  }
}
