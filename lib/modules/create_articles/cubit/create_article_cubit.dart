import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/core/constants/app_toasts.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:mena/models/api_model/blogs_info_model.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/network/dio_helper.dart';
import 'package:mena/core/network/network_constants.dart';
part 'create_article_state.dart';

class CreateArticleCubit extends Cubit<CreateArticleState> {
  CreateArticleCubit() : super(CreateArticleInitial());
  static CreateArticleCubit get(context) => BlocProvider.of(context);

  GlobalKey formKey = GlobalKey<FormState>();

  final QuillEditorController controller = QuillEditorController();
  String imagePath = '';
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  GlobalKey<FlutterSummernoteState> keyEditor = GlobalKey();
  String? selectedCategory;
  String selectedItem = '';
  String categoryId = '';

  AutovalidateMode? autoValidateMode = AutovalidateMode.disabled;
  void toggleAutoValidate(bool val) {
    if (val == true) {
      autoValidateMode = AutovalidateMode.always;
    } else {
      autoValidateMode = AutovalidateMode.disabled;
    }
    emit(ChangeAutoValidateModeState());
  }

  void setCategory(String selectedCategory) {
    selectedItem = selectedCategory;
  }

  void deleteImage() {
    imagePath == '';
    emit(ImageDelete());
  }

  FilePickerResult? res;
  pickFile(
    context,
  ) async {
    res = await FilePicker.platform.pickFiles(type: FileType.image);

    if (res != null) {
      imagePath = res!.files.first.path!;
      emit(ImageUploaded());
    }
  }

  pickFromCamera(
    context,
  ) async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
// final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// // Capture a photo.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    // if (image != null) {
    //   imagePath = image.path;
    //   emit(ImageUploaded());
    // }

    if (photo != null) {
      imagePath = photo.path;
      emit(ImageUploaded());
    }
        Navigator.pop(context);
  }

  pickFromGallery(
    context,
  ) async {
    final ImagePicker picker = ImagePicker();
//Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      imagePath = image.path;
      emit(ImageUploaded());
    }
    Navigator.pop(context);
  }

  BlogsInfoModel? blogsInfoModel;

  Future<void> getBlogsInfo({String? providerId}) async {
    // feedsModel = null;
    if (state is! GettingArticleInfoState) {
      emit(GettingArticleInfoState());
      ////
      Map<String, String?> toSendData = {
        'limit': '15',
        'offset': '1',
      };

      if (providerId != null) {
        toSendData['provider_id'] = '${providerId}';
      }

      logg('to send data: ${toSendData}');
      await MainDioHelper.getData(
        url: getBlogsInfoEnd,
        query: {},
      ).then((value) {
        logg('Blogs info fetched...');
        logg(value.toString());
        // var response = FeedsModel.fromJson(value.data);
        // loginModel = response.data!;
        blogsInfoModel = BlogsInfoModel.fromJson(value.data);
        logg('blogs info filled');
        emit(SuccessGettingArticleState());
      }).catchError((error, stack) {
        logg('an error occurred...');
        logg('an error occurred: ' + error.toString());
        logg('an error occurred: ' + stack.toString());
        emit(ErrorGettingArticleState());
      });
    }
  }

  Future<void> publishArticle(
    BuildContext context,
  ) async {
    emit(ArticleLoadingState());

    Map<String, dynamic> toSendData = {
      // 'banner': imagePath,
      'title': title.text,
      'content': content.text,
      'category_id': categoryId,
    };

    File temp = File(imagePath);
    toSendData['banner'] = await MultipartFile.fromFile(
      temp.path,
      filename: temp.path.split('/').last,
    );

    FormData formData = FormData.fromMap(toSendData);
    MainDioHelper.postDataWithFormData(url: publishArticleEnd, data: formData)
        .then((value) async {
      // logg('publish article response: $value');

      logg('publish article response: ');
      Navigator.pop(context);
      AppToasts.errorToast('Your article has been published successfully');
      emit(SuccessGettingArticleState());
    }).catchError((error) {
      logg(error.response.toString());

      emit(ArticleErrorState(getErrorMessageFromErrorJsonResponse(error)));
    });
  }

  bool checkValidation() {
    if (imagePath.isEmpty) {
      AppToasts.errorToast("please upload article header cover");
      return false;
    }
    if (categoryId == '') {
      AppToasts.errorToast("please choose article category");
      return false;
    }
    return true;
  }
}
