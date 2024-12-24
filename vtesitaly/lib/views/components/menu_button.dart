import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';

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
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    return TextButton(
      onPressed: (){
        widget.onTap();
      }, 
      child: Text(
        widget.title,
        style: TextStyle(
          color: Colors.black,
          fontSize: !isMobile ? 18 : 28,
          fontWeight: FontWeight.w300
        ),
      )
    );
  }
}