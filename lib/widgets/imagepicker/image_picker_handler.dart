import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'image_picker_dialog.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;

  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    var result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path, image.absolute.path,
      quality: 60);
    print(image.lengthSync());
    print(result.length);
    //cropImage(image);
    await compressImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //cropImage(image);
    await compressImage(image);
  }

  compressImage(File image) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path, image.absolute.path,
        quality: 60);
    print(image.lengthSync());
    print(result.length);
    _listener.userImage(result);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(File image) async {
    if(image != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        //ratioX: 1.0,
        //ratioY: 1.0,
      );
      _listener.userImage(croppedFile);
    }
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
