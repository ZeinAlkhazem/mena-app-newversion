import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html_editor_enhanced/utils/utils.dart';
import 'package:mena/core/constants/Colors.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/create_articles/cubit/create_article_cubit.dart';
import 'package:mena/modules/create_articles/widget/article_input_field.dart';
import 'package:mena/modules/create_articles/widget/create_article_privacy_text.dart';
import 'package:mena/modules/create_articles/widget/select_blog_category_drop_down.dart';
import 'package:mena/modules/create_articles/widget/underline_input_widget.dart';
import 'package:mena/modules/create_articles/widget/upload_cover_picker.dart';

import '../../core/shared_widgets/shared_widgets.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  static String routeName = '/editor_screen';

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
  Widget build(BuildContext context) {
    var createArticleCubit = CreateArticleCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon:Image.asset('assets/icons/save.png'),
      //       onPressed: () async {
      //         createArticleCubit.content.text =
      //             await createArticleCubit.keyEditor.currentState!.getText();
      //        createArticleCubit.content.text =
      //             await createArticleCubit.keyEditor.currentState!.getText();
      //                createArticleCubit.content.text =
      //             await createArticleCubit.keyEditor.currentState!.getText();
      //       Navigator.pop(context);
      //         logg(createArticleCubit.content.text);
      //       },
      //     )
      //   ],
      // ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child:

          Icon(
            Icons.arrow_back,
            color: AppColors.lineBlue,
            size: 28,
          ),
          // SvgPicture.asset(
          //   'assets/svg/back_icon.svg',
          //   color: mainBlueColor,
          // ),
        ),
        title: Text(
          "Create Article",

          style: mainStyle(context, 23,
                color: Color(0xff444444), weight: FontWeight.w700 )
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: ()async {
              createArticleCubit.content.text =
                  await createArticleCubit.keyEditor.currentState!.getText();
              createArticleCubit.content.text =
                  await createArticleCubit.keyEditor.currentState!.getText();
              createArticleCubit.content.text =
                  await createArticleCubit.keyEditor.currentState!.getText();

              Navigator.pop(context);
              setState(mounted, (p0) { }, () { });
              logg(createArticleCubit.content.text);
            },
            icon: SvgPicture.asset(
              'assets/svg/icons/correct.svg',
              height: 25,
              color: Colors.blue,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: FlutterSummernote(
          hint: createArticleCubit.content.text.isEmpty
              ? 'Start creating your article...'
              : '',
          key: createArticleCubit.keyEditor,
          hasAttachment: true,
          value: createArticleCubit.content.text,
          customToolbar: """
          [
            ['style', ['bold', 'italic', 'underline',]],
            
            ['insert', ['link',]]
          ]
        """,
        ),
      ),
    );
  }
}
