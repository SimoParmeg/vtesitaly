import 'package:flutter/material.dart';

class ScheduleTile extends StatefulWidget {
  final Widget icondata;
  final String title;
  final String time;
  final String? subtitle;

  const ScheduleTile({
    super.key,
    required this.icondata,
    required this.title,
    required this.time,
    this.subtitle,
  });

  @override
  State<ScheduleTile> createState() => _ScheduleTileState();
}

class _ScheduleTileState extends State<ScheduleTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: widget.icondata
      ),
      title: _buildRichTextTitle(), // Chiama il metodo interno alla classe
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
    );
  }

  Widget _buildRichTextTitle() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: widget.time,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
