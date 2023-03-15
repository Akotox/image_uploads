import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_uploads/providers/image_picker_provider.dart';
import 'package:provider/provider.dart';

List<String> path = [];

class ImageUploads extends StatefulWidget {
  const ImageUploads({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageUploads> createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageNotifier>(
      builder: (context, imageNotifier, child) {
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(width: 0.5, color: Colors.grey.shade600)),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageNotifier.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: Image.file(
                                File(imageNotifier.images[index].path))),
                        Positioned(
                          left: 10,
                          top: 5,
                          child: GestureDetector(
                            onTap: () {
                              imageNotifier.removeImage(index);
                              // imageNotifier.removePath(index);
                              path.removeAt(index);
                            },
                            child: const Icon(
                              MaterialCommunityIcons.delete_circle_outline,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
                right: 6,
                top: 5,
                child: GestureDetector(
                    onTap: () => pickImage(context),
                    child: const Icon(Ionicons.add_circle, size: 22))),
            Positioned(
                right: 6,
                bottom: 5,
                child: GestureDetector(
                    onTap: () {
                      imageNotifier.removeAll();
                      path.clear();
                    },
                    child: const Icon(
                      MaterialCommunityIcons.delete_circle_outline,
                      size: 22,
                    ))),
            Positioned(
                right: 6,
                top: 30,
                child: GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      MaterialCommunityIcons.upload_outline,
                      size: 22,
                    )))
          ],
        );
      },
    );
  }

  // void pickImage(BuildContext context) async {
  //   // ignore: no_leading_underscores_for_local_identifiers
  //   XFile? _imageFiles = await _picker.pickImage(source: ImageSource.gallery);

  //   if (_imageFiles != null) {

  //     // ignore: use_build_context_synchronously
  //     Provider.of<ImageNotifier>(context, listen: false).addImage(_imageFiles);
  //   }
  // }

  void pickImage(BuildContext context) async {
    // ignore: no_leading_underscores_for_local_identifiers
    XFile? _imageFile = await _picker.pickImage(source: ImageSource.gallery);

    if (_imageFile != null) {
      // Crop the image
      _imageFile = await cropImage(_imageFile);
      if (_imageFile != null) {
        // Add the cropped image to the provider
        // ignore: use_build_context_synchronously
        Provider.of<ImageNotifier>(context, listen: false).addImage(_imageFile);
        // ignore: use_build_context_synchronously
        path.add(_imageFile.path);
      } else {
        return;
      }
    }
  }

  Future<XFile?> cropImage(XFile imageFile) async {
    // Crop the image using image_cropper package
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: imageFile.path,
      maxWidth: 1080,
      maxHeight: 1920,
      compressQuality: 80,
      // aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'GoCropper',
            toolbarColor: Theme.of(context).dividerColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      return XFile(croppedFile.path);
    } else {
      return null;
    }
  }
}
