import 'dart:convert';
import 'dart:io';

import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:commercepal/app/utils/logger.dart';

class AddSpecialOrders extends StatefulWidget {
  const AddSpecialOrders({super.key});

  @override
  State<AddSpecialOrders> createState() => _AddSpecialOrdersState();
}

class SubCategoryData {
  final String id;
  final String unique_name;
  SubCategoryData({required this.id, required this.unique_name});
}

class ProductCategory {
  final String id;
  final String name;
  ProductCategory({required this.id, required this.name});
}

class ParentCategoryData {
  final String id;
  final String name;
  ParentCategoryData({required this.id, required this.name});
}

class _AddSpecialOrdersState extends State<AddSpecialOrders> {
  String? productName;
  String? description;
  String? link;
  String? estimatedPrice;
  String? orderId;
  File? _image;
  String? myParentCategory;
  String? myProductCategory;
  String? myProductSubCategory;
  List<SubCategoryData> subCat = [];
  List<ProductCategory> proCat = [];
  List<ParentCategoryData> parCat = [];
  final GlobalKey<FormState> _formKey = GlobalKey();
  var loading = false;
  @override
  void initState() {
    super.initState();
    fetchParentCategory();
  }

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    var sWidth = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Special Orders"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Product Name"),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        // : 'Full Name',
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            productName = value;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Product name is required';
                          }
                          return null;
                        },
                      ),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Parent Category"),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        items: parCat.map((ParentCategoryData par) {
                          return DropdownMenuItem<String>(
                            value: par.id.toString(),
                            child: Text(
                              par.name,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            myProductCategory = null;
                            myProductSubCategory = null;
                            myParentCategory = value;
                            fetchProductCategory(myParentCategory!);
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Parent category field is required';
                          }
                          return null;
                        },
                      ),
                      if (myParentCategory != null)
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Product Category"),
                            ),
                          ],
                        ),
                      if (myParentCategory != null)
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.greyColor,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                          items: proCat.map((ProductCategory pro) {
                            // appLog(pro.name);
                            return DropdownMenuItem<String>(
                              value: pro.id.toString(),
                              child: Text(
                                pro.name,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            );
                          }).toList(),
                          value: myProductCategory,
                          onChanged: (value) {
                            setState(() {
                              myProductSubCategory = null;
                              myProductCategory = value;
                              fetchSubCategory(myProductCategory!);
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Product category field is required';
                            }
                            return null;
                          },
                        ),
                      if (myProductCategory != null)
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Sub-Category"),
                            ),
                          ],
                        ),
                      if (myProductCategory != null)
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: AppColors.greyColor,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                          items: subCat.map((SubCategoryData sub) {
                            return DropdownMenuItem<String>(
                              value: sub.id,
                              child: Text(
                                sub.unique_name,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            );
                          }).toList(),
                          value: myProductSubCategory,
                          onChanged: (value) {
                            setState(() {
                              myProductSubCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Product sub category field is required';
                            }
                            return null;
                          },
                        ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Description"),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return 'Description is required';
                          }

                          return null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Link to product"),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            link = value;
                          });
                        },
                        validator: (value) {
                          return null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Estimated Price"),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: AppColors.greyColor,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          setState(() {
                            estimatedPrice = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return 'Estimated price is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Text("Product Image"),
                      _image == null
                          ? const SizedBox(child: Text('JPG/PNG file'))
                          : SizedBox(
                              height: sHeight * 0.15,
                              child: Image.file(_image!)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FloatingActionButton(
                              backgroundColor: AppColors.colorPrimaryDark,
                              onPressed: () => _getImage(ImageSource.gallery),
                              tooltip: 'Pick Image from Gallery',
                              child: const Icon(
                                Icons.photo,
                                color: AppColors.bg1,
                              ),
                            ),
                            const SizedBox(width: 16),
                            FloatingActionButton(
                              backgroundColor: AppColors.colorPrimaryDark,
                              onPressed: () => _getImage(ImageSource.camera),
                              tooltip: 'Take a Photo',
                              child: const Icon(
                                Icons.camera_alt,
                                color: AppColors.bg1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      loading
                          ? const CircularProgressIndicator(
                              color: AppColors.colorPrimaryDark,
                            )
                          : SizedBox(
                              width: sWidth * 0.9,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.colorPrimaryDark),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate() &&
                                        _image != null) {
                                      bool done = await verifyForm();
                                      if (done) {
                                        // ignore: use_build_context_synchronously
                                        displaySnack(context,
                                            "Order Placed successfully.");
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      } else {
                                        displaySnack(context,
                                            orderId ?? 'Please try again');
                                      }
                                    } else {
                                      displaySnack(context,
                                          "Please fill all the required fields.");
                                    }
                                  },
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: AppColors.bg1,
                                    ),
                                  )),
                            )
                    ]),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (pickedFile != null) {
        if (source == ImageSource.camera) {
          _image = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          // Save the image to the gallery
          GallerySaver.saveImage(_image!.path).then((success) {
            appLog("Image saved to gallery: $success");
            appLog("hereweare");
            appLog(_image);
          });
        } else {
          _image = File(pickedFile.path);
          // prefs.setString("myImage", _image!.path);
          appLog("herewego");
          appLog(_image);
        }
      } else {
        appLog('No image selected.');
      }
    });
  }

  Future<bool> verifyForm() async {
    try {
      setState(() {
        loading = true;
      });
      appLog("hereeeewego");
      Map<String, dynamic> payload = {
        "subCategoryId": int.parse(myProductSubCategory!),
        "ProductName": productName,
        "Description": description,
        "EstimatePrice": double.parse(estimatedPrice!),
        "LinkToProduct": link,
        "quantity": 1,
      };
      appLog(payload);

      final prefsData = getIt<PrefsData>();
      final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
      if (isUserLoggedIn) {
        final token = await prefsData.readData(PrefsKeys.userToken.name);
        final response = await http.post(
            Uri.https(
                "api.commercepal.com:2096", "prime/api/v1/special-orders"),
            body: jsonEncode(payload),
            headers: <String, String>{"Authorization": "Bearer $token"});
        // appLog(response.body);
        var data = jsonDecode(response.body);
        appLog(data);

        if (data['statusCode'] == '000') {
          orderId = data["specialOrderId"].toString();
          appLog(orderId);
          // File imgShop = File(step2[5]);
          await uploadImage(
            imageFile: _image!.path,
            orderId: orderId!,
          );
          setState(() {
            loading = false;
          });
          return true;
        } else {
          orderId = data['statusMessage:'];
          setState(() {
            loading = false;
          });
          return false;
        }
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      appLog(e.toString());
      return false;
    } finally {
      setState(() {
        loading = false;
      });
    }
    return false;
  }

  Future<void> uploadImage({
    required String imageFile,
    required String orderId,
  }) async {
    final prefsData = getIt<PrefsData>();
    final isUserLoggedIn = await prefsData.contains(PrefsKeys.userToken.name);
    if (isUserLoggedIn) {
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.commercepal.com:2096/prime/api/v1/special-orders/upload-image',
        ),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['orderId'] = orderId;

      // Add the image file
      var image = await http.MultipartFile.fromPath('file', imageFile);
      request.files.add(image);
      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        appLog(response);

        if (responseBody == '000') {
          appLog('Image uploaded successfully');
        } else {
          appLog('Failed to upload image. Status code: ${response.statusCode}');
          appLog('Error message: $responseBody');
        }
      } catch (error) {
        appLog('Error uploading image: $error');
      }
    }

    // Add other fields
  }

  Future<bool> fetchSubCategory(String id) async {
    try {
      setState(() {
        loading = true;
      });
      appLog("subcat");
      appLog(id);
      final response = await http.get(Uri.https(
        "api.commercepal.com:2096",
        "/prime/api/v1/portal/category/GetSubCategories",
        {'category': id},
      ));
      var data = jsonDecode(response.body);
      subCat.clear();
      for (var b in data['details']) {
        subCat.add(
            SubCategoryData(unique_name: b['name'], id: b['id'].toString()));
      }
      appLog(subCat.length);
      setState(() {
        loading = false;
      });

      // Check the condition for success
      bool success = subCat.length > 0;
      return success;
    } catch (e) {
      appLog(e.toString());
      setState(() {
        loading = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<bool> fetchProductCategory(String id) async {
    try {
      setState(() {
        loading = true;
      });
      appLog("product category");
      final response = await http.get(Uri.https(
        "api.commercepal.com:2096",
        "/prime/api/v1/portal/category/GetCategories",
        {'parentCat': id},
      ));
      var data = jsonDecode(response.body);
      proCat.clear();
      for (var b in data['details']) {
        proCat.add(ProductCategory(name: b['name'], id: b['id'].toString()));
      }
      appLog(proCat.length);
      setState(() {
        loading = false;
      });

      // Check the condition for success
      bool success = proCat.length > 0;
      return success;
    } catch (e) {
      appLog(e.toString());
      setState(() {
        loading = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<bool> fetchParentCategory() async {
    try {
      setState(() {
        loading = true;
      });
      appLog("parent category");
      final response = await http.get(Uri.https(
        "api.commercepal.com:2096",
        "prime/api/v1/portal/category/GetParentCategories",
      ));
      var data = jsonDecode(response.body);
      parCat.clear();
      for (var b in data['details']) {
        parCat.add(ParentCategoryData(name: b['name'], id: b['id'].toString()));
      }
      appLog(parCat.length);
      setState(() {
        loading = false;
      });

      // Check the condition for success
      bool success = parCat.length > 0;
      return success;
    } catch (e) {
      appLog(e.toString());
      setState(() {
        loading = false;
      });
      return false; // Return false in case of an exception
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
