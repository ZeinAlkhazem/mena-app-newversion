import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/modules/feeds_screen/blogs/my_blog.dart';
import 'package:mena/modules/feeds_screen/my_blog/my_blog.dart';
import 'package:meta/meta.dart';

import '../../../core/cache/cache.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';
import '../../../models/local_models.dart';
import '../../feeds_screen/feeds_screen.dart';
import '../../messenger/messenger_layout.dart';
import '../edit_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  bool isCurrentlyPursuing = false;
  XFile? attachedFile;
  MultipartFile? attachedCertificateFile;

  int aboutLength = 0;

  String? selectedSourceType;

  void updateAboutLength(val) {
    aboutLength = val;
    emit(UpdateState());
  }

  void updateSelectedSourceType(val) {
    selectedSourceType = val;
    emit(UpdateState());
  }

  void updateAttachedFile(XFile? file) {
    // resetAttachedFile();
    attachedFile = file;
    logg('attached files: ${attachedFile}');
    emit(AttachedFilesUpdated());
  }

  void updateCertificateFile(MultipartFile? file) {
    attachedCertificateFile = file;
    emit(AttachedFilesUpdated());
  }

  List<ItemWithTitleAndCallback> userProfileButtons(BuildContext context) {
    List<ItemWithTitleAndCallback> list = [];
    if (MainCubit.get(context).isUserProvider()) {
      list = [
        ItemWithTitleAndCallback(
          title: 'Edit Profile',
          thumbnailLink: 'assets/svg/icons/profile/edit profile.svg',
          count: '0',
          onClickCallback: () {
            navigateTo(
                context,
                UserProfileEditLayout(
                  user: MainCubit.get(context).userInfoModel!.data.user,
                ));
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Video Call',
          thumbnailLink: 'assets/svg/icons/profile/my video talks.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My messenger',
          thumbnailLink: 'assets/svg/icons/profile/messanger.svg',
          count:  MainCubit.get(context).countersModel == null
              ? '0'
              : MainCubit.get(context).countersModel!.data.messages.toString(),
          onClickCallback: () {
            getCachedToken() == null
                ? viewMessengerLoginAlertDialog(context)
                : navigateToWithoutNavBar(context, const MessengerLayout(), '');
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Manage Appointment',
          thumbnailLink: 'assets/svg/icons/profile/manage appointment.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My Feeds',
          thumbnailLink: 'assets/svg/icons/profile/my feeds.svg',
          count: '0',
          onClickCallback: () {
            var mainCubit = MainCubit.get(context);
            return navigateTo(
                context,
                FeedsScreen(
                  user: mainCubit.userInfoModel!.data.user,
                  providerId: mainCubit.userInfoModel!.data.user.id.toString(),
                  isMyFeeds: true,
                ));
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Groups and Channel',
          thumbnailLink: 'assets/svg/icons/profile/groups and channel.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'Manage Experts',
          thumbnailLink: 'assets/svg/icons/profile/manage experts.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My blog',
          thumbnailLink: 'assets/svg/icons/profile/my blog.svg',
          count: '0',
          onClickCallback: () {

            navigateToWithoutNavBar(context, MyBlogPage( isMyBlog: true), 'routeName');
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Events and webinars',
          thumbnailLink: 'assets/svg/icons/profile/event and webinars.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My Marketplace',
          thumbnailLink: 'assets/svg/icons/profile/my marketplace.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'Clients Documents',
          thumbnailLink: 'assets/svg/icons/profile/client documnets.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My video talks',
          thumbnailLink: 'assets/svg/icons/profile/my video talks.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My Vacancies',
          thumbnailLink: 'assets/svg/icons/profile/my vacancies.svg',
          count: '4',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'Education',
          thumbnailLink: 'assets/svg/icons/profile/education_profile.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'B2B',
          thumbnailLink: 'assets/svg/icons/profile/groups and channel.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'Mena help centre',
          thumbnailLink: 'assets/svg/icons/mena.svg',
          count: '0',
          onClickCallback: () {},
        ),
        // ItemWithTitleAndCallback(title: 'tr', thumbnailSvgLink: '', count: '1', onClickCallback: () {}),
      ];
    } else {
      list = [
        ItemWithTitleAndCallback(
          title: 'Edit Profile',
          thumbnailLink: 'assets/svg/icons/profile/edit profile.svg',
          count: '0',
          onClickCallback: () {
            navigateTo(
                context,
                UserProfileEditLayout(
                  user: MainCubit.get(context).userInfoModel!.data.user,
                ));
          },
        ),
        ItemWithTitleAndCallback(
          title: 'Video Call',
          thumbnailLink: 'assets/svg/icons/profile/my video talks.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My messenger',
          thumbnailLink: 'assets/svg/icons/profile/messanger.svg',
          count: '9',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'Manage Appointment',
          thumbnailLink: 'assets/svg/icons/profile/manage appointment.svg',
          count: '0',
          onClickCallback: () {},
        ),

        ItemWithTitleAndCallback(
          title: 'My followings',
          thumbnailLink: 'assets/svg/icons/profile/followers.svg',
          count: '0',
          onClickCallback: () {},
        ),

        ItemWithTitleAndCallback(
          title: 'Groups and Channel',
          thumbnailLink: 'assets/svg/icons/profile/groups and channel.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'Q & A',
          thumbnailLink: 'assets/svg/icons/profile/ask professionals.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My Job applications',
          thumbnailLink: 'assets/svg/icons/profile/my blog.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'Events and webinars',
          thumbnailLink: 'assets/svg/icons/profile/event and webinars.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My Purchases',
          thumbnailLink: 'assets/svg/icons/profile/my marketplace.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'My medical records',
          thumbnailLink: 'assets/svg/icons/profile/client documnets.svg',
          count: '0',
          onClickCallback: () {},
        ),
        ItemWithTitleAndCallback(
          title: 'Family members',
          thumbnailLink: 'assets/svg/icons/profile/family.svg',
          count: '0',
          onClickCallback: () {},
        ),
        // ItemWithTitleAndCallback(
        //   title: 'My Vacancies',
        //   thumbnailSvgLink: 'assets/svg/icons/profile/my vacancies.svg',
        //   count: '4',
        //   onClickCallback: () {},
        // ),
        ItemWithTitleAndCallback(
          title: 'Education',
          thumbnailLink: 'assets/svg/icons/profile/education_profile.svg',
          count: '0',
          onClickCallback: () {},
        ),
        // ItemWithTitleAndCallback(
        //   title: 'B2B',
        //   thumbnailSvgLink: 'assets/svg/icons/profile/groups and channel.svg',
        //   count: '0',
        //   onClickCallback: () {},
        // ),
        ItemWithTitleAndCallback(
          title: 'Mena help centre',
          thumbnailLink: 'assets/svg/icons/mena.svg',
          count: '0',
          onClickCallback: () {},
        ),
        // ItemWithTitleAndCallback(title: 'tr', thumbnailSvgLink: '', count: '1', onClickCallback: () {}),
      ];
    }
    return list;
  }

  bool isSettingExpanded = false;

  void changeCurrentlyPursuingVal(bool val) {
    isCurrentlyPursuing = val;
    emit(UpdateState());
  }

  void updateCubit() {
    emit(UpdateState());
  }

  void toggleSettingExpanded({bool? customVal}) {
    if (customVal != null) {
      isSettingExpanded = customVal;
    } else {
      isSettingExpanded = !isSettingExpanded;
    }

    emit(UpdateState());
  }

  Future<void> saveCme({
    required String entityTitle,
    required String accreditedBy,
    required String points,
    required String startingYear,
    required String endingYear,
    // String? customId,

    /// in edit only
    // bool isUpdateNotAdd = false,
  }) async {
    emit(UpdatingDataState());

    FormData formData;
    Map<String, dynamic> toSendData = {};

    toSendData = {
      'title': entityTitle,
      'cme_accredited_by': accreditedBy,
      'points': points,
      'start_year': startingYear,
      'end_year': endingYear,
      'source_type': selectedSourceType,
    };
    if (attachedCertificateFile != null) {
      toSendData['certificate'] = attachedCertificateFile;
    }

    formData = FormData.fromMap(toSendData);
    // if (customId != null) {
    //   toSendData['id'] = customId;
    // }
    await MainDioHelper.postDataWithFormData(
      url: addCmeEnd,
      data: formData,
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg('error: ' + error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> saveEducation({
    required String nameOfUn,
    required String degree,
    required String startYear,
    required String endingYear,
    String? customId,

    /// in edit only
    bool isUpdateNotAdd = false,
  }) async {
    emit(UpdatingDataState());

    var toSendData = {
      'university_name': nameOfUn,
      'degree': degree,
      'starting_year': startYear,
      'ending_year': endingYear,
      'currently_pursuing': isCurrentlyPursuing ? '1' : '0',
    };
    if (customId != null) {
      toSendData['id'] = customId;
    }
    await MainDioHelper.postData(
      url: isUpdateNotAdd ? updateProviderEducationEnd : addProviderEducationEnd,
      query: toSendData,
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> updateProfilePic() async {
    emit(UpdatingPictureState());
    FormData formData;

    MultipartFile file = await MultipartFile.fromFile(
      attachedFile!.path,
      filename: attachedFile!.path.split('/').last,
    );
    Map<String, dynamic> toSendData = {
      'personal_picture': file,
    };

    formData = FormData.fromMap(toSendData);

    await MainDioHelper.postDataWithFormData(url: addUserProfilePicEnd, data: formData).then((value) {
      logg('Msg sent');
      logg(value.toString());
      emit(SuccessUpdatingPictureState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingPictureState());
    });
  }

  Future<void> saveExperience({
    required String position,
    required String company,
    required String startYear,
    required String endingYear,
    String? customId,

    /// in edit only
    bool isUpdateNotAdd = false,
  }) async {
    emit(UpdatingDataState());

    var toSendData = {
      'place_of_work': position,
      'designation': company,
      'starting_year': startYear,
      'ending_year': endingYear,
      'currently_working': isCurrentlyPursuing ? '1' : '0',
    };
    if (customId != null) {
      toSendData['id'] = customId;
    }
    await MainDioHelper.postData(
      url: isUpdateNotAdd ? updateProviderExperienceEnd : addProviderExperienceEnd,
      query: toSendData,
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> savePublication({
    required String paperTitle,
    required String summary,
    required String publisher,
    required String publishedUrl,
    required String publishedDate,
    String? customId,

    /// in edit only
    bool isUpdateNotAdd = false,
  }) async {
    emit(UpdatingDataState());

    var toSendData = {
      'paper_title': paperTitle,
      'summary': summary,
      'publisher': publisher,
      'published_url': publishedUrl,
      'published_date': publishedDate,
    };
    if (customId != null) {
      toSendData['id'] = customId;
    }
    await MainDioHelper.postData(
      url: isUpdateNotAdd ? updateProviderPublicationsEnd : addProviderPublicationsEnd,
      query: toSendData,
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> saveCertificate({
    required String name,
    required String issueDate,
    String? customId,

    /// in edit only
    bool isUpdateNotAdd = false,
  }) async {
    emit(UpdatingDataState());

    var toSendData = {
      'certificate_name': name,
      'issue_date': issueDate,
    };
    if (customId != null) {
      toSendData['id'] = customId;
    }
    await MainDioHelper.postData(
      url: isUpdateNotAdd ? updateProviderCertificationEnd : addProviderCertificationsEnd,
      query: toSendData,
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> saveMembership({
    required String name,
    required String authName,
    String? customId,

    /// in edit only
    bool isUpdateNotAdd = false,
  }) async {
    emit(UpdatingDataState());

    var toSendData = {
      'name': name,
      'authority_name': authName,
    };
    if (customId != null) {
      toSendData['id'] = customId;
    }
    await MainDioHelper.postData(
      url: isUpdateNotAdd ? updateProviderMembershipEnd : addProviderMembershipEnd,
      query: toSendData,
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> saveReward({
    required String name,
    required String year,
    String? customId,

    /// in edit only
    bool isUpdateNotAdd = false,
  }) async {
    emit(UpdatingDataState());

    var toSendData = {
      'title': name,
      'year': year,
    };
    if (customId != null) {
      toSendData['id'] = customId;
    }
    await MainDioHelper.postData(
      url: isUpdateNotAdd ? updateProviderRewardEnd : addProviderRewardEnd,
      query: toSendData,
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> saveAbout({
    required String aboutCont,
    String? customId,

    /// in edit only
    bool isUpdateNotAdd = false,
  }) async {
    emit(UpdatingDataState());
    await MainDioHelper.postData(
      url: updateAboutEnd,
      query: {
        'about': aboutCont,
        // 'degree': degree,
        // 'starting_year': startYear,
        // 'ending_year': endingYear,
        // 'id': customId,
        // 'currently_pursuing': isCurrentlyPursuing ? '1' : '0',
      },
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> removeEducation(String id) async {
    emit(UpdatingDataState());
    await MainDioHelper.postData(
      url: deleteProviderEducationEnd,
      query: {
        'id': id,
      },
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> removeCertificate(String id) async {
    emit(UpdatingDataState());
    await MainDioHelper.postData(
      url: deleteProviderCertificateEnd,
      query: {
        'id': id,
      },
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> removeMembership(String id) async {
    emit(UpdatingDataState());
    await MainDioHelper.postData(
      url: deleteProviderMembershipEnd,
      query: {
        'id': id,
      },
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> removeReward(String id) async {
    emit(UpdatingDataState());
    await MainDioHelper.postData(
      url: deleteProviderRewardEnd,
      query: {
        'id': id,
      },
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> removeExperience(String id) async {
    emit(UpdatingDataState());
    await MainDioHelper.postData(
      url: deleteProviderExperienceEnd,
      query: {
        'id': id,
      },
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }

  Future<void> removePublication(String id) async {
    emit(UpdatingDataState());
    await MainDioHelper.postData(
      url: deleteProviderPublicationEnd,
      query: {
        'id': id,
      },
    ).then((value) {
      logg('success...');
      logg(value.toString());
      emit(SuccessUpdatingDataState());
    }).catchError((error, stack) {
      logg('an error occurred');
      logg(error.response.toString());
      logg('stack: ' + stack.toString());
      emit(ErrorUpdatingDataState());
    });
  }
}
