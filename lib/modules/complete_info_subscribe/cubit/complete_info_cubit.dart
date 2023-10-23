import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/network/network_constants.dart';
import 'package:mena/models/api_model/additional_required_data_model.dart';

import '../../../core/cache/cache.dart';
import '../../../core/network/dio_helper.dart';
import 'complete_info_state.dart';

class CompleteInfoCubit extends Cubit<CompleteInfoState> {
  CompleteInfoCubit() : super(CompleteInfoInitial());

  static CompleteInfoCubit get(context) => BlocProvider.of(context);

  /// from api
  AdditionalRequiredDataModel? additionalRequiredDataModel;
  
  List<AdditionalItem> requiredDataList = [
    // AdditionalItem(id: 4, name: 'name', title: 'title', description: 'description', required: '1', extensions: ['pdf'], type: 'string', value: 'value')
  ];

  /// end from api
  Map<String, dynamic> enteredData = {};

  FilePickerResult? selectedFile;
  List<MultipartFile>? file = [];

  Future<void> getAdditionalRequiredFields() async {
    emit(LoadingAdditionalRequiredData());
    await MainDioHelper.getData(
            url: requiredFieldsDataEnd, query: {})
        .then((value) {
      logg('`got required fields` ${value.toString()}');
      // getSelectedVariationDetails(sku);
      additionalRequiredDataModel =
          AdditionalRequiredDataModel.fromJson(value.data);


      logg('dddddddddd ${additionalRequiredDataModel}');

      /// uncomment this
      ///
      ///
      ///
      requiredDataList = additionalRequiredDataModel!.data;
      logg('cart model filled');
      emit(SuccessLoadingAdditionalRequiredData());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorLoadingAdditionalRequiredData());
    });
  }

  Future<String> submitAdditionalRequiredFields() async {
    String responseMsg = '';
    emit(SubmittingAdditionalRequiredData());
    FormData formData;

    logg(enteredData.toString());
    if (enteredData.isNotEmpty) {
      /// map to send
      ///
      Map<String, dynamic> toSendData = {};
      ////
      enteredData.forEach((key, value) {
        toSendData['${key}_input'] = value;
      });
      logg(toSendData.toString());
      formData = FormData.fromMap(toSendData);
      await MainDioHelper.postDataWithFormData(
              url: submitRequiredFieldsDataEnd,
              data: formData)
          .then((value) {
        logg('submit required data done');
        logg(value.toString());
        responseMsg = 'Successfully updated';
        // getSelectedVariationDetails(sku);
        // additionalRequiredDataModel =
        //     AdditionalRequiredDataModel.fromJson(value.data);

        // requiredDataList = additionalRequiredDataModel!.data;
        // logg('cart model filled');
        emit(SuccessLoadingAdditionalRequiredData());
      }).catchError((error) {
        logg('an error occurred');
        logg(error.toString());
        emit(ErrorLoadingAdditionalRequiredData());
        responseMsg = 'an error occurred';
      });
    } else {
      logg('No data entered');
      emit(ErrorLoadingAdditionalRequiredData());
      responseMsg = 'Please re check entered data';
    }
    return responseMsg;
    // return 'Unknown error';
    // formData= FormData.fromMap(
    //
    //
    //
    //     {
    //   'service_on': selectedServiceType,
    //   'full_name': firstName,
    //   'phone': phone,
    //   'email': email,
    //   'location': location,
    //   'kitchen_type': selectedKitchenType!.id,
    //   'floor_type': selectedFloorType!.id,
    //   'surface_type': selectedSurfaceType!.id,
    //   'kitchen_color':  replaceFlutterColorWithHexValue(pickedColor),
    //   'additional_color':  replaceFlutterColorWithHexValue(auxPickedColor),
    //   'length': length,
    //   'width': width,
    //   'height': height,
    //   'images[]': images,
    //   'diagram[]': schematicsImages,
    //
    // });
  }

  ///
  /// completed data should enteredData length
  /// equals to requiredDataList length
  ///
  ///
  Future<void> updateRequiredValue(
      Map<String, dynamic> val, String type) async {
    val.forEach((key, value) {
      if (enteredData.containsKey(key)) {
        logg('entered data contains key $key');
        logg('replacing...$key');
        enteredData.update(key, (currentValue) {
          return type == 'text' ? currentValue = value : currentValue += value;
        });
      } else {
        logg('entered data does\'t contains key $key');
        logg('adding...$key');
        enteredData[key] = value;
      }
    });
    logg('print result: ');
    logg(enteredData.toString());
  }

  ///
  Future<void> removeRequiredValue(String key, dynamic itemIndex) async {
    // List<String> test=[];
    // test.removeAt(index)

    if (itemIndex != null) {
      logg('itemIndex != null');
      logg('removing ${enteredData[key].toString()}');
      enteredData[key].removeAt(itemIndex);
      if (enteredData[key].isEmpty) {
        logg('enteredData[key].isEmpty');
        enteredData.remove(key);
      }
    } else if (enteredData.containsKey(key)) {
      enteredData.remove(key);
    }
    logg('print result: ');
    logg(enteredData.toString());
    emit(AttachmentRemoved());
  }

  selectFile(List<String>? allowedExtensions, String label,String id) async {
    logg('allowed extensions: '+allowedExtensions.toString());
    selectedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      //allowed extension to choose
    );
    if (selectedFile != null) {
      File temp = File(selectedFile!.files.single.path!);
      file = [];
      file!.add(await MultipartFile.fromFile(
        temp.path,
        filename: temp.path.split('/').last,
      ));
      logg('test');
      logg('label: $label');
      logg('id: $id');
      updateRequiredValue({id: file}, 'file');
    } else {
      // User canceled the picker
    }
    emit(AttachmentPicked());
  }

  ///
  FormData dataToSend() {
    FormData data;

    /// job apply
    data = FormData.fromMap({
      'name': '',
      'email': 'email',
      'phone': 'phone',
      'job_id': 'jobId',
      "cv": file
    });
    logg('data to send: $data');
    return data;
  }
}
