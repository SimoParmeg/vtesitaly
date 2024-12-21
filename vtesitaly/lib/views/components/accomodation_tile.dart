import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return ListTile(
      leading: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: widget.icondata,
      ),
      title: Text(
        widget.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
    );
  }

}
