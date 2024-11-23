import 'package:commercepal/features/products/presentation/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/utils/app_colors.dart';

class SearchProductWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const SearchProductWidget({Key? key, this.onChanged}) : super(key: key);

  @override
  _SearchProductWidgetState createState() => _SearchProductWidgetState();
}

class _SearchProductWidgetState extends State<SearchProductWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  TextEditingController searchController = TextEditingController();
  TextEditingController searchController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: searchController1,
        onChanged: widget.onChanged,
        autofocus: true,
        decoration: InputDecoration(
            hintStyle:
                TextStyle(color: AppColors.secondaryTextColor, fontSize: 12.sp),
            focusedBorder: _buildOutlineInputBorder(),
            enabledBorder: _buildOutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: "Type something eg watch",
            suffixIcon: IconButton(
                onPressed: () {
                  _showUploadModal(context);
                },
                icon: const Icon(Icons.image))),
      ),
    );
  }

  void _showUploadModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows modal to expand with the keyboard
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // Wrapping in Builder for a new context to access the provider
        return Builder(
          builder: (modalContext) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(modalContext)
                    .viewInsets
                    .bottom, // Adjust for keyboard
              ),
              child: SingleChildScrollView(
                // Makes content scrollable if needed
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.image,
                                size: 50, color: Colors.grey[700]),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed:
                                  _pickImage, // Call _pickImage when button is pressed
                              child: Text(
                                'Upload a file',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.camera,
                                size: 50, color: Colors.grey[700]),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed:
                                  _takeImage, // Call _pickImage when button is pressed
                              child: Text(
                                'Take a pic',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      'OR',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Paste image link',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.colorPrimaryDark,
                            ),
                            onPressed: () => _onSearchPressed(),
                            child: Text(
                              'Search',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onSearchPressed() async {
    if (searchController.text.isNotEmpty) {
      print("Search complete for: ${searchController.text}");
      Navigator.pop(context); // Close the modal first
      // Wait for the ProductCubit search method to complete
      context.read<ProductCubit>().searchByImage(searchController.text);
    }
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource
          .gallery, // Change to ImageSource.camera to open the camera
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85, // Compress the image to 85% quality
    );

    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
      // You can access the path of the selected image with _image.path
      print("Selected image path: ${_image!.path}");
      Navigator.pop(context);
      context.read<ProductCubit>().searchByImage(_image!.path);
    }
  }

  Future<void> _takeImage() async {
    if (await Permission.camera.request().isGranted) {
      print("permission granted");
      // Process selectedImage here
    } else {
      print("permission not granted");
    }
    final XFile? selectedImage = await _picker.pickImage(
      source:
          ImageSource.camera, // Change to ImageSource.camera to open the camera
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85, // Compress the image to 85% quality
    );

    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
      // You can access the path of the selected image with _image.path
      print("Selected image path: ${_image!.path}");
      Navigator.pop(context);
      context.read<ProductCubit>().searchByImage(_image!.path);
    }
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.fieldBorder, width: 2));
  }
}
