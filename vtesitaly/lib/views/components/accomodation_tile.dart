import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';
// import 'package:url_launcher/url_launcher.dart';

class AccomodationTile extends StatefulWidget {
  final Widget icondata;
  final String title;
  final String? subtitle;
  final String? linkUrl;
  final String? filePath;

  const AccomodationTile({
    super.key,
    required this.icondata,
    required this.title,
    this.subtitle,
    this.linkUrl,
    this.filePath
  });

  @override
  State<AccomodationTile> createState() => _AccomodationTileState();
}

class _AccomodationTileState extends State<AccomodationTile> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    return ListTile(
      trailing: _buildIconWidget(),
      title: Text(
        widget.title,
        textAlign: !isMobile ? TextAlign.end : TextAlign.start,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: widget.subtitle != null ? Text(
        widget.subtitle!,
        textAlign: !isMobile ? TextAlign.end : TextAlign.start,
      ) : null,
    );
  }

  _buildIconWidget() {
    return Container(
      height: 60,
      width: 60,
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: widget.icondata,
    );
  }


}
