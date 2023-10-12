import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:mena/modules/complete_info_subscribe/cubit/complete_info_cubit.dart';
import 'package:mena/modules/complete_info_subscribe/cubit/complete_info_state.dart';
import 'package:mena/modules/main_layout/main_layout.dart';

import '../../core/functions/main_funcs.dart';

class CompleteInfoSubscribe extends StatelessWidget {
  const CompleteInfoSubscribe(
      {Key? key, required this.fromRouteEngineSoNoBackButton})
      : super(key: key);

  final bool fromRouteEngineSoNoBackButton;

  @override
  Widget build(BuildContext context) {
    var completeInfoCubit = CompleteInfoCubit.get(context)
      ..getAdditionalRequiredFields();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0.h),
          child:  DefaultOnlyLogoAppbar(
            withBack: !fromRouteEngineSoNoBackButton,
            suffix: Row(
              children: [
                DefaultButton(text: 'Skip', onClick: (){
                  navigateToAndFinishUntil(
                      context, const MainLayout());
                },height: 25.h,width: 66.w,withoutPadding: true,),
                widthBox(defaultHorizontalPadding)
              ],
            ),
            // withBack: true,
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     navigateToAndFinishUntil(context, const MainLayout());
        //   },
        //   child: Text(
        //     'Skip',
        //     style: mainStyle(context,
        //       13,
        //       weight: FontWeight.w800,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: BlocConsumer<CompleteInfoCubit, CompleteInfoState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return completeInfoCubit.additionalRequiredDataModel == null
                  ? const Center(child: DefaultLoaderGrey())
                  : Column(
                    children: [
                      Lottie.asset('assets/json/verified.json', height: 0.15.sh),
                      Text('Please verify your specialty', style: mainStyle(context, 20, isBold: true)),
                      heightBox(22),
                      Text(
                        'In order to verify your speciality,\nyou will need to upload the required\ndocuments and answer some questions',
                        style: mainStyle(context, 14, color: newDarkGreyColor, weight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      heightBox(22),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                              children: [
                                // heightBox(27.h),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     fromRouteEngineSoNoBackButton
                                //         ? const Expanded(
                                //             child: SizedBox(
                                //             width: 10,
                                //           ))
                                //         : GestureDetector(
                                //             onTap: () => Navigator.pop(context),
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(8.0),
                                //               child: SvgPicture.asset(
                                //                 'assets/svg/icons/back.svg',
                                //                 height: 25.w,
                                //                 // cacheColorFilter: false,
                                //                 color: mainBlueColor,
                                //               ),
                                //             ),
                                //           ),
                                //     Expanded(
                                //       child: SvgPicture.asset(
                                //         'assets/svg/mena8.svg',
                                //         height: 30.h,
                                //         // cacheColorFilter: false,
                                //         // color: Colors.blue,
                                //       ),
                                //     ),
                                //     Expanded(
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.end,
                                //         children: [
                                //           Padding(
                                //             padding: const EdgeInsets.all(8.0),
                                //             child: SvgPicture.asset(
                                //               'assets/svg/icons/profile.svg',
                                //               height: 25.w,
                                //               // cacheColorFilter: false,
                                //               color: mainBlueColor,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // heightBox(55.h),
                                // Text(
                                //   'Subscribe',
                                //   style: mainStyle(context, 20),
                                // ),
                                // heightBox(20.h),
                                completeInfoCubit.requiredDataList.isEmpty
                                    ? const EmptyListLayout()
                                    : ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: completeInfoCubit
                                            .requiredDataList.length,
                                        separatorBuilder: (context, index) =>
                                            heightBox(15.h),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding:  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(completeInfoCubit
                                                    .requiredDataList[index].description,
                                                style: mainStyle(context, 14,isBold:true),),
                                                heightBox(10.h),
                                                /// string
                                                if (completeInfoCubit
                                                        .requiredDataList[index]
                                                        .type ==
                                                    'string')
                                                  DefaultInputField(
                                                    label: completeInfoCubit
                                                        .requiredDataList[index]
                                                        .name
                                                        .toString(),
                                                    // labelWidget: Text(
                                                    //     completeInfoCubit
                                                    //         .requiredDataList[index]
                                                    //         .name
                                                    //         .toString()),
                                                    onFieldChanged: (value) =>
                                                        completeInfoCubit
                                                            .updateRequiredValue({
                                                      completeInfoCubit
                                                          .requiredDataList[index]
                                                          .id
                                                          .toString(): value
                                                    }, 'text'),
                                                  )


                                                /// file
                                                else if (completeInfoCubit
                                                        .requiredDataList[index]
                                                        .type ==
                                                    'file')
                                                  GestureDetector(
                                                    onTap: () {
                                                      completeInfoCubit.selectFile(
                                                          completeInfoCubit
                                                              .requiredDataList[index]
                                                              .extensions,
                                                          completeInfoCubit
                                                              .requiredDataList[index]
                                                              .name
                                                              .toString(),
                                                          completeInfoCubit
                                                              .requiredDataList[index]
                                                              .id
                                                              .toString());
                                                    },
                                                    child: DefaultContainer(
                                                      borderColor: mainBlueColor
                                                          .withOpacity(0.3),
                                                      radius: 5.sp,
                                                      backColor: newLightGreyColor,
                                                      // height: 40.h,
                                                      childWidget: Padding(
                                                        padding: EdgeInsets.all(
                                                            defaultHorizontalPadding),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(completeInfoCubit
                                                                    .requiredDataList[
                                                                        index]
                                                                    .name
                                                                    .toString(),style: mainStyle(context, 13,color: newDarkGreyColor,weight: FontWeight.w700),),
                                                                SvgPicture.asset(
                                                                  'assets/svg/icons/file.svg',
                                                                  height: 22.sp,
                                                                  // cacheColorFilter: false,
                                                                  color:
                                                                      mainBlueColor,
                                                                ),
                                                              ],
                                                            ),
                                                            completeInfoCubit
                                                                    .enteredData
                                                                    .containsKey(completeInfoCubit
                                                                        .requiredDataList[
                                                                            index]
                                                                        .id
                                                                        .toString())
                                                                ? SizedBox(
                                                                    height: 40.h,
                                                                    child: Padding(
                                                                      padding: EdgeInsets
                                                                          .symmetric(
                                                                              horizontal:
                                                                                  defaultHorizontalPadding),
                                                                      child: ListView
                                                                          .separated(
                                                                        shrinkWrap:
                                                                            true,
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        itemBuilder:
                                                                            (context,
                                                                                    innerIndex) =>
                                                                                Row(
                                                                          children: [
                                                                            Text(completeInfoCubit
                                                                                .enteredData[completeInfoCubit.requiredDataList[index].id.toString()][innerIndex]
                                                                                .filename
                                                                                .toString()),
                                                                            GestureDetector(
                                                                              onTap:
                                                                                  () {
                                                                                completeInfoCubit.removeRequiredValue(completeInfoCubit.requiredDataList[index].id.toString(),
                                                                                    innerIndex);
                                                                              },
                                                                              child:
                                                                                  const Icon(
                                                                                Icons.delete,
                                                                                color:
                                                                                    Colors.red,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        separatorBuilder:
                                                                            (context,
                                                                                    index) =>
                                                                                SizedBox(
                                                                          width:
                                                                              10.w,
                                                                        ),
                                                                        itemCount:

                                                                            /// myMap["mykey"];
                                                                            /// get values off a key
                                                                            /// myMap["mykey"];
                                                                            completeInfoCubit
                                                                                .enteredData[completeInfoCubit.requiredDataList[index].id.toString()]
                                                                                .length,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )

                                                else Center(child: Text('*** Seems that we have unsupported file here ***'))
                                              ],
                                            ),
                                          );
                                        },
                                      ),

                              ],
                            ),
                        ),
                      ),
                      heightBox(20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultHorizontalPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // TextButton(
                            //   onPressed: () {
                            //     navigateToAndFinishUntil(
                            //         context, const MainLayout());
                            //   },
                            //   child: Text(
                            //     'Skip',
                            //     style: mainStyle(
                            //       context,
                            //       14,
                            //       weight: FontWeight.w500,
                            //       color: mainBlueColor,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultHorizontalPadding),
                        child: state is SubmittingAdditionalRequiredData
                            ? const DefaultLoaderGrey()
                            : DefaultButton(
                            text: 'Verify',
                            onClick: () {
                              completeInfoCubit
                                  .submitAdditionalRequiredFields()
                                  .then((value) {
                                return (fromRouteEngineSoNoBackButton &&
                                    value == 'Successfully updated')
                                    ? navigateToAndFinishUntil(
                                    context, const MainLayout())
                                    : showMyAlertDialog(context, 'Result',
                                    alertDialogContent: Text(value));
                              });
                            }),
                      ),
                      heightBox(20.h),
                    ],
                  );
            },
          ),
        ));
  }
}
