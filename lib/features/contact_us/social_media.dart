import 'package:commercepal/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaLink extends StatelessWidget {
  final IconData icon;
  final String text;
  final String url;

  const SocialMediaLink({
    Key? key,
    required this.icon,
    required this.text,
    required this.url,
  }) : super(key: key);

  void _launchURL() async {
    // if (await canLaunch(url)) {
    await launchUrl(Uri.parse(url));
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: AppColors.colorPrimaryDark,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16.0, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SocialMediaPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Follow Us'),
//       ),
//       body:
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: SocialMediaPage(),
//   ));
// }
