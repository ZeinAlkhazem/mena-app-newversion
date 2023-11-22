import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'select_scanner_button.dart';

void selectScannerMode(
  BuildContext context,
) {
  showModalBottomSheet(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.38,
        maxChildSize: 0.4,
        minChildSize: 0.28,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                  // color: Colors.grey.shade300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(children: [
                    Container(
                      width: 40,
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.5),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SelectScanner(icon: Icons.barcode_reader,
                      textLabel: 'Scan Barcode',
                      ontap: () async {
                        await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666", "Cancel", true, ScanMode.BARCODE);
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Center(
                      child: Text(
                        'OR',
                        style: TextStyle(fontSize: 12, fontFamily: "LatoBold"),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SelectScanner(icon: Icons.qr_code,
                      textLabel: 'Scan QRcode',
                      ontap: () async {
                        await FlutterBarcodeScanner.scanBarcode(
                            "#ff6666", "Cancel", true, ScanMode.QR);
                      },
                    ),
                  ])));
        }),
  );
}
