import 'package:flutter/material.dart';

class PrizeTile extends StatefulWidget {
  final String title;
  final Map<String, IconData> lines;

  const PrizeTile({
    super.key,
    required this.title,
    required this.lines,
  });

  @override
  State<PrizeTile> createState() => _PrizeTileState();
}

class _PrizeTileState extends State<PrizeTile> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.grey,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8)
          ),
          child: ListTile(
            title: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24
              ),
            ),
            subtitle: Column(
              children: widget.lines.entries
                .map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          entry.value,
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ))
              .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
