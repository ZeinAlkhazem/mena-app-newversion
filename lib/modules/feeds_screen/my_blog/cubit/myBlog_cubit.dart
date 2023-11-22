
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mena/models/api_model/my_blog_info_model.dart';
import 'package:mena/models/api_model/share_model.dart';
import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart' as feed;
import 'package:share_plus/share_plus.dart';

import '../../../../core/functions/main_funcs.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/network_constants.dart';
import '../../../home_screen/cubit/home_screen_cubit.dart';
import 'myBlog_state.dart';


class MyBlogCubit extends Cubit<MyBlogState> {

  MyBlogCubit() : super(MyBlogInitial());

  static MyBlogCubit  get(context) => BlocProvider.of(context);

  MyBlogInfoModel? myBlogsInfoModel;
  Map<int, String> selectedSubs = {};
  int selectedSub = -1;
  Future<void> getMyBlogs(BuildContext context,{String? providerId, String? categoryId,bool withoutEmit=false}) async {

    var homes = HomeScreenCubit.get(context);
    if (state is! GettingMyBlogsInfoState) {
      if(!withoutEmit) {
        emit(GettingMyBlogsInfoState());
      }
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
        query: {
          'platform_id':homes.selectedHomePlatformId
        },

      ).then((value) async {
        logg('My Blogs info fetched...');
        logg(value.toString());


        myBlogsInfoModel = MyBlogInfoModel.fromJson(value.data);
        logg('My blogs info filled');
        if(withoutEmit){
          emit(SuccessUpdatingMyBlogsState());
        }else{
          emit(SuccessGettingMyBlogsState());
        }

      }).catchError((error, stack) {
        logg('an error occurred...');
        logg('an error occurred: ' + error.toString());
        logg('an error occurred: ' + stack.toString());
        emit(ErrorGettingMyBlogsState());
      });
    }
  }

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
  Future<void> shareProduct( BuildContext context,String Link ,String blogId , {bool isMyBlog = false}) async {
    try {
      // await Share.share(Link);
      // await shareBlog( context , blogId: blogId ,isMyBlog :isMyBlog, );

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
    log('here');
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
      log("My Blog Cubit1 " + shareModel.sharesCount.toString());
       myBlogsInfoModel!.data.data
            .firstWhere((element) => element.id.toString() == blogId)
            .sharesCount = shareModel.sharesCount!;
      feed.FeedsCubit.get(context).menaArticleDetails?.sharesCount  = shareModel!.sharesCount!;
        log("My Blog Cubit2222 " + shareModel.sharesCount.toString());
        emit(SuccessUpdateShareState());

    }).catchError((error) {
    });
    return result;
  }
}