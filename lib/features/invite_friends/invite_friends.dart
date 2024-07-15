import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/features/install_referral/referrer.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({super.key});

  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  List<Contact> _contacts = [];
  String? url;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    // url = 
    // Request permissions
    if (await Permission.contacts.request().isGranted) {
      // Fetch contacts
      Iterable<Contact> contacts = await ContactsService.getContacts();
      // Filter contacts to include only those with phone numbers
      List<Contact> contactsWithPhones =
          contacts.where((contact) => contact.phones!.isNotEmpty).toList();
      setState(() {
        _contacts = contactsWithPhones;
      });
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
    // Example: using SMS URL scheme to open SMS app
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {
        'body': 'Hi! I would like to invite you to join our app.'
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
        title: const Text('Invite Friends'),
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
                SizedBox(
                  height: 65,
                  child: SizedBox(
                      // color: Colors.purple,
                      child: Container(
                    width: MediaQuery.of(context).size.width * 0.82,
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration: BoxDecoration(
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
                                padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
                                child: Text(
                                  "sadjklasfsdmvnksafnjkefnsfsdfsfsf",
                                  softWrap: true,
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        String? link = await getReferralLink();
                                        print(link);
                                        Share.share(
                                            "Check out this app: $link");
                                      },
                                      child: Align(
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
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Align(
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
                ),
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
                    trailing: SizedBox(
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

    // Draw top dashed line
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, borderRadius),
        Offset(startX + dashWidth, borderRadius),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw right dashed line
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width - borderRadius, startY),
        Offset(size.width - borderRadius, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Draw bottom dashed line
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height - borderRadius),
        Offset(startX + dashWidth, size.height - borderRadius),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw left dashed line
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
