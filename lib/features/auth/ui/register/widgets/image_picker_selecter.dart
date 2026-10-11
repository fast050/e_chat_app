import 'dart:io';
import 'package:e_chat_app/core/helper/extenstions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSelecter extends StatefulWidget {
  const ImagePickerSelecter({super.key});

  @override
  State<ImagePickerSelecter> createState() => _ImagePickerSelecterState();
}

class _ImagePickerSelecterState extends State<ImagePickerSelecter> {
  
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      }
    });
  }

  Future<dynamic> showProfileImageSelection(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload Image"),
          content: const Text(
              "you can upload your image from your gallery or camara"),
          actions: <Widget>[
            TextButton(
              child: const Text("Pick An Image"),
              onPressed: () {
                _pickImage(ImageSource.gallery);
                
                context.pop(); // Dismisses the dialog
              },
            ),
            TextButton(
              child: const Text("Take A Picture"),
              onPressed: () {
                _pickImage(ImageSource.camera);
                context.pop(); // Dismisses the dialog
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showProfileImageSelection(context),
      child: Stack(children: [
        CircleAvatar(
          radius: 70.r,
          backgroundImage: _image == null
              ? AssetImage("assets/images/avatar.png")
              : FileImage(File(_image!.path)),
          backgroundColor: Colors
              .transparent, // Optional: color displayed if image fails to load
        ),
        Positioned(
          right: 0,
          child: Image.asset(
            "assets/images/button_icon.png",
            width: 42.w,
            height: 42.h,
          ),
        ),
      ]),
    );
  }
}
