import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';

class SectionTitle extends StatefulWidget {

  final String title;
  final String? subtitle;

  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  State<SectionTitle> createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> {
  @override
  Widget build(BuildContext context) {
    
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;

    return Column(
      crossAxisAlignment: !isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          textAlign: !isMobile ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
            fontSize: 36, 
            color: Colors.blue, 
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 8),
        widget.subtitle != null ? Text(
          widget.subtitle!,
          textAlign: !isMobile ? TextAlign.center : TextAlign.start,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
        ) : Container(),
      ],
    );
  }
}