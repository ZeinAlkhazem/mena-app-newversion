import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';



class PdfViewerLayout extends StatelessWidget {
  const PdfViewerLayout({Key? key, this.pdfLink, this.pdfFile})
      : super(key: key);

  final String? pdfFile;
  final String? pdfLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'back',
        ),
      ),
      body: SafeArea(
        child: pdfLink == null
            ? SfPdfViewer.file(File(pdfFile!),canShowPaginationDialog: false)
            : SfPdfViewer.network(pdfLink!, canShowPaginationDialog: false),
      ),
    );
  }
}
