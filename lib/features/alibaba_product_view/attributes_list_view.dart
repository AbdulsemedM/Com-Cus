import 'package:commercepal/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

class ListItem {
  final String imageUrl;
  final String title;
  int count;
  final double price;
  final String id;
  final String name;

  ListItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.name,
    this.count = 0,
    required this.price,
  });
}

class AttributesListItem extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onProceed; // Add callback

  final List<ListItem> items;

  const AttributesListItem(
      {Key? key, required this.items, required this.onProceed})
      : super(key: key);

  @override
  _AttributesListItemState createState() => _AttributesListItemState();
}

class _AttributesListItemState extends State<AttributesListItem> {
  double totalPrice = 0.0;

  // List to store each item's id and calculated total price
  List<Map<String, dynamic>> selectedItems = [];

  void _updateTotalPrice() {
    setState(() {
      // Reset total price and selected items list
      totalPrice = 0.0;
      selectedItems.clear();

      // Calculate total price and populate selectedItems list
      for (var item in widget.items) {
        if (item.count > 0) {
          double itemTotal = item.price * item.count;
          totalPrice += itemTotal;

          selectedItems.add({
            'id': item.id,
            'price': itemTotal,
            'count': item.count, // Add count for each product
          });
        }
      }

      // Print each product's details
      for (var prod in selectedItems) {
        // print(prod);
      }
      // print("Total selected items: ${selectedItems.length}");
    });
  }

  void _incrementCount(int index) {
    setState(() {
      widget.items[index].count++;
      _updateTotalPrice();
    });
  }

  void _decrementCount(int index) {
    setState(() {
      if (widget.items[index].count > 0) {
        widget.items[index].count--;
        _updateTotalPrice();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return ListTile(
                leading: Image.network(item.imageUrl, width: 50, height: 50),
                title: Text(item.name),
                subtitle: Text('Price: ETB ${item.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _decrementCount(index),
                    ),
                    Text('${item.count}', style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _incrementCount(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sub-Total: ETB ${totalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                  width: 140,
                  height: 50,
                  child: AppButtonWidget(
                    isLoading: false,
                    text: "Proceed",
                    onClick: () {
                      widget.onProceed(selectedItems);
                    },
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
