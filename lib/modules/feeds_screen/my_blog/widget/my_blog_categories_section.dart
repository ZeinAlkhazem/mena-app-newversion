import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/models/api_model/blogs_info_model.dart';

import 'package:mena/models/local_models.dart';


import 'package:mena/modules/feeds_screen/cubit/feeds_cubit.dart';
import 'package:mena/modules/feeds_screen/my_blog/cubit/myBlog_cubit.dart';
import 'package:mena/modules/feeds_screen/my_blog/cubit/myBlog_state.dart';

import '../../../../models/api_model/my_blog_info_model.dart' as myblogModel;
import '../../../../models/api_model/my_blog_info_model.dart';


class MyBlogsCategoriesSection extends StatefulWidget {
  const MyBlogsCategoriesSection({
    super.key,
    this.childs,
    this.fatherId,
    this.isMyBlogEnd,
    this.type,
    this.providerId
  });

  final List<Category>? childs;
  final int? fatherId;
  final bool? isMyBlogEnd;
  final String? type;
  final String? providerId;
  @override
  State<MyBlogsCategoriesSection> createState() => _MyBlogsCategoriesSectionState();
}

class _MyBlogsCategoriesSectionState extends State<MyBlogsCategoriesSection> {
  @override
  void initState() {
    var myBlogCubit = MyBlogCubit.get(context);
    myBlogCubit.selectedSubs = {};
    myBlogCubit.selectedSub = -1;

    if(widget.isMyBlogEnd==true){

      int temp=myBlogCubit.myBlogsInfoModel!.data.data[0].categoryId;
      for(MenaArticle item in myBlogCubit.myBlogsInfoModel!.data.data){
        if(item.categoryId!=temp){
          temp=-1000;
          return ;
        }else{
          temp=item.categoryId;
        }
      }
      if(temp!=-1000){
        myBlogCubit
            .updateSelectedSubsMap(
            firstChildId:
            widget.fatherId!,
            selectedId:temp.toString(),
            clear: (false));
      }
    }
    else if (
    // widget.isMyBlogEnd==false ||

        widget.type =='articles'){
      int temp=myBlogCubit.myBlogsInfoModel!.data.data[0].categoryId;
      for( MenaArticle item in myBlogCubit.myBlogsInfoModel!.data.data){
        if(item.categoryId!=temp){
          temp=-1000;
          return ;
        }else{
          temp=item.categoryId;
        }
      }
      if(temp!=-1000){
        myBlogCubit
            .updateSelectedSubsMap(
            firstChildId:
            widget.fatherId!,
            selectedId:temp.toString(),
            clear: (false));
      }

    }





    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var myBlogCubit = MyBlogCubit.get(context);

    return BlocConsumer<MyBlogCubit, MyBlogState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return (widget.childs == null)
            ? SizedBox()
            : Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              )),
            child: Padding(
            padding: EdgeInsets.all(defaultHorizontalPadding),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      widthBox(defaultHorizontalPadding),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: SelectorButton(
                            customHeight: 31.sp,
                            title: 'ALL',
                            isSelected: (myBlogCubit.selectedSubs
                                .containsValue(
                                (widget.childs![0]!.id * -1)
                                    .toString()) ||
                                !myBlogCubit.selectedSubs
                                    .containsKey(widget.fatherId!)),
                            onClick: () {
                              logg('current value = All');
                              myBlogCubit
                                  .updateSelectedSubsMap(
                                  firstChildId: widget.fatherId!,
                                  selectedId:
                                  (widget.childs![0]!.id * -1)
                                      .toString(),
                                  clear: false)
                                  .then((value) => {

                                    myBlogCubit.getMyBlogs(context,withoutEmit: true)

                              });
                            }),
                      ),
                      Expanded(
                        child: HorizontalSelectorScrollable(
                          buttons: widget.childs!
                              .map((e) => SelectorButtonModel(
                              title: e!.title!,
                              onClickCallback: () {
                                // logg('current Column index = ${i}');
                                logg('current value = ${e.id}');
                                log(myBlogCubit.selectedSubs
                                    .containsValue(e.id.toString())
                                    .toString());
                                myBlogCubit
                                    .updateSelectedSubsMap(
                                    firstChildId:
                                    widget.fatherId!,
                                    selectedId: e.id.toString(),
                                    clear: (false))
                                    .then((value) => {

                                  myBlogCubit.getMyBlogs(context,categoryId:  e.id.toString(),withoutEmit: true
                                  )
                                });
                                log(myBlogCubit.selectedSubs
                                    .containsValue(e.id.toString())
                                    .toString());
                                log(myBlogCubit.selectedSubs
                                    .toString());

                                // updateColumnView(childs.firstWhere((element) => element!.id==e.id)!.childs);
                                // selectedSubs[e.id]=e.id;
                                // logg('selectedSubs: ${selectedSubs.toString()}');
                                // emit(SelectedCatChanged());
                              },
                              isSelected: myBlogCubit.selectedSubs
                                  .containsValue(e.id.toString())))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.childs!
                    .where((element) {
                  return myBlogCubit.selectedSubs
                      .containsValue(element!.id.toString());
                })
                    .map((e) => e)
                    .toList()
                    .isEmpty
                    ? SizedBox()
                    : widget.childs!
                    .firstWhere((element) =>
                    myBlogCubit.selectedSubs.containsValue(
                        element!.id.toString()))!
                    .children ==
                    null
                    ? SizedBox()
                    : ChildsFilterHorizontalRows(
                  childs: widget.childs!
                      .firstWhere((element) =>
                      myBlogCubit.selectedSubs.containsValue(
                          element!.id.toString()))!
                      .children,
                  fatherId: widget.childs!
                      .where((element) => myBlogCubit.selectedSubs
                      .containsValue(
                      element!.id.toString()))
                      .map((e) => e)
                      .toList()[0]!
                      .id,
                  isMyBlogEnd:  widget.isMyBlogEnd,
                  type: widget.type,
                  providerId: widget.providerId,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChildsFilterHorizontalRows extends StatefulWidget {
  const ChildsFilterHorizontalRows({
    Key? key,
    this.childs,
    this.fatherId,
    this.isMyBlogEnd,
    this.type,
    this.providerId
  }) : super(key: key);

  final List<Category>? childs;
  final int? fatherId;
  final bool? isMyBlogEnd;
  final String? type;
  final String? providerId;

  @override
  State<ChildsFilterHorizontalRows> createState() =>
      _ChildsFilterHorizontalRowsState();
}

class _ChildsFilterHorizontalRowsState
    extends State<ChildsFilterHorizontalRows> {
  @override
  void initState() {
    // TODO: implement initState
    var childsCubit = FeedsCubit.get(context);

    logg('current value = All');
    if (widget.childs != null && widget.childs!.isNotEmpty) {
      childsCubit.updateSelectedSubsMap(
          firstChildId: widget.fatherId!,
          selectedId: (widget.childs![0]!.id * -1).toString(),
          clear: false);
    } else {
      childsCubit.updateSelectedSubsMap(
          firstChildId: widget.fatherId!,
          selectedId: (-1).toString(),
          clear: false);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var childsCubit = MyBlogCubit.get(context);
    return BlocConsumer<MyBlogCubit, MyBlogState>(
      listener: (context, state) {
        // TODO: implement listener
        // if (state is SelectedCatChanged) {
        //   // childsCubit.updateSelectedSubsMap(
        //   //     firstChildId: widget.fatherId!, selectedId: (widget.childs![0]!.id * -1).toString(), clear: false);
        // }
      },
      builder: (context, state) {
        return (widget.childs == null)
            ? SizedBox()
            : widget.childs!.isEmpty
            ? SizedBox()
            : Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  widthBox(defaultHorizontalPadding),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: SelectorButton(
                        title: 'ALL',
                        customHeight: 30.sp,
                        isSelected: widget.childs!.isNotEmpty
                            ? (childsCubit.selectedSubs.containsValue(
                            (widget.childs![0]!.id * -1)
                                .toString()) ||

                            /// no child selected
                            /// so selected subs doesn't contain any value with key father id
                            !childsCubit.selectedSubs
                                .containsKey(widget.fatherId!))
                            : true,
                        onClick: () {
                          /// unselected current items in the row and remove the below rows
                          logg('current value = All');
                          childsCubit.updateSelectedSubsMap(
                              firstChildId: widget.fatherId!,
                              selectedId: (widget.childs![0]!.id * -1)
                                  .toString(),
                              clear: false);
                          log("?//////////");

                          childsCubit.getMyBlogs(
                            context,
                              categoryId: widget.fatherId.toString(),
                            withoutEmit: true,

                          );
                          log("?//////////");
                        }),
                  ),
                  Expanded(
                    child: HorizontalSelectorScrollable(
                      buttons: widget.childs!
                          .map((e) => SelectorButtonModel(
                          title: e!.title!,
                          onClickCallback: () {
                            // logg('current Column index = ${i}');
                            logg('current value = ${e.id}');
                            childsCubit
                                .updateSelectedSubsMap(
                                firstChildId:
                                widget.fatherId!,
                                selectedId: e.id.toString()!,
                                clear: (false))
                                .then((value) => {

                              childsCubit.getMyBlogs(
                                  context,
                                  categoryId: widget.fatherId.toString(),
                                withoutEmit: true,
                              )
                            });

                            // updateColumnView(childs.firstWhere((element) => element!.id==e.id)!.childs);
                            // selectedSubs[e.id]=e.id;
                            // logg('selectedSubs: ${selectedSubs.toString()}');
                            // emit(SelectedCatChanged());
                          },
                          isSelected: childsCubit.selectedSubs
                              .containsValue(e.id.toString())))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            widget.childs!
                .where((element) {
              return childsCubit.selectedSubs
                  .containsValue(element!.id.toString());
            })
                .map((e) => e)
                .toList()
                .isEmpty
                ? SizedBox()
                : widget.childs!
                .firstWhere((element) => childsCubit
                .selectedSubs
                .containsValue(
                element!.id.toString()))!
                .children ==
                null
                ? SizedBox()
                : ChildsFilterHorizontalRows(
              childs: widget.childs!
                  .firstWhere((element) => childsCubit
                  .selectedSubs
                  .containsValue(
                  element!.id.toString()))!
                  .children,
              fatherId: widget.childs!
                  .where((element) => childsCubit
                  .selectedSubs
                  .containsValue(
                  element!.id.toString()))
                  .map((e) => e)
                  .toList()[0]!
                  .id,
              isMyBlogEnd:  widget.isMyBlogEnd,
              type: widget.type,
              providerId: widget.providerId,
            )
          ],
        );
      },
    );
  }
}
