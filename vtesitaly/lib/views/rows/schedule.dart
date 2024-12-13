import 'package:flutter/material.dart';

class EventRow extends StatefulWidget {
  const EventRow({super.key});

  @override
  State<EventRow> createState() => _EventRowState();
}

class _EventRowState extends State<EventRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(),
        Image.asset("images/vtes_italy.jpeg")
      ],
    );
  }
}