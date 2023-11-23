// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:mena/core/constants/app_toasts.dart';

import 'QRscannerOverlay.dart';

class Scanner extends StatefulWidget {
  final bool isBarcode;
  const Scanner({
    Key? key,
    required this.isBarcode,
  }) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black.withOpacity(0.5),
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          backgroundColor: Colors.transparent,
          title: Text(
            '${widget.isBarcode ? "Barcode" : "QRcode"} Search',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0.03,
            ),
          ),
          actions: [
            InkWell(
              child: ValueListenableBuilder(
                valueListenable: scannerController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(
                        Icons.camera_front,
                        color: Colors.white,
                      );
                    case CameraFacing.back:
                      return const Icon(
                        Icons.camera_rear,
                        color: Colors.white,
                      );
                  }
                },
              ),
              onTap: () => scannerController.switchCamera(),
            ),
          ],
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: scannerController,
              onDetect: _foundBarcode,
            ),
            QRScannerOverlay(
              overlayColour: Colors.black.withOpacity(0.5),
              isBarcode: widget.isBarcode,
            ),
            Positioned(
              top: 100,
              left: 30,
              child: IconButton(
                color: Colors.white,
                icon: ValueListenableBuilder(
                  valueListenable: scannerController.torchState,
                  builder: (context, state, child) {
                    switch (state as TorchState) {
                      case TorchState.off:
                        return const Icon(Icons.flash_off, color: Colors.grey);
                      case TorchState.on:
                        return const Icon(Icons.flash_on, color: Colors.yellow);
                    }
                  },
                ),
                iconSize: 32.0,
                onPressed: () => scannerController.toggleTorch(),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: EdgeInsets.all(10.w),
                    margin: EdgeInsets.only(bottom: 30.h),
                    width: 242.w,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFAD6C48),
                            blurRadius: 107,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Ready to Scan',
                          style: TextStyle(
                            color: Color(0xFF494949),
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.45,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Ensure ${widget.isBarcode ? "Barcode" : "QRcode"} withen \nscanner to scan an item',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF494949),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                            letterSpacing: 0.36,
                          ),
                        ),
                      ],
                    )))
          ],
        ));
  }

  void _foundBarcode(
    BarcodeCapture capture,
  ) {
    final List<Barcode> barcodes = capture.barcodes;
    String? code = '';
    final Uint8List? image = capture.image;

    for (final barcode in barcodes) {
      code = barcode.rawValue;

      if (code!.isNotEmpty) {
        AppToasts.successToast(code);
        break;
      }
      ;
    }

    if (image != null) {
      showDialog(
        context: context,
        builder: (context) => Image(image: MemoryImage(image)),
      );
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pop(context);
      });
    }
  }
}
