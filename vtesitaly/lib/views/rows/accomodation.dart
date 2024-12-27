import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/accomodation_tile.dart';
import 'package:vtesitaly/views/components/section_title.dart';


class AccomodationRow extends StatefulWidget {

  const AccomodationRow({super.key});

  @override
  State<AccomodationRow> createState() => _AccomodationRowState();
}

class _AccomodationRowState extends State<AccomodationRow> {

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    
    return !isMobile ? Column(
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColumnWidget(isMobile),
            _buildImageWidget(isMobile)
          ]
        ),
      ],
    ) : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        _buildColumnWidget(isMobile),
        const SizedBox(height:20),
        _buildImageWidget(isMobile)
      ]
    );
  }

  Widget _buildTitleWidget() {
    return const SectionTitle(
      title: "Accomodation",
      subtitle: "Where should I stay?"
    );
  }

  Widget _buildColumnWidget(bool isMobile) {
    return SizedBox(
      height: 350,
      width: !isMobile ? 480 : MediaQuery.of(context).size.width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: AccomodationTile(
              icondata: Icon(Icons.info, color: Colors.white),
              title: "Hotel Baia del Re ****",
              subtitle: "The event will take place at this hotel, see module for reservation",
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: AccomodationTile(
              icondata: Icon(Icons.info, color: Colors.white),
              title: "Villa Aurora B&B",
              subtitle: "5 minutes walking from the tournament location"
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: AccomodationTile(
              icondata: Icon(Icons.info, color: Colors.white),
              title: "B&B Anna",
              subtitle: "5 minutes by car from the tournament location"
            ),
          )
        ],
      ),
    );
  }


  Widget _buildImageWidget(bool isMobile){
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        "assets/images/charisma.jpeg",
        width: !isMobile 
          ? min(480, MediaQuery.of(context).size.width/2-32) 
          : MediaQuery.of(context).size.width-32,
        height: !isMobile 
          ? min(480, MediaQuery.of(context).size.width/2-32) 
          : MediaQuery.of(context).size.width-32,
        fit: BoxFit.cover,
      )
    );
  }
}