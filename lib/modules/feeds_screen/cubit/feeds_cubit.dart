import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mena/models/api_model/blogs_items_model.dart';
import 'package:mena/models/api_model/comments_model.dart';
import 'package:mena/models/api_model/like_comment_model.dart';
import 'package:mena/models/api_model/my_blog_info_model.dart';

import 'package:mena/modules/feeds_screen/my_blog/cubit/myBlog_cubit.dart';
import 'package:mena/modules/feeds_screen/my_blog/cubit/myBlog_state.dart';

import 'package:meta/meta.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../core/main_cubit/main_cubit.dart';
import '../../../core/network/dio_helper.dart';
import '../../../core/network/network_constants.dart';
import '../../../models/api_model/blogs_info_model.dart';
import '../../../models/api_model/comment_response_feed.dart';
import '../../../models/api_model/feeds_model.dart';
import '../../../models/api_model/home_section_model.dart';

import '../../../models/api_model/share_model.dart';
import '../../home_screen/cubit/home_screen_cubit.dart';

part 'feeds_state.dart';
import 'package:mena/models/local_models.dart';
import 'package:mena/modules/feeds_screen/post_a_feed.dart';
import '../../create_articles/create_article_screen.dart';

class FeedsCubit extends Cubit<FeedsState> {
  List<MenaFeed> menaFeedsList = [];
  List<MenaArticle> menablogsList = [];
  List<MenaFeed> menaProviderFeedsList = [];
  List<MenaFeed> feedsVideosList = [];

  int feedsVideosListOffset = 1;
  int menaFeedsListOffset = 1;
  int menaProviderFeedsListOffset = 1;
  Map<int, String> selectedSubs = {};
  int selectedSub = -1;
  bool isChangeIcon = false;

  bool isFollow = false;
  FeedsCubit() : super(FeedsInitial());

  static FeedsCubit get(context) => BlocProvider.of(context);

  FeedsModel? feedsModel;
  FeedsModel? feedsVideosModel;

  BlogsInfoModel? blogsInfoModel;
  MyBlogInfoModel? myBlogInfoModel;
  MenaArticle? menaArticleDetails;
  BlogsItemsModel? blogsItemsModel;
  CommentsModel? commentsModel;
  String currentAudience = 'Public';

  List currentVideoPlaylist = ['1', '2'];

  PickedLocationModel? pickedFeedLocation = null;

  bool preferredMuteVal = false;
  List<XFile> attachedFiles = [];
  List<XFile> attachedReportFiles = [];
  List<dynamic> files = [];
  List<dynamic> reportFiles = [];
  int categoryId = 0;
  List categories = ["Feeds", "Clips", "Videos", "News"];
  List<StoryItem> stories = [];
  List<ItemWithTitleAndCallback> userActionItems(BuildContext context) {
    List<ItemWithTitleAndCallback> list = [];

    list = [
      ItemWithTitleAndCallback(
        title: 'Create Story',
        thumbnailLink: 'assets/icons/story_add_outline_28 1.svg',
        onClickCallback: () {
          logg('dshjfjkh');
          // navigateToWithoutNavBar(context, PostAFeedLayout(), 'routeName');
        },
      ),
      ItemWithTitleAndCallback(
        title: 'Create Post',
        thumbnailLink: 'assets/icons/write_square_outline_28 1.svg',
        onClickCallback: () {
          logg('dshjfjkh');
          navigateToWithoutNavBar(context, PostAFeedLayout(), 'routeName');
        },
      ),
      ItemWithTitleAndCallback(
        title: 'Record Clips',
        thumbnailLink: 'assets/icons/video_add_square_outline_28 1.svg',
        onClickCallback: () {
          logg('create article');

          navigateToWithoutNavBar(context, CreateArticleScreen(), 'routeName');
        },
      ),
      ItemWithTitleAndCallback(
        title: 'Upload Videos',
        thumbnailLink: 'assets/icons/videocam_add_outline_24 1.svg',
        onClickCallback: () {
          logg('dshjfjkh');
        },
      ),
      ItemWithTitleAndCallback(
        title: 'Publish news',
        thumbnailLink: 'assets/icons/newsfeed_outline_24 1.svg',
        onClickCallback: () {
          logg('dshjfjkh');
        },
      ),
    ];

    return list;
  }

  void updateAttachedFile(XFile? xFile, {List<XFile>? xFiles}) {
    if (xFiles != null) {
      xFiles.forEach((element) {
        attachedFiles.add(element);
      });
    } else {
      if (xFile != null) {
        attachedFiles.add(xFile);
      }
    }

    emit(FeedUpdated());
  }

  void updateReportAttachedFile(XFile? xFile, {List<XFile>? xFiles}) {
    if (xFiles != null) {
      xFiles.forEach((element) {
        attachedReportFiles.add(element);
      });
    } else {
      if (xFile != null) {
        attachedReportFiles.add(xFile);
      }
    }

    emit(FeedUpdated());
  }

  void resetFeedModel() {
    feedsModel = null;
    menaFeedsList.clear();
    menaFeedsListOffset = 1;
    emit(FeedUpdated());
  }

  void resetFeedProviderModel() {
    feedsModel = null;
    menaProviderFeedsList.clear();
    menaProviderFeedsListOffset = 1;
    emit(FeedUpdated());
  }

  void resetFeedVideosModel() {
    feedsVideosModel = null;
    feedsVideosList.clear();
    feedsVideosListOffset = 1;
    emit(FeedUpdated());
  }

  void resetAttachedFiles() {
    attachedFiles = [];
    emit(FeedUpdated());
  }

  void updatePreferredMuteVal(bool val) {
    preferredMuteVal = val;
    emit(FeedUpdated());
  }

  Future<void> fillFiles(List<XFile> attachedFiles) async {
    files = [];
    if (attachedFiles.isNotEmpty) {
      logg('attachedFiles not empty');
      for (var i in attachedFiles) {
        if (i.path.split('/').last == 'pdf') {
          files.add(i);
        } else {
          files.add(await MultipartFile.fromFile(
            i.path,
            filename: i.path.split('/').last,
          ));
        }
      }
      // attachedFiles.forEach((e) async {
      //   files.add(await MultipartFile.fromFile(
      //     e.path,
      //     filename: e.path.split('/').last,
      //   ).catchError((e){
      //     logg('error: '+e.toString());
      //   }));
      // });
      // attachedFiles.map((e) async {
      //   files.add(await MultipartFile.fromFile(
      //   e.path,
      //   filename: e.path.split('/').last,
      // ));
      // });
      // files.add(await MultipartFile.fromFile(
      //   attachedFile[0].path,
      //   filename: attachedFile[0].path.split('/').last,
      // ));
    }
  }

  Future<void> fillReportFiles(List<XFile> attachedReportFiles) async {
    reportFiles = [];
    if (attachedReportFiles.isNotEmpty) {
      logg('attachedFiles not empty');
      for (var i in attachedReportFiles) {
        if (i.path.split('/').last == 'pdf') {
          reportFiles.add(i);
        } else {
          reportFiles.add(await MultipartFile.fromFile(
            i.path,
            filename: i.path.split('/').last,
          ));
        }
      }
      // attachedFiles.forEach((e) async {
      //   files.add(await MultipartFile.fromFile(
      //     e.path,
      //     filename: e.path.split('/').last,
      //   ).catchError((e){
      //     logg('error: '+e.toString());
      //   }));
      // });
      // attachedFiles.map((e) async {
      //   files.add(await MultipartFile.fromFile(
      //   e.path,
      //   filename: e.path.split('/').last,
      // ));
      // });
      // files.add(await MultipartFile.fromFile(
      //   attachedFile[0].path,
      //   filename: attachedFile[0].path.split('/').last,
      // ));
    }
  }

  Future<void> postFeed({
    required String feedText,
    MenaFeed? feed,
  }) async {
    emit(SendingFeedState());
    FormData formData;

    await fillFiles(attachedFiles);

    ///
    Map<String, dynamic> toSendData = {
      'audience': currentAudience.toLowerCase().replaceAll(' ', '_'),
    };
    if (pickedFeedLocation != null) {
      toSendData['lat'] = pickedFeedLocation!.latLng!.latitude;
      toSendData['lng'] = pickedFeedLocation!.latLng!.longitude;
    } else {
      toSendData['lat'] = null;
      toSendData['lng'] = null;
    }

    toSendData['files[]'] = files;

    if (feedText.isNotEmpty) {
      toSendData['text'] = feedText;
    }
    if (feed != null) {
      toSendData['feed_id'] = feed.id.toString();
    }

    /// check data to send
    if (feedText.isEmpty && attachedFiles.isEmpty) {
      /// only audience filled
      logg('No data to send');
      emit(NoDataToSendState());
    } else {
      ////
      logg('to send feed data: ' + toSendData.toString());
      formData = FormData.fromMap(toSendData);
      await MainDioHelper.postDataWithFormData(
              url: feed == null ? addNewFeedEnd : updateFeedEnd, data: formData)
          .then((value) {
        logg('Feed sent');
        logg(value.toString());
        if (feed == null && value.data["data"] != null)
          menaFeedsList.insert(0, MenaFeed.fromJson(value.data["data"]));
        emit(SuccessSendingFeedState(
            menaFeed: value.data["data"] != null
                ? MenaFeed.fromJson(value.data["data"])
                : null));
      }).catchError((error) {
        logg('an error occurred');
        logg(error.toString());
        emit(ErrorSendingFeedState());
      });
    }
  }

  void updatePickedFeedLocation(PickedLocationModel? val) {
    pickedFeedLocation = val;
    emit(FeedUpdated());
  }

  void removeAttachments(int index) {
    logg('removing $index');
    attachedFiles.removeAt(index);
    emit(FeedUpdated());
  }

  void removeReportAttachments(int index) {
    logg('removing $index');
    attachedReportFiles.removeAt(index);
    emit(FeedUpdated());
  }

  void updateFeedAudience(String val) {
    currentAudience = val;
    emit(FeedAudienceUpdated());
  }

  /// fetch messages by chat id
  Future<void> getFeeds({String? providerId}) async {
    // feedsModel = null;
    if (state is! GettingFeedsState) {
      emit(GettingFeedsState());
      ////

      Map<String, String?> toSendData = {
        'limit': '10',
        'offset': providerId != null
            ? menaProviderFeedsListOffset.toString()
            : menaFeedsListOffset.toString(),
      };

      if (providerId != null) {
        toSendData['provider_id'] = '${providerId}';
      }

      logg('to send data: ${toSendData}');
      if (providerId == null)
        menaFeedsListOffset += 1;
      else
        menaProviderFeedsListOffset += 1;
      await MainDioHelper.getData(
        url: getFeedsEnd,
        query: toSendData,
      ).then((value) {
        logg('Feeds fetched...');
        logg(value.toString());
        // var response = FeedsModel.fromJson(value.data);
        // loginModel = response.data!;
        logg('Sskjhfkjs');
        feedsModel = FeedsModel.fromJson(value.data);
        if (providerId == null)
          menaFeedsList += feedsModel!.data.feeds!;
        else
          menaProviderFeedsList += feedsModel!.data.feeds!;
        emit(SuccessGettingFeedsState());
      }).catchError((error, stack) {
        logg('an error occurred');
        logg(error.toString());
        logg(stack.toString());
        emit(ErrorGettingFeedsState());
      });
    }
  }


