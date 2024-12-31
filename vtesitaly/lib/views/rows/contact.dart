import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/section_title.dart';

class ContactsRow extends StatelessWidget {
  final List<Map<String, dynamic>> contacts = [
    {
      'title': 'EMAIL',
      'icon': Icons.mail,
      'description': 'info@vtesitaly.com',
      'color': Colors.red,
      'link': 'mailto:info@vtesitaly.com',
    },
    {
      'title': 'TELEGRAM',
      'icon': Icons.telegram,
      'description': 'Join us on Telegram',
      'color': Colors.blue,
      'link': 'https://t.me/+Law4iFPNQ_tiZTZk',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < TRESHOLD_MOBILEMAXWIDTH;
        return Column(
          children: [
            const SectionTitle(title: 'Contacts'),
            const SizedBox(height: 20),
            _buildResponsiveLayout(isMobile, context),
          ],
        );
      },
    );
  }

  Widget _buildResponsiveLayout(bool isMobile, BuildContext context) {
    return SizedBox(
      height: isMobile ? null : 420,
      child: isMobile
          ? Column(
              children: _buildContactWidgets(widthFactor: 0.9, context: context),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildContactWidgets(widthFactor: 0.4, context: context),
            ),
    );
  }

  List<Widget> _buildContactWidgets({required double widthFactor, required BuildContext context}) {
    return contacts
        .map((contact) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * widthFactor,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          contact['icon'],
                          size: 48,
                          color: contact['color'],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          contact['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: contact['color'],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          contact['description'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        if (contact.containsKey('link')) ...[
                          const SizedBox(height: 12),
                          IconButton(
                            icon: Icon(Icons.link, color: contact['color']),
                            onPressed: () async {
                              final url = contact['link'];
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }
}
