import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/rules_tile.dart';
import 'package:vtesitaly/views/components/section_title.dart';

class RulesRow extends StatefulWidget {

  const RulesRow({super.key});

  @override
  State<RulesRow> createState() => _RulesRowState();
}

class _RulesRowState extends State<RulesRow> {

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    
    return !isMobile ? Column(
      children: [
        _buildTitleWidget(),
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
      title: "Rules",
    );
  }

  Widget _buildColumnWidget(bool isMobile) {
    return SizedBox(
      height: 250,
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
      const RuleTile(
        icondata: Icon(
          Icons.refresh, 
          color: Colors.white),
        title: "3 Rounds + Final"
      ),
      const SizedBox(height: 20),
      const RuleTile(
        icondata: Icon(
          Icons.hourglass_bottom_rounded, 
          color: Colors.white),
        title: "2 Hour Time Limit"
      ),
      const SizedBox(height: 20),
      const RuleTile(
        icondata: Icon(
          Icons.tab_rounded, 
          color: Colors.white),
        title: "Proxies NOT allowed"
      ),
    ];
  }
}