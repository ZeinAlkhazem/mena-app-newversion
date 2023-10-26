import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/create_articles/cubit/create_article_cubit.dart';
import 'package:mena/modules/create_articles/widget/article_input_field.dart';
import 'package:mena/modules/create_articles/widget/create_article_privacy_text.dart';
import 'package:mena/modules/create_articles/widget/select_blog_category_drop_down.dart';
import 'package:mena/modules/create_articles/widget/underline_input_widget.dart';
import 'package:mena/modules/create_articles/widget/upload_cover_picker.dart';

import '../../core/shared_widgets/shared_widgets.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  static String routeName = '/editor_screen';

  @override
  Widget build(BuildContext context) {
    var createArticleCubit = CreateArticleCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [ IconButton(
          icon: Icon(Icons.save,color: mainBlueColor,),
          onPressed: () async {
            createArticleCubit.content.text= await createArticleCubit.keyEditor.currentState?.getText()??'';
            Navigator.pop(context);
          },
        )],

      ),
      body: SafeArea(
        child: FlutterSummernote(
          hint: 'Start creating your article...',

          key: createArticleCubit.keyEditor,
          hasAttachment: true,
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
