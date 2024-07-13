import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBottomSheet extends StatefulWidget {
  final Function(File)? onImagePicked;

  //final Function(int idMatch, int idPlayer, String color) onSubmit;

  ImagePickerBottomSheet({
    Key? key,
    this.onImagePicked,
  }) : super(key: key);

  @override
  State<ImagePickerBottomSheet> createState() => _ImagePickerBottomSheetState();
}

class _ImagePickerBottomSheetState extends State<ImagePickerBottomSheet> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: currentAppColors.primaryVariantColor1,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: Text(
                    "Annuler",
                    style: TextStyle(
                      color: currentAppColors.secondaryTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  "Choisir une image",
                  style: TextStyle(
                    color: currentAppColors.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_selectedImage != null) {
                      widget.onImagePicked?.call(_selectedImage!);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    (_selectedImage != null) ? "Ajouter" : "",
                    style: TextStyle(
                      color: currentAppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: currentAppColors.secondaryColor,
                  child: IconButton(
                    padding: const EdgeInsets.all(20),
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.camera);

                      if (pickedFile != null) {
                        setState(() {
                          _selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                      color: AppColors.white,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: currentAppColors.secondaryColor,
                  child: IconButton(
                    padding: const EdgeInsets.all(20),
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        setState(() {
                          _selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.image_outlined,
                      size: 35,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_selectedImage != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 150,
                  height: 170,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.file(
                          _selectedImage!,
                          width: 150,
                          height: 150,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                        child: Container(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            backgroundColor: currentAppColors.greyColor,
                            radius: 20,
                            child: Icon(
                              Icons.delete_forever,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
