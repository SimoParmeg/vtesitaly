import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {

  final String title;
  final Function onTap;

  const MenuButton({super.key, required this.title, required this.onTap});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        widget.onTap();
      }, 
      child: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w300
        ),
      )
    );
  }
}