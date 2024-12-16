import 'package:flutter/material.dart';
import 'package:vtesitaly/views/components/menu_button.dart';
import 'package:vtesitaly/config.dart';


class MenuAppBar extends StatefulWidget implements PreferredSizeWidget {

  final List<VoidCallback> callbacks;
  
  const MenuAppBar({super.key, required this.callbacks});

  @override
  State<MenuAppBar> createState() => _MenuAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MenuAppBarState extends State<MenuAppBar> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    return AppBar(
      leading: Padding(
        padding: !isMobile ? const EdgeInsets.all(10.0) : const EdgeInsets.only(top: 10, left: 32),
        child: const Text(
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
      title: !isMobile ? Row(
        mainAxisAlignment:  MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuButton(
            title: "Event",
            onTap: widget.callbacks[0]
          ),
          MenuButton(
            title: "Schedule",
            onTap: widget.callbacks[1]
          ),
          MenuButton(
            title: "Accomodation",
            onTap: widget.callbacks[2]
          ),
          MenuButton(
            title: "Other Events",
            onTap: widget.callbacks[3]
          ),
          MenuButton(
            title: "Contact",
            onTap: widget.callbacks[4]
          ),
        ]
      ) : Container(),
      actions: !isMobile ? [
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
      ] : [],
    );
  }
}