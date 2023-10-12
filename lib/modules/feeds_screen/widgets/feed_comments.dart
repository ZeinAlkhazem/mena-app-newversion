import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../models/api_model/feeds_model.dart';
import '../cubit/feeds_cubit.dart';
import '../feeds_screen.dart';
import 'comments_container.dart';

class FeedComments extends StatelessWidget {
  const FeedComments(
      {Key? key,
        required this.index,
      required this.menaFeed,
      this.customProviderFeedsId,
      required this.isMyFeed})
      : super(key: key);
  final MenaFeed menaFeed;
  final bool isMyFeed;
  final String? customProviderFeedsId;
  final int index;
  /// this for update feeds after comment

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommentsContainer(
              index : index,
              viewAll: false,
              isMyFeed: isMyFeed,
              menaFeed: menaFeed,
              customProviderFeedsId: customProviderFeedsId,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                getFormattedDate(menaFeed.createdAt),
                style: mainStyle(context, 11, color: newDarkGreyColor),
              ),
            )
          ],
        );
  }
}
