import 'package:commercepal/features/translation/translation_api.dart';
import 'package:flutter/material.dart';

class HomeErrorWidget extends StatelessWidget {
  final String error;

  const HomeErrorWidget({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          FutureBuilder(
            future: TranslationService.translate(error),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? error,
                textAlign: TextAlign.center,
              );
            },
          )
        ],
      ),
    );
  }
}
