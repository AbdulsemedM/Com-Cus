import 'package:flutter/material.dart';

class AttributeImageScroller extends StatefulWidget {
  final List<String> imageUrls;
  final Function(int) onImageSelected; // Callback for the selected image

  const AttributeImageScroller({
    Key? key,
    required this.imageUrls,
    required this.onImageSelected, // Pass the callback
  }) : super(key: key);

  @override
  _AttributeImageScrollerState createState() => _AttributeImageScrollerState();
}

class _AttributeImageScrollerState extends State<AttributeImageScroller> {
  int selectedIndex = 0; // To keep track of the selected image

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.imageUrls.asMap().entries.map((entry) {
          // int index = entry.key;
          String url = entry.value;

          return GestureDetector(
            onTap: () {
              // setState(() {
              //   selectedIndex = index; // Update selected index
              // });
              // widget.onImageSelected(index); // Call the callback
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      //  selectedIndex == index
                      //     ? Colors.black
                      // :
                      Colors.grey.shade200,
                  width: 2, // Border width
                ),
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: Image.network(
                url,
                width: 80, // Set desired image width
                height: 80, // Set desired image height
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
