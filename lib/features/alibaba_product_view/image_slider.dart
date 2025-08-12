import 'package:carousel_slider/carousel_slider.dart';
import 'package:commercepal/features/alibaba_product_view/alibaba_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_controller.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final List<ProductAttributes>? attributes;
  final Function() onShowAllImages;

  ImageSlider(
      {required this.imageUrls,
      this.attributes,
      required this.onShowAllImages});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  String? selectedImage;
  // CarouselSlider? carouselController;
  final CarouselSliderController carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    // Use selected image or original image list
    List<String> displayImages =
        selectedImage != null ? [selectedImage!] : widget.imageUrls;

    return Column(
      children: [
        Container(
          child: CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              autoPlay: selectedImage ==
                  null, // Only autoplay when no image is selected
              aspectRatio: 2.5,
              enlargeCenterPage: true,
            ),
            items: displayImages.map((url) {
              return Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child:
                      Image.network(url, fit: BoxFit.fitHeight, width: 1000.0),
                ),
              );
            }).toList(),
          ),
        ),
        if (widget.attributes != null)
          Column(
            children: [
              SizedBox(
                height: 80, // Fixed height for one row
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.attributes!.length > 5
                            ? 5 // Show only first 5 items
                            : widget.attributes!.length,
                        itemBuilder: (context, index) {
                          final attribute = widget.attributes![index];
                          if (attribute.ImageUrl != null) {
                            bool isSelected =
                                selectedImage == attribute.ImageUrl;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    // If already selected, unselect and restore original slider
                                    selectedImage = null;
                                  } else {
                                    // Select this image
                                    selectedImage = attribute.ImageUrl;
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    attribute.ImageUrl!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                    if (widget.attributes!.length > 5)
                      TextButton(
                        onPressed: () {
                          widget.onShowAllImages();
                        },
                        child: Text('Show More'),
                      ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}

// Add this new screen for showing all images
class AllImagesScreen extends StatelessWidget {
  final List<ProductAttributes> attributes;
  final Function(String) onImageSelected;

  AllImagesScreen({
    required this.attributes,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Images'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: attributes.length,
        itemBuilder: (context, index) {
          final attribute = attributes[index];
          if (attribute.ImageUrl != null) {
            return GestureDetector(
              onTap: () => onImageSelected(attribute.ImageUrl!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  attribute.ImageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
