import 'package:commercepal/features/contact_us/social_media.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final String phoneNumber = "+251 90- 060-7175";
  final String phoneNumber2 = "+251 91-530-4065";
  final String phoneNumber3 = "9491";
  final String url = "https://commercepal.com/browse";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Contact Us",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17))),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 28, 0, 8),
            child: Center(
              child: Text(
                "Get in Touch",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 23,
                    color: Colors.black),
              ),
            ),
          ),
          const Center(
            child: Text(
              "If you have any inquiries, get in touch with us. \nWe will be happy to help you.",
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 13),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: phoneNumber3),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: phoneNumber3,
                    );
                    if (await canLaunch(launchUri.toString())) {
                      await launch(launchUri.toString());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Could not launch $phoneNumber3')),
                      );
                    }
                  },
                  child: Icon(Icons.phone, color: Colors.green),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: phoneNumber2),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: phoneNumber2,
                    );
                    if (await canLaunch(launchUri.toString())) {
                      await launch(launchUri.toString());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Could not launch $phoneNumber2')),
                      );
                    }
                  },
                  child: Icon(Icons.phone, color: Colors.green),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: phoneNumber),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () async {
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: phoneNumber,
                    );
                    if (await canLaunch(launchUri.toString())) {
                      await launch(launchUri.toString());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Could not launch $phoneNumber')),
                      );
                    }
                  },
                  child: Icon(Icons.phone, color: Colors.green),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              readOnly: true,
              controller:
                  TextEditingController(text: "https://commercepal.com"),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () async {
                    // final Uri launchUri = Uri(
                    //   path: url,
                    // );
                    // if (await canLaunch(launchUri.toString())) {
                    await launchUrl(Uri.parse(url));
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Could not launch $url')),
                    //   );
                    // }
                  },
                  child: Icon(FontAwesomeIcons.globe, color: Colors.green),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 28, 0, 8),
            child: Center(
              child: Text(
                "Social Media",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 23,
                    color: Colors.black),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SocialMediaLink(
                  icon: Icons.facebook,
                  text:
                      'Stay updated, connect, and engage with us on Facebook.',
                  url: 'https://www.facebook.com/Commercepal/',
                ),
                SocialMediaLink(
                  icon: FontAwesomeIcons.instagram,
                  text:
                      'Explore our visual world and discover beauty of our brand.',
                  url:
                      'https://www.instagram.com/commercepal1/?igshid=YmMyMTA2M2Y%3D',
                ),
                SocialMediaLink(
                  icon: FontAwesomeIcons.tiktok,
                  text:
                      'Discover the beauty of our brand and explore our visual world on TikTok.',
                  url: 'https://www.tiktok.com/@commercepal',
                ),
                SocialMediaLink(
                  icon: FontAwesomeIcons.twitter,
                  text:
                      'Follow us for real-time updates and lively discussions.',
                  url:
                      'https://x.com/CommercePal?t=3gF1oMXGc2GJmiawxvYvvA&s=09',
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