  Future<void> getBlogsInfo(BuildContext context, {String? providerId}) async {

    // feedsModel = null;
    var homes = HomeScreenCubit.get(context);
    // User user = mainCubit.userInfoModel!.data.user;

    if (state is! GettingBlogsInfoState) {
      emit(GettingBlogsInfoState());
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
        query: {'platform_id': homes.selectedHomePlatformId},
      ).then((value) async {
        logg('Blogs info fetched...');
        logg(value.toString());
        // await getBlogs();
        // var response = FeedsModel.fromJson(value.data);
        // loginModel = response.data!;
        blogsInfoModel = BlogsInfoModel.fromJson(value.data);
        logg('blogs info filled');
        emit(SuccessGettingFeedsState());
      }).catchError((error, stack) {
        logg('an error occurred...');
        logg('an error occurred: ' + error.toString());
        logg('an error occurred: ' + stack.toString());
        emit(ErrorGettingFeedsState());
      });
    }
  }


  Future<void> getMyBlogs(BuildContext context,
      {String? providerId, String? categoryId}) async {

    var homes = HomeScreenCubit.get(context);
    if (state is! GettingMyBlogsInfoState) {
      emit(GettingMyBlogsInfoState());
      ////
      Map<String, String?> toSendData = {
        'limit': '15',
        'offset': '1',
      };

      if (providerId != null) {
        toSendData['provider_id'] = '${providerId}';
      }

      logg('to send data: ${toSendData}');
      // await getBlogsInfo(context);

      String endPoint = getMyBlogsInfoEnd;
      if (categoryId != null) {
        endPoint = endPoint + '/$categoryId';
      }
      await MainDioHelper.getData(
        url: endPoint,
        query: {'platform_id': homes.selectedHomePlatformId},
      ).then((value) async {
        logg('My Blogs info fetched...');
        logg(value.toString());

        myBlogInfoModel = MyBlogInfoModel.fromJson(value.data);
        logg('My blogs info filled');
        emit(SuccessGettingFeedsState());
      }).catchError((error, stack) {
        logg('an error occurred...');
        logg('an error occurred: ' + error.toString());
        logg('an error occurred: ' + stack.toString());
        emit(ErrorGettingFeedsState());
      });
    }
  }


  Future<void> getProviderBlogs(BuildContext context,
      {String? providerId, String? categoryId}) async {



    var homes = HomeScreenCubit.get(context);
    if (state is! GettingMyBlogsInfoState) {
      emit(GettingMyBlogsInfoState());
      ////
      Map<String, String?> toSendData = {
        'limit': '15',
        'offset': '1',
      };

      if (providerId != null) {
        toSendData['provider_id'] = '${providerId}';
      }

      logg('to send data: ${toSendData}');
      await getBlogsInfo(context);

      String endPoint = getProviderBlogsInfoEnd + '/$providerId';
      if (categoryId != null) {
        endPoint = endPoint + '/$categoryId';
      }
      await MainDioHelper.getData(
        url: endPoint,
        query: {'platform_id': homes.selectedHomePlatformId},
      ).then((value) async {
        logg('Provider Blogs info fetched...');
        logg(value.toString());

        myBlogInfoModel = MyBlogInfoModel.fromJson(value.data);
        menablogsList +=   myBlogInfoModel!.data.data!;
        logg('Provider blogs info filled');
        emit(SuccessGettingFeedsState());
      }).catchError((error, stack) {
        logg('an error occurred...');
        logg('an error occurred: ' + error.toString());
        logg('an error occurred: ' + stack.toString());
        emit(ErrorGettingFeedsState());
      });
    }
  }

  Future<void> getBlogDetails({String? articleId}) async {
    // feedsModel = null;
    menaArticleDetails = null;
    if (state is! GettingBlogDetailsState) {
      emit(GettingBlogDetailsState());
      ////
      Map<String, String?> toSendData = {
        'limit': '15',
        'offset': '1',
      };

      String endPoint = getBlogDetailsEnd;
      if (articleId != null) {
        endPoint = endPoint + '/$articleId';
      }
      logg('to send data: ${toSendData}');
      await MainDioHelper.getData(
        url: endPoint,
        query: {},
      ).then((value) {
        logg('Blog details fetched...');
        logg(value.toString());
        // var response = FeedsModel.fromJson(value.data);
        // loginModel = response.data!;
        menaArticleDetails = MenaArticle.fromJson(value.data['data']);
        // blogsInfoModel = BlogsInfoModel.fromJson(value.data);
        logg('blogs details filled');
        emit(SuccessGettingFeedsState());
      }).catchError((error, stack) {
        logg('an error occurred');
        logg(error.toString());
        logg(stack.toString());
        emit(ErrorGettingFeedsState());
      });
    }
  }

  Future<void> getBlogs({String? providerId, String? categoryId}) async {
    // feedsModel = null;
    log("here");
    if (state is! GettingBlogsItemsState) {
      emit(GettingBlogsItemsState());
      ////
      Map<String, String?> toSendData = {
        'limit': '15',
        'offset': '1',
      };

      if (providerId != null) {
        toSendData['provider_id'] = '${providerId}';
      }

      logg('to send data: ${toSendData}');

      String endPoint = getBlogsItemsEnd;
      if (categoryId != null) {
        endPoint = endPoint + '/$categoryId';
      }
      await MainDioHelper.getData(
        url: endPoint,
        query: {},
      ).then((value) {
        logg('Blogs items fetched...');
        logg(value.toString());
        // var response = FeedsModel.fromJson(value.data);
        // loginModel = response.data!;
        blogsItemsModel = BlogsItemsModel.fromJson(value.data);
        menablogsList +=  blogsItemsModel!.data.data!;
        logg('blogs items filled');
        emit(SuccessGettingFeedsState());
      }).catchError((error, stack) {
        logg('an error occurred');
        logg(error.toString());
        logg(stack.toString());
        emit(ErrorGettingFeedsState());
      });
    }
  }

  Future<void> getFeedsVideos({String? providerId}) async {
    logg('GettingFeedsVideosState...');

    emit(GettingFeedsVideosState());

    await MainDioHelper.getData(
      url: '$getFeedsVideosEnd?limit=10&offset=$feedsVideosListOffset',
      query: {},
    ).then((value) {
      logg('getFeedsVideos fetched...');
      logg(value.toString());
      logg('dskjfl;');
      feedsVideosModel = FeedsModel.fromJson(value.data);
      feedsVideosList += feedsVideosModel!.data.feeds!;
      feedsVideosListOffset += 1;
      logg('feedsVideosModel filled...');
      emit(SuccessGettingFeedsVideosState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorGettingFeedsVideosState());
    });
  }

  void resetCommentsModelToInitialLayout() {
    commentsModel = null;
  }

  /// get comments
  Future<void> getComments({required String feedId}) async {
    // feedsModel = null;
    emit(GettingCommentsState());
    ////

    Map<String, String?> toSendData = {
      'feed_id': feedId,
      'limit': '15',
      'offset': '1',
    };
    await MainDioHelper.getData(
      url: getCommentsEnd,
      query: toSendData,
    ).then((value) {
      logg('comments fetched...');
      logg(value.toString());
      commentsModel = CommentsModel.fromJson(value.data);
      emit(SuccessGettingCommentsState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorGettingCommentsState());
    });
  }

  Future<void> deleteFeed({String? feedId}) async {
    // feedsModel = null;
    emit(DeletingFeedsState());
    ////

    await MainDioHelper.postData(
      url: deleteFeedEnd,
      query: {'id': feedId},
    ).then((value) {
      logg('Feed deleted...');

      logg(value.toString());
      emit(SuccessDeletingFeedsState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorDeletingFeedsState());
    });
  }

  Future<void> removeComment(
      {required String? commentId, required String? feedId}) async {
    // feedsModel = null;
    emit(DeletingFeedsState());
    ////

    await MainDioHelper.postData(
      url: deleteCommentEnd,
      query: {'comment_id': commentId},
    ).then((value) {
      logg('comment deleted...');
      logg(value.toString());

      menaFeedsList
          .firstWhere((element) => element.id.toString() == feedId)
          .top10Comments!
          .removeWhere((element) => element?.id.toString() == commentId);

      menaFeedsList
          .firstWhere((element) => element.id.toString() == feedId)
          .commentsCounter -= 1;

      emit(SuccessDeletingFeedsState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorDeletingFeedsState());
    });
  }

  Future<void> hideFeed({String? feedId}) async {
    // feedsModel = null;
    emit(HidingFeedsState());
    ////

    await MainDioHelper.postData(
      url: updateFeedEnd,
      query: {
        'feed_id': feedId,
        'audience': 'only_me',
      },
    ).then((value) {
      logg('Feed hided...');
      logg(value.toString());
      emit(SuccessHidingFeedsState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorHidingFeedsState());
    });
  }

  Future<void> reportFeed({String? feedId, String? reason}) async {
    // feedsModel = null;
    emit(ReportingFeedsState());
    ////

    FormData formData;

    await fillReportFiles(attachedReportFiles);

    Map<String, dynamic> toSendData = {
      'feed_id': feedId,
      'report': reason,
    };

    if (reportFiles.isNotEmpty) {
      toSendData['images[]'] = reportFiles;
    }
    logg('to send feed data: ' + toSendData.toString());
    formData = FormData.fromMap(toSendData);
    await MainDioHelper.postDataWithFormData(url: reportFeedEnd, data: formData)
        .then((value) {
      logg('report sent...');
      logg(value.toString());
      emit(SuccessHidingFeedsState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorHidingFeedsState());
    });
  }

  // Future<void> getLast10CommentOfAFeed({String? feedId}) async {
  //   feedsModel = null;
  //   emit(GettingCommentsState());
  //   ////
  //   Map<String, String?> toSendData = {
  //     'limit': '15',
  //     'offset': '1',
  //   };
  //
  //   // if (providerId != null) {
  //   //   toSendData['provider_id'] = '${providerId}';
  //   // }
  //
  //   logg('to send data: ${toSendData}');
  //   await MainDioHelper.getData(
  //     url: getFeedsEnd,
  //     query: toSendData,
  //   ).then((value) {
  //     logg('Feeds fetched...');
  //     feedsModel = FeedsModel.fromJson(value.data);
  //     logg(value.toString());
  //     emit(SuccessGettingFeedsState());
  //   }).catchError((error) {
  //     logg('an error occurred');
  //     logg(error.toString());
  //     emit(ErrorGettingFeedsState());
  //   });
  // }

  Future<void> updateSelectedSubsMap({
    required int firstChildId,
    required String selectedId,
    required bool clear,
  }) async {
    logg('firstChildId: $firstChildId \n'
        'clear: $clear \n'
        'selectedId: $selectedId \n');

    if (clear) {
      // logg('clear');
      //

      if (selectedSubs.containsValue(selectedId)) {
        selectedSubs.removeWhere((key, value) => selectedId == value);
        selectedSubs.clear();
        logg('already added');
      } else {
        selectedSubs.clear();
        selectedSubs.addAll({
          firstChildId: selectedId,
        });
      }
    } else
    // else
    // if(selectedSubs.containsValue(selectedId)){
    //   logg('selectedsubs contains value $selectedId');
    //   selectedSubs.removeWhere((key, value) => value==selectedId);
    // }
    if (selectedSubs.containsValue(selectedId)) {
      selectedSubs.removeWhere((key, value) => selectedId == value);
      logg('already added');
    } else {
      selectedSubs.addAll({
        firstChildId: selectedId,
      });
    }
    logg('selected subs : ${selectedSubs.toString()}');
    emit(SelectedCatChanged());
  }

  Future<void> toggleLikeStatus(
      {required String feedId, required bool isLiked}) async {
    emit(UpdatingLikeState());
    ////
    await MainDioHelper.postData(
      url: likeFeedEnd,
      data: {
        'feed_id': feedId,
        'user_type': 'client',
      },
    ).then((value) {
      logg('feed liked...');
      menaFeedsList
          .firstWhere((element) => element.id.toString() == feedId)
          .isLiked = !isLiked;
      if (isLiked) {
        menaFeedsList
            .firstWhere((element) => element.id.toString() == feedId)
            .likes -= 1;
      } else {
        menaFeedsList
            .firstWhere((element) => element.id.toString() == feedId)
            .likes += 1;
      }

      logg(value.toString());
      emit(SuccessUpdatingLikeState());
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorUpdatingLikeState());
    });
  }
  Future<bool> toggleLikeBlogStatus(
      {required String blogId, required bool isLiked,bool fromProvider=false}) async {
    bool result=false;
     MainDioHelper.postData(
      url: likeBlogEnd,
      data: {
        'blog_id': blogId,

      },
    ).then((value) {
      result=true;
      logg('feed liked...');
      menablogsList
          .firstWhere((element) => element.id.toString() == blogId)
          .isLiked = !isLiked;
      log(menablogsList
          .firstWhere((element) => element.id.toString() == blogId)
          .isLiked.toString());
      logg('feed liked...');
      if (isLiked) {
        log('11111');
        menablogsList
            .firstWhere((element) => element.id.toString() == blogId)
            .likesCount -= 1;
        menablogsList
            .firstWhere((element) => element.id.toString() == blogId)
            .isLiked = false;
      } else {
        log('22222');
        menablogsList
            .firstWhere((element) => element.id.toString() == blogId)
            .likesCount += 1;
        menablogsList
            .firstWhere((element) => element.id.toString() == blogId)
            .isLiked = true;
      }
      if(!fromProvider){
        log('222224222');
        blogsItemsModel?.data.data=menablogsList;
        menaArticleDetails = menablogsList[0];

      }else{

        log('22222222');
        myBlogInfoModel?.data.data=menablogsList;
        menaArticleDetails = menablogsList[0];
      }


      logg(value.toString());
      emit(SuccessUpdatingLikeState());
    }).catchError((error) {

      emit(ErrorUpdatingLikeState());
    });
    return result;
  }

  Future<bool> toggleFollowBlogStatus(
      {required String blogId, required bool isLiked}) async {
    bool result=false;await MainDioHelper.postData(
      url: likeBlogEnd,
      data: {
        'blog_id': blogId,

      },
    ).then((value) {
      logg('feed liked...');
      result=true;
      // ujg
      menablogsList
          .firstWhere((element) => element.id.toString() == blogId)
          .isLiked = !isLiked;
      if (isLiked) {
        menablogsList
            .firstWhere((element) => element.id.toString() == blogId)
            .likesCount -= 1;
      } else {
        menablogsList
            .firstWhere((element) => element.id.toString() == blogId)
            .likesCount += 1;
      }  logg(value.toString());
      emit(SuccessUpdatingLikeState());
    }).catchError((error) {

      emit(ErrorUpdatingLikeState());
    });
    return result;
  }


  Future<void> shareProduct( BuildContext context,String Link ,String blogId , {bool isMyBlog = false}) async {
    try {
      // await Share.share(Link);
      final result = await Share.shareWithResult(Link);

      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing my website!');
        await shareBlog( context , blogId: blogId ,isMyBlog :isMyBlog, );
      }


    } catch (e, s) {
      log("$e $s");
    }
  }

  Future<bool> shareBlog(
      BuildContext context ,
      {required String blogId , required bool isMyBlog,

      }) async {
    bool result=false;
    await MainDioHelper.postData(
      url: shareBlogEnd,
      data: {
        'blog_id': blogId,

      },
    ).then((value) {
      logg('feed share liked...');
      result=true;
     var json = value.data['data'];
      logg('feed share 7liked...'+ value.data.toString());
      ShareModel shareModel = ShareModel.fromJson(json);
      logg('feed share 7liked...');
      if (isMyBlog){
        log("Before Share Count " + shareModel.sharesCount.toString());
        MyBlogCubit.get(context).myBlogsInfoModel!.data.data
            .firstWhere((element) => element.id.toString() == blogId)
            .sharesCount = shareModel.sharesCount!;
        menaArticleDetails?.sharesCount  = shareModel!.sharesCount!;
        log("shhhhhhhh After Share Count " + shareModel.sharesCount.toString());
        MyBlogCubit.get(context).emit(SuccessUpdateShareState());
      }
      else {
        menaArticleDetails?.sharesCount  = shareModel!.sharesCount!;

        log("shhhhhhfhh 222 After Share Count " + shareModel.sharesCount.toString());
        blogsItemsModel!.data.data
            .firstWhere((element) => element.id.toString() == blogId)
            .sharesCount = shareModel!.sharesCount!;
        myBlogInfoModel!.data.data
            .firstWhere((element) => element.id.toString() == blogId)
            .sharesCount = shareModel!.sharesCount!;


        log("shhhhhhhh 222 After Share Count " + shareModel.sharesCount.toString());
        emit(SuccessUpdatingShareState());
      }


    }).catchError((error) {

      emit(ErrorUpdatingShareState());
    });
    return result;
  }





  //
  // Future<void> toggleLikeBlogStatus(
  //     {required String blogId, required bool isLiked}) async {
  //   emit(UpdatingLikeState());
  //   ////
  //   await MainDioHelper.postData(
  //     url: likeBlogEnd,
  //     data: {
  //       'blog_id': blogId,
  //
  //     },
  //   ).then((value) {
  //     logg('feed liked...');
  //     // ujg
  //     menablogsList
  //         .firstWhere((element) => element.id.toString() == blogId)
  //         .isLiked = !isLiked;
  //     if (isLiked) {
  //       menablogsList
  //           .firstWhere((element) => element.id.toString() == blogId)
  //           .likesCount -= 1;
  //     } else {
  //       menablogsList
  //           .firstWhere((element) => element.id.toString() == blogId)
  //           .likesCount += 1;
  //     }
  //
  //
  //
  //     logg(value.toString());
  //     emit(SuccessUpdatingLikeState());
  //   }).catchError((error) {
  //     logg('an error occurred');
  //     logg(error.toString());
  //     emit(ErrorUpdatingLikeState());
  //   });
  // }

  Future<void> likeComment(
      {required String feedId,
      required String commentId,
      required bool isLikeOrDislike}) async {
    emit(UpdatingCommentLikeState());
    ////
    await MainDioHelper.postData(
      url: likeCommentEnd,
      data: {
        'comment_id': commentId,
        'is_like': '${isLikeOrDislike ? '1' : '0'}',
      },
    ).then((value) {
      logg('feed liked...');
      // feedsModel!.data.feeds!
      //     .firstWhere((element) => element.id.toString() == feedId)
      //     .isLiked = !isLiked;
      // if (isLiked) {
      //   feedsModel!.data.feeds!
      //       .firstWhere((element) => element.id.toString() == feedId)
      //       .likes -= 1;
      // } else {
      //   feedsModel!.data.feeds!
      //       .firstWhere((element) => element.id.toString() == feedId)
      //       .likes += 1;
      // }
      // logg(value.toString());
      getComments(feedId: feedId);
      // getFeeds();
      // LikeCommentsModel? likeCommentsModel;
      // likeCommentsModel=LikeCommentsModel.fromJson(value.data);
      // if(likeCommentsModel!=null&&likeCommentsModel.comment!=null){
      emit(SuccessUpdatingCommentLikeState());
      // }
    }).catchError((error) {
      logg('an error occurred');
      logg(error.toString());
      emit(ErrorUpdatingCommentLikeState());
    });
  }

  Future<void> commentOnFeed({
    required String feedId,
    required String comment,
    String? commentId,
    String? customProviderFeedsId,

    /// this for update feeds after comment
  }) async {
    if (comment.isNotEmpty) {
      // feedsModel=null;
      var tosSendDAta = {
        'feed_id': feedId,
        'comment': comment,
      };
      if (commentId != null) {
        tosSendDAta['comment_id'] = commentId;
      }
      emit(AddingCommentState());
      ////
      await MainDioHelper.postData(
        url: getCommentsEnd,
        data: tosSendDAta,
      ).then((value) {
        logg('feed  comment added...');

        /// response will be the new feed so update it
        // getLast10CommentOfAFeed(feedId:feedId);
        // getFeeds(providerId: customProviderFeedsId);
        logg(value.toString());
        var commentResponseModel = CommentResponseModel.fromJson(value.data);
        //
        // logg(
        //     'feed last comment before update: ${feedsModel!.data.feeds.where((element) => element.id.toString() == feedId).toList()[0].top10Comments!.first.comment}');

        /// so we are adding comment not reply
        menaFeedsList
            .firstWhere((element) => element.id.toString() == feedId)
            .top10Comments = commentResponseModel.menaFeed.top10Comments;
        menaFeedsList
            .firstWhere((element) => element.id.toString() == feedId)
            .commentsCounter = commentResponseModel.menaFeed.commentsCounter;
        logg(
            'feed last comment after update: ${menaFeedsList.where((element) => element.id.toString() == feedId).toList()[0].top10Comments!.first?.comment}');
        getComments(feedId: feedId);
        emit(SuccessAddingCommentState(
            menaFeed: menaFeedsList
                .firstWhere((element) => element.id.toString() == feedId)));
      }).catchError((error) {
        logg('an error occurred');
        logg(error.toString());
        // throw Exception(error);
        emit(ErrorAddingCommentState());
      });
    }
  }

  selectCategory(int id) {
    categoryId = id;
    emit(SelectCategory());
  }

  addStory(StoryItem storyItem) {

    stories.insert(0, storyItem);
    emit(AddStory());
  }

  getStories() {
    emit(GetStories(length: stories.length));
    emit(FeedUpdated());
  }
}

class PickedLocationModel {
  final String? name;
  final LatLng? latLng;

  PickedLocationModel({
    this.name,
    this.latLng,
  });
}
