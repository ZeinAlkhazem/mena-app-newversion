import 'package:flutter/cupertino.dart';

@immutable
abstract class NewMessageState {}

class NewMessageInitial extends NewMessageState {}

class GettingPrimaryMessagesData extends NewMessageState {}
class SuccessGettingPrimaryMessagesDataState extends NewMessageState {}
class ErrorGettingPrimaryMessagesDataState extends NewMessageState {}