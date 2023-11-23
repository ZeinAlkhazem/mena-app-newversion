

import 'package:flutter/cupertino.dart';

@immutable
abstract class MyBlogState {}
class MyBlogInitial extends MyBlogState{}
class GettingMyBlogsInfoState extends MyBlogState{}
class SuccessGettingMyBlogsState extends  MyBlogState{}
class ErrorGettingMyBlogsState extends MyBlogState{}
class SelectedCatChanged extends MyBlogState {}
class SuccessUpdatingMyBlogsState extends MyBlogState {}
class SuccessUpdateShareState extends MyBlogState {}
