import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package
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

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTitleWidget(),
          const SizedBox(height: 20),
          _buildSectionWidget(),
          const SizedBox(height: 20),
          _buildColumnWidget(isMobile),
          const SizedBox(height: 20),
          _buildCarouselSlider(), // Add the carousel slider here
        ],
      ),
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
      child: !isMobile
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: _buildItemsWidgets(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: _buildItemsWidgets(),
            ),
    );
  }

  Widget _buildSectionWidget() {
    return const Text(
      "Winner prizes will be distributed in a pyramid manner based on the number of participants. Everyone will receive the welcome pack as door prize.",
    );
  }

  List<Widget> _buildItemsWidgets() {
    return [
      PrizeTile(
        title: "WELCOME PACK",
        lines: Map.fromEntries([
          const MapEntry("Grand Prix circuit playmat", Icons.tab_rounded),
          const MapEntry("Grand Prix circuit promo card", Icons.calendar_view_month_outlined),
          const MapEntry("Other gifts TBA soon", Icons.calendar_view_month_outlined),
        ]),
      ),
      const SizedBox(height: 20),
      PrizeTile(
        title: "PRIZES",
        lines: Map.fromEntries([
          const MapEntry("Original 'One With the Land' Art, realized by Riccardo Fabiani", Icons.filter_1_rounded),
          const MapEntry("Commemorative Metal Rings for top 10 players", Icons.panorama_horizontal_select),
          const MapEntry("Sponsorized UltraPro material", Icons.filter_none_rounded),
          const MapEntry("Special prize TBA for the third round winners", Icons.calendar_view_month_outlined),
        ]),
      ),
    ];
  }

  Widget _buildCarouselSlider() {
    final List<String> imagePaths = [
      "assets/images/prizes/event1.jpeg",
      "assets/images/prizes/event2.jpeg",
      "assets/images/prizes/event3.jpeg",
    ];

    return CarouselSlider(
      items: imagePaths.map((imagePath) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: MediaQuery.of(context).size.width - 32,
            height: 300,
            fit: BoxFit.cover,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 300,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
    );
  }
}
