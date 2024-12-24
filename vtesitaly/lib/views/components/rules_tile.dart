import 'package:flutter/material.dart';

class RuleTile extends StatefulWidget {
  final Widget icondata;
  final String title;

  const RuleTile({
    super.key,
    required this.icondata,
    required this.title,
  });

  @override
  State<RuleTile> createState() => _RuleTileState();
}

class _RuleTileState extends State<RuleTile> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListTile(
        leading: Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: widget.icondata
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
    );
  }
}
