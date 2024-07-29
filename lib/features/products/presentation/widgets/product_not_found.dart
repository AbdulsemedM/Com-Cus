import 'package:flutter/material.dart';

class ProductNotFound extends StatelessWidget {
  final String error;

  const ProductNotFound({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(18.0),
            child: Image(image: AssetImage("assets/images/emptyCart.png")),
          ),
          // Text(
          //   error,
          //   textAlign: TextAlign.center,
          // ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "No problem you can send us the details in the Special Orders and we will find it for you.",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
