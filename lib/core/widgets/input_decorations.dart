import 'package:flutter/material.dart';

import '../../app/utils/app_colors.dart';

InputDecoration buildInputDecoration(String hintFuture) {
  return InputDecoration(
    hintText: hintFuture, // Initial loading state or any default text
    fillColor: AppColors.fieldBorder.withOpacity(0.8),
    filled: true,
    focusedBorder: buildInputBorder(),
    errorBorder: buildInputBorder(),
    errorMaxLines: 2,
    focusedErrorBorder: buildInputBorder(),
    disabledBorder: buildInputBorder(),
    enabledBorder: buildInputBorder(),
    // Add a FutureBuilder to handle the asynchronous hint
    // suffixIcon: FutureBuilder<String>(
    //   future: hintFuture,
    //   builder: (context, snapshot) {
    //     return IconButton(
    //       icon: Icon(Icons.refresh),
    //       onPressed: () {
    //         // Handle refreshing the hint if needed
    //       },
    //     );
    //   },
    // ),
  );
}

// OutlineInputBorder buildInputBorder() {
//   // Define your buildInputBorder logic here
//   return OutlineInputBorder();
// }

OutlineInputBorder buildInputBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: Colors.transparent, width: 0));
}
