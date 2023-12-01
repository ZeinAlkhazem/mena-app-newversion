import 'package:flutter/material.dart';

@immutable
abstract class ChatGPTState {}

class ChatGPTInitial extends ChatGPTState {}

class LoadingDataState extends ChatGPTState {}

class DataLoadedSuccessState extends ChatGPTState {}

class ErrorLoadingDataState extends ChatGPTState {}
