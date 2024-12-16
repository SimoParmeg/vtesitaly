import 'package:flutter/material.dart';
import 'package:vtesitaly/views/rows/event.dart';
import 'package:vtesitaly/views/rows/schedule.dart';

class HomePage extends StatefulWidget {

  final List <GlobalKey> keys;

  const HomePage({super.key, required this.keys});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            EventRow(key: widget.keys[0]),
            const SizedBox(height: 40),
            ScheduleRow(key: widget.keys[1])
          ],
        ),
      ),
    );
  }
}