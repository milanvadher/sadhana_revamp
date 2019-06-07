import 'package:flutter/material.dart';

class RegistrationStep {
  final String id;
  final String title;
  final String subTitle;
  GlobalKey<FormState> formKey;
  final Widget builder;
  RegistrationStep({
    this.id,
    @required this.title,
    formKey,
    this.subTitle,
    @required this.builder,
  }) : this.formKey = formKey ?? GlobalKey<FormState>();
}
