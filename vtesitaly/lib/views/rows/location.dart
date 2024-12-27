import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/accomodation_tile.dart';
import 'package:vtesitaly/views/components/section_title.dart';

class LocationRow extends StatefulWidget {

  const LocationRow({super.key});

  @override
  State<LocationRow> createState() => _LocationRowState();
}

class _LocationRowState extends State<LocationRow> {

  final Uri _url = Uri.parse('/assets/docs/Reservation Form VTES25.doc');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    
    return !isMobile ? Column(
      children: [
        _buildTitleWidget(),
        const SizedBox(height:20),
        _buildSectionWidget(),
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
        _buildSectionWidget(),
        const SizedBox(height:20),
        _buildColumnWidget(isMobile),
        const SizedBox(height:20),
        _buildImageWidget(isMobile)
      ]
    );
  }

  Widget _buildTitleWidget() {
    return const SectionTitle(
      title: "Hotel Baia del Re ****",
      subtitle: "Str. Vignolese, 1684, 41126 Modena (MO)",
    );
  }

  Widget _buildSectionWidget() {
    return GestureDetector(
      onTap: _launchUrl,
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "Discounted Reservations: ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 27,
                fontWeight: FontWeight.w500
              )
            ),
            TextSpan(
              text: "Module",
              style: TextStyle(
                color: Colors.green,
                fontSize: 27,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: Colors.green
              )
            )
          ]
        )
      ),
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
              icondata: Icon(Icons.airplanemode_on_outlined, color: Colors.white),
              title: "Airplane",
              subtitle: "Bologna Marconi airport is 35 km away",
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: AccomodationTile(
              icondata: Icon(Icons.bus_alert_outlined, color: Colors.white),
              title: "Public Transport",
              subtitle: "Modena bus station, take the extra-urban bus to Vignola (#731), “Ponte Guerro” stop is about 500 m from the hotel",
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: AccomodationTile(
              icondata: Icon(Icons.car_rental_outlined, color: Colors.white),
              title: "Car",
              subtitle: "200m from the 'Modena Sud' highway exit"
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildImageWidget(bool isMobile){
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        "assets/images/Aintzane_Arriaga.jpeg",
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