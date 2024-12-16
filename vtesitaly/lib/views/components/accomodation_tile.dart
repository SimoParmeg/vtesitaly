import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccomodationTile extends StatefulWidget {
  final Widget icondata;
  final String title;
  final String? link;
  final String? subtitle;

  const AccomodationTile({
    super.key,
    required this.icondata,
    required this.title,
    this.link,
    this.subtitle,
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
      onTap: widget.link != null ? _downloadFile : null,
    );
  }

  Future<void> _downloadFile() async {
    if (widget.link == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No link provided."),
        ),
      );
      return;
    }

    final Uri url = Uri.parse(widget.link!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not launch the link."),
        ),
      );
    }
  }
}
