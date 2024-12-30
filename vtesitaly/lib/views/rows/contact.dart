import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/prizes_tile.dart';
import 'package:vtesitaly/views/components/section_title.dart';

class ContactsRow extends StatefulWidget {

  const ContactsRow({super.key});

  @override
  State<ContactsRow> createState() => _ContactsRowState();
}

class _ContactsRowState extends State<ContactsRow> {

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    
    return !isMobile ? Column(
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        _buildColumnWidget(isMobile)
      ],
    ) : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        _buildColumnWidget(isMobile),
      ]
    );
  }

  Widget _buildTitleWidget() {
    return const SectionTitle(
      title: "Contacts",
    );
  }

  Widget _buildColumnWidget(bool isMobile) {
    return SizedBox(
      height: !isMobile ? 420 : 840,
      width: MediaQuery.of(context).size.width - 64,
      child: !isMobile ? Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _buildItemsWidgets()
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _buildItemsWidgets()
      )
    );
  }

  List<Widget> _buildItemsWidgets() {
    return [
      PrizeTile(
        title: "EMAIL",
        lines: Map.fromEntries([
          const MapEntry("info@vtesitaly.com", Icons.mail),
        ]),
      ),
      const SizedBox(height: 20),
      PrizeTile(
        title: "TELEGRAM",
        lines: Map.fromEntries([
          const MapEntry("Join", Icons.telegram),
        ]),
      ),
    ];
  }
}