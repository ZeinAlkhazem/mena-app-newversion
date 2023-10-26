import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:meta/meta.dart';

part 'create_article_state.dart';

class CreateArticleCubit extends Cubit<CreateArticleState> {
  CreateArticleCubit() : super(CreateArticleInitial());
  static CreateArticleCubit get(context) => BlocProvider.of(context);

  GlobalKey formKey = GlobalKey<FormState>();
  GlobalKey<FlutterSummernoteState> keyEditor = GlobalKey();
  String imagePath = '';
  TextEditingController title=TextEditingController();
  TextEditingController content=TextEditingController();
  pickFile(
      context,
      ) async {
    FilePickerResult? res =
    await FilePicker.platform.pickFiles(type: FileType.image);

    if (res != null) {
      imagePath = res.files.first.path!;
      emit(ImageUploaded());
    }
  }

}
