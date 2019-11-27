import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sadhana/auth/login/validate_widget.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/imagepicker/image_picker_handler.dart';

class ImageInput extends StatefulWidget {
  Function onImagePicked;
  File image;
  String title;
  bool isRequired;

  ImageInput({@required this.title, @required this.image, this.onImagePicked, this.isRequired = false});

  @override
  _ImageInputState createState() => new _ImageInputState();
}

class _ImageInputState extends State<ImageInput> with TickerProviderStateMixin, ImagePickerListener {
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValidateInput(
      labelText: '${widget.title} photo',
      isRequiredValidation: widget.isRequired,
      inputWidget: _buildImageInput(),
      selectedValue: widget.image,
    );
  }

  String getHint() {
    return widget.isRequired ? '${widget.title} *' : widget.title;
  }

  _buildImageInput() {
    return Column(
      children: <Widget>[
        new Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(getHint(), textScaleFactor: 1.2),
                  SizedBox(width: 10),
                  RaisedButton(
                    child: Text('Upload Photo'),
                    onPressed: _onUploadPhotoBtnClick,
                  )
                  /*Container(
                    child: new GestureDetector(
                      onTap: () => imagePicker.showDialog(context),
                      child: _buildCamera(),
                    ),
                  ),*/
                ],
              ),
              widget.image != null ? _buildProfilePicture() : Container(),
            ],
          ),
        ),
      ],
    );
  }

  void _onUploadPhotoBtnClick() async {
    await AppUtils.askForPermission();
    if(await AppUtils.askForPermission()) {
      imagePicker.showDialog(context);
    }
  }

  _buildCamera() {
    return CircleAvatar(
      maxRadius: 17,
      backgroundColor: Colors.white,
      child: new Container(
        child: Image(
          height: 27,
          width: 27,
          image: AssetImage('images/photo_camera.png'),
        ),
      ),
    );
  }

  _buildProfilePicture() {
    return Container(
      height: 180,
      alignment: Alignment(1, 0),
      child: Image.file(widget.image),
    );
  }

  @override
  userImage(File _image) async {
    if (_image != null) if (widget.onImagePicked != null) widget.onImagePicked(_image);
  }
}
