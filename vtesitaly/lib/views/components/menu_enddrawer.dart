import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/menu_button.dart';


class MenuEndDrawer extends StatefulWidget {

  final List<VoidCallback> callbacks;

  const MenuEndDrawer({super.key, required this.callbacks});

  @override
  State<MenuEndDrawer> createState() => _MenuEndDrawerState();
}

class _MenuEndDrawerState extends State<MenuEndDrawer> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    return isMobile ? Drawer(
      width: MediaQuery.of(context).size.width / 3 * 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
            onTap: (){
              widget.callbacks[0]();
              Navigator.of(context).pop();
            }
          ),
          const SizedBox(height: 24),
          MenuButton(
            title: "Schedule",
            onTap: (){
              widget.callbacks[1]();
              Navigator.of(context).pop();
            }
          ),
          const SizedBox(height: 24),
          MenuButton(
            title: "Accomodation",
            onTap: (){
              widget.callbacks[2]();
              Navigator.of(context).pop();}
          ),
          const SizedBox(height: 24),
          MenuButton(
            title: "Other Events",
            onTap: (){
              widget.callbacks[3]();
              Navigator.of(context).pop();}
          ),
          const SizedBox(height: 24),
          MenuButton(
            title: "Contact",
            onTap: (){
              widget.callbacks[4]();
              Navigator.of(context).pop();}
          )        
        ],
      ),
    ) : Container();
  }
}