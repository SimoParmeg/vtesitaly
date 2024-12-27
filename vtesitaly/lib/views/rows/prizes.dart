import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/prizes_tile.dart';
import 'package:vtesitaly/views/components/section_title.dart';

class PrizesRow extends StatefulWidget {

  const PrizesRow({super.key});

  @override
  State<PrizesRow> createState() => _PrizesRowState();
}

class _PrizesRowState extends State<PrizesRow> {

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    
    return !isMobile ? Column(
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        _buildSectionWidget(),
        const SizedBox(height:20),
        _buildColumnWidget(isMobile)
      ],
    ) : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        _buildSectionWidget(),
        const SizedBox(height:20),
        _buildColumnWidget(isMobile),
      ]
    );
  }

  Widget _buildTitleWidget() {
    return const SectionTitle(
      title: "Prizes",
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

  Widget _buildSectionWidget() {
    return const Text(
      "World of Darkness has generously donated 21 uncut print sheets from various old expansions of Vampire: The Eternal Struggle (Sabbat War, Final Nights, Camarilla Edition, and Black Hand) as prizes for the Iberian Grand Prix, which will take place in Palma de Mallorca on November 16, 2024.These prizes will be distributed as follows:"
    );
  }

  List<Widget> _buildItemsWidgets() {
    return [
      PrizeTile(
        title: "WELCOME PACK",
        lines: Map.fromEntries([
          const MapEntry("Grand Priz circuit playmat", Icons.tab_rounded),
          const MapEntry("Grand Prix circuit promo card", Icons.calendar_view_month_outlined),
          const MapEntry("Commemorative Edge", Icons.refresh),
          const MapEntry("Pack of cards (see image below)", Icons.calendar_view_month_outlined),
          const MapEntry("Edge sponsored by VTES Decks", Icons.refresh),
        ]),
      ),
      const SizedBox(height: 20),
      PrizeTile(
        title: "PRIZES",
        lines: Map.fromEntries([
          const MapEntry("Commemorative Chalice of Justicar for top 8 players", Icons.filter_none_rounded),
          const MapEntry("Print sheet for top 8 players", Icons.grid_4x4_rounded),
          const MapEntry("Counters by VTES Decks for the finalists", Icons.filter_1_rounded),
          const MapEntry("Sponsorized UltraPro material", Icons.filter_1_rounded),
          const MapEntry("Pack of cards for the third round winners", Icons.calendar_view_month_outlined),
        ]),
      ),
    ];
  }
}