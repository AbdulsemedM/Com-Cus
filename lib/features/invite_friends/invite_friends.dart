import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/app/utils/app_colors.dart';
import 'package:commercepal/app/utils/dialog_utils.dart';
import 'package:commercepal/core/data/prefs_data.dart';
import 'package:commercepal/core/data/prefs_data_impl.dart';
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
  List<ContactInfo> _contactsInfo = [];
  List<Contact> _contacts = [];
  String? url;
  Set<String> registeredPhoneNumbers = {};
  Set<String> alreadyInvitedNumbers = {};
  bool loading = false; // Add this
  static const int _pageSize = 50;
  int _currentPage = 0;
  bool _hasMoreContacts = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _getContactsPage();
    getUrl();
  }

  Future<void> getUrl() async {
    setState(() {
      loading = true;
    });

    try {
      var load = await getReferralLink();
      setState(() {
        url = load;
        print(url);
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _getContactsPage() async {
    if (!_hasMoreContacts || _isLoadingMore) return;

    setState(() {
      if (_currentPage == 0) loading = true;
      _isLoadingMore = true;
    });

    try {
      PermissionStatus permissionStatus = await Permission.contacts.status;
      if (permissionStatus.isGranted) {
        // Get paginated contacts
        Iterable<Contact> contacts = await ContactsService.getContacts(
          query: "",
          withThumbnails: false,
          photoHighResolution: false,
          orderByGivenName: true,
          // offset and limit are not valid parameters for getContacts()
        );

        if (contacts.isEmpty) {
          _hasMoreContacts = false;
          return;
        }

        List<Contact> contactsWithPhones = contacts
            .where((contact) => contact.phones!.isNotEmpty)
            .where((contact) {
          String phoneNumber =
              contact.phones!.first.value!.replaceAll(' ', '') ?? '';
          return phoneNumber.startsWith('251') ||
              phoneNumber.startsWith('+251') ||
              phoneNumber.startsWith('0') ||
              phoneNumber.startsWith('+');
        }).map((contact) {
          contact.phones = contact.phones!.map((phone) {
            phone.value = phone.value!.replaceAll(' ', '');
            return phone;
          }).toList();
          return contact;
        }).toList();

        setState(() {
          _contacts.addAll(contactsWithPhones);
          _currentPage++;
        });

        await _checkRegisteredUsers(contactsWithPhones);
      } else if (permissionStatus.isDenied ||
          permissionStatus.isPermanentlyDenied) {
        permissionStatus = await Permission.contacts.request();
        if (permissionStatus.isGranted) {
          _getContactsPage();
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        loading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _checkRegisteredUsers(List<Contact> contacts) async {
    try {
      List<String> phoneNumbers = contacts
          .where((contact) => contact.phones?.isNotEmpty ?? false)
          .map((contact) => contact.phones!.first.value ?? '')
          .toList();
      print({'phoneNumbers': phoneNumbers});
      final prefsData = getIt<PrefsData>();
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      final response = await http.post(
        Uri.https(
            "api.commercepal.com:2096", "/prime/api/v1/user-invitations/check"),
        headers: <String, String>{
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json'
        },
        body: json.encode({'phoneNumbers': phoneNumbers}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Set<String> registeredPhoneNumbers = Set<String>.from(data
            .where((entry) => entry['exists'] as bool)
            .map((entry) => entry['phoneNumber'] as String));
        Set<String> alreadyInvitedNumbers = Set<String>.from(data
            .where((entry) => entry['alreadyInvited'] as bool)
            .map((entry) => entry['phoneNumber'] as String));

        List<ContactInfo> contactInfos = contacts.map((contact) {
          String name = contact.displayName ?? '';
          String phoneNumber = contact.phones?.first.value ?? '';

          ContactStatus status;
          if (registeredPhoneNumbers.contains(phoneNumber)) {
            status = ContactStatus.registered;
          } else if (alreadyInvitedNumbers.contains(phoneNumber)) {
            status = ContactStatus.invited;
          } else {
            status = ContactStatus.uninvited;
          }

          return ContactInfo(
            name: name,
            phoneNumber: phoneNumber,
            registrationStatus: status,
          );
        }).toList();

        print(contactInfos);

        setState(() {
          _contactsInfo = contactInfos;
        });
      } else {
        print('Failed to check registered users');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';

    // Split the name by spaces
    List<String> nameParts = name.split(' ');

    // Return the initials based on the number of name parts
    if (nameParts.length >= 2) {
      // If there are at least two parts, return the first letter of each
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (nameParts.isNotEmpty) {
      // If there is only one part, return the first two letters or just the first letter
      String firstPart = nameParts[0];
      return firstPart.length >= 2
          ? firstPart.substring(0, 2).toUpperCase()
          : firstPart.substring(0, 1).toUpperCase();
    }

    // Fallback case: return an empty string if nameParts is empty
    return '';
  }

  Future<void> _sendInvite(String phoneNumber, String name) async {
    final body = {
      'phoneNumber': phoneNumber,
      "appLink": url ??
          "https://play.google.com/store/apps/details?id=com.commercepal.commercepal&hl=en"
    };
    print(body);

    try {
      final prefsData = getIt<PrefsData>();
      final token = await prefsData.readData(PrefsKeys.userToken.name);
      final response = await http.post(
          Uri.https("api.commercepal.com:2096",
              "/prime/api/v1/user-invitations/send"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(body));
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        displaySnack(context, "Invitation sent to $name successfully");
        setState(() {
          alreadyInvitedNumbers.add(phoneNumber);
        });
      } else {
        displaySnack(context, "Unable to send message, Please try again");
      }
    } catch (e) {
      print(e.toString());
      displaySnack(context, "Unable to send message, Please try again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 18),
                  child: Text(
                    "Invite your friends and earn CommercePal coins",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                if (url != null)
                  SizedBox(
                    height: 65,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 8, 8, 8),
                                  child: Text(
                                    url!.substring(
                                        0, url!.length > 35 ? 35 : url!.length),
                                    softWrap: true,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
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
                    ),
                  ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        _getContactsPage();
                      }
                      return true;
                    },
                    child: ListView(
                      children: [
                        ..._contactsInfo.map((contactInfo) {
                          // Ensure all required fields are present
                          if (contactInfo.name.isNotEmpty &&
                              contactInfo.phoneNumber.isNotEmpty &&
                              contactInfo.registrationStatus != null) {
                            return ListTile(
                              // leading: CircleAvatar(
                              //   radius: 30,
                              //   backgroundColor:
                              //       AppColors.colorPrimaryDark,
                              //   child: Text(
                              //     _getInitials(contactInfo.name)
                              //         .toUpperCase(),
                              //     style: const TextStyle(
                              //         color: Colors.white),
                              //   ),
                              // ),
                              title: Text(
                                contactInfo.name,
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(contactInfo.phoneNumber),
                              trailing: contactInfo.registrationStatus ==
                                      ContactStatus.registered
                                  ? const Text('Already Registered')
                                  : contactInfo.registrationStatus ==
                                          ContactStatus.invited
                                      ? const Text('Already Invited')
                                      : SizedBox(
                                          height: 30,
                                          width: 95,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.colorPrimaryDark,
                                            ),
                                            onPressed: () {
                                              _sendInvite(
                                                  contactInfo.phoneNumber,
                                                  contactInfo.name);
                                            },
                                            child: const Text(
                                              'Invite',
                                              style: TextStyle(
                                                  color: AppColors.bgColor),
                                            ),
                                          ),
                                        ),
                            );
                          } else {
                            // Handle the case where required fields are missing
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.colorPrimaryDark,
                                child: const Icon(Icons.error,
                                    color: Colors.white),
                              ),
                              title: const Text('Unknown Contact'),
                              subtitle: const Text('Missing information'),
                              trailing: SizedBox(
                                height: 30,
                                width: 90,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.colorPrimaryDark,
                                  ),
                                  onPressed:
                                      null, // Disable button if information is missing
                                  child: const Text(
                                    'Invite',
                                    style: TextStyle(color: AppColors.bgColor),
                                  ),
                                ),
                              ),
                            );
                          }
                        }).toList(),
                        if (_isLoadingMore)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
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

class ContactInfo {
  final String name;
  final String phoneNumber;
  final ContactStatus registrationStatus;

  ContactInfo({
    required this.name,
    required this.phoneNumber,
    required this.registrationStatus,
  });
}

enum ContactStatus { invited, registered, uninvited }
