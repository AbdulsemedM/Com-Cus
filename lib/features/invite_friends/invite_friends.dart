import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/install_referral/referrer.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InviteFriends extends StatefulWidget {
  const InviteFriends({super.key});

  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  List<Contact> _contacts = [];
  String? url;
  Set<String> registeredPhoneNumbers = {};

  @override
  void initState() {
    super.initState();
    _getContacts();
    getUrl();
  }

  Future<void> getUrl() async {
    url = await getReferralLink();
  }

  Future<void> _getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      List<Contact> contactsWithPhones = contacts
          .where((contact) => contact.phones!.isNotEmpty)
          .where((contact) {
        String phoneNumber = contact.phones!.first.value!.replaceAll(' ', '');
        return phoneNumber.startsWith('251') ||
            phoneNumber.startsWith('+251') ||
            phoneNumber.startsWith('0') ||
            phoneNumber.startsWith('+');
      }).toList();
      setState(() {
        _contacts = contactsWithPhones;
      });
      _checkRegisteredUsers(contactsWithPhones);
    }
  }

  Future<void> _checkRegisteredUsers(List<Contact> contacts) async {
    List<String> phoneNumbers = contacts
        .where((contact) => contact.phones!.isNotEmpty)
        .map((contact) => contact.phones!.first.value!)
        .toList();
    print({'phoneNumbers': phoneNumbers});
    final response = await http.post(
      Uri.https(
          "api.commercepal.com:2096", "/prime/api/v1/user-invitations/check"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'phoneNumbers': phoneNumbers}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        registeredPhoneNumbers = Set<String>.from(data
            .where((entry) => entry['exists'] as bool)
            .map((entry) => entry['phoneNumber'] as String));
      });
    } else {
      // Handle the error case
      print('Failed to check registered users');
    }
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty && nameParts[0].length >= 2) {
      return nameParts[0].substring(0, 2);
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0];
    }
    return '';
  }

  Future<void> _sendInvite(String phoneNumber) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {
        'body': 'Hi! I would like to invite you to try this app.\n $url'
      },
    );
    if (await canLaunch(smsUri.toString())) {
      await launch(smsUri.toString());
    } else {
      throw 'Could not launch $smsUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
      ),
      body: _contacts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 18),
                  child: Text(
                    "Invite your friends and earn CommercePal coins",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                url != null
                    ? SizedBox(
                        height: 65,
                        child: SizedBox(
                            child: Container(
                          width: MediaQuery.of(context).size.width * 0.82,
                          height: MediaQuery.of(context).size.height * 0.09,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomPaint(
                              painter: DashedBorderPainter(borderRadius: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 8, 8, 8),
                                      child: Text(
                                        url!.substring(0, 35),
                                        softWrap: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              Share.share(
                                                  "Check out this app: $url");
                                            },
                                            child: const Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(Icons.share),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(
                                                  ClipboardData(text: url!));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Copied to clipboard')),
                                              );
                                            },
                                            child: const Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(Icons.copy),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                      )
                    : Container(),
                ..._contacts.map((contact) {
                  String name = contact.displayName ?? '';
                  String initials = _getInitials(name);
                  String phoneNumber = contact.phones!.first.value ?? '';
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.colorPrimaryDark,
                      child: Text(
                        initials.toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(phoneNumber),
                    trailing: registeredPhoneNumbers.contains(phoneNumber)
                        ? const Text('Already Registered')
                        : SizedBox(
                            height: 30,
                            width: 90,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.colorPrimaryDark,
                              ),
                              onPressed: () {
                                _sendInvite(phoneNumber);
                              },
                              child: const Text(
                                'Invite',
                                style: TextStyle(color: AppColors.bgColor),
                              ),
                            ),
                          ),
                  );
                }).toList(),
              ],
            ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final double borderRadius;

  DashedBorderPainter({this.borderRadius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final dashWidth = 3;
    final dashSpace = 3;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, borderRadius),
        Offset(startX + dashWidth, borderRadius),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width - borderRadius, startY),
        Offset(size.width - borderRadius, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height - borderRadius),
        Offset(startX + dashWidth, size.height - borderRadius),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(borderRadius, startY),
        Offset(borderRadius, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
