import 'package:flutter/material.dart';
import 'package:vtesitaly/views/components/menu_button.dart';

class MenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MenuAppBar({super.key});

  @override
  State<MenuAppBar> createState() => _MenuAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MenuAppBarState extends State<MenuAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "VTES Æmilia",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      leadingWidth: 300,
      centerTitle: true,
      title: Row(
        mainAxisAlignment:  MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuButton(
            title: "Event",
            onTap: (){}
          ),
          MenuButton(
            title: "Schedule",
            onTap: (){}
          ),
          MenuButton(
            title: "Accomodation",
            onTap: (){}
          ),
          MenuButton(
            title: "Other Events",
            onTap: (){}
          ),
          MenuButton(
            title: "Contact",
            onTap: (){}
          ),
        ]
      ),
      actions: [
        TextButton(
          onPressed: (){}, 
          child: const Text(
            "English"
          )
        ),
        IconButton(
          icon: const Icon(
            Icons.sunny
          ), 
          onPressed: () {  },
        )
      ], 
    );
  }
}