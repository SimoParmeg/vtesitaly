import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/menu_button.dart';


class MenuEndDrawer extends StatefulWidget {
  const MenuEndDrawer({super.key});

  @override
  State<MenuEndDrawer> createState() => _MenuEndDrawerState();
}

class _MenuEndDrawerState extends State<MenuEndDrawer> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    return isMobile ? Drawer(
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          const DrawerHeader(
            child: Padding(
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
          ),
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
          )        
        ],
      ),
    ) : Container();
  }
}