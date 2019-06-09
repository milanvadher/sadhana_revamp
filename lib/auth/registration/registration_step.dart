import 'package:flutter/material.dart';

class AppStep {
  final String id;
  final String title;
  final String subTitle;
  GlobalKey<FormState> formKey;
  final Widget builder;
  AppStep({
    this.id,
    @required this.title,
    formKey,
    this.subTitle,
    @required this.builder,
  }) : this.formKey = formKey ?? GlobalKey<FormState>();
}
