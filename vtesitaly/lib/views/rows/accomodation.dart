import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/accomodation_tile.dart';


class AccomodationRow extends StatefulWidget {

  const AccomodationRow({Key? key}) : super(key: key);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumnWidget(),
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
        _buildColumnWidget(),
        const SizedBox(height:20),
        _buildImageWidget(isMobile)
      ]
    );

  }


Widget _buildTitleWidget() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Accomodation",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 36, 
          color: Colors.blue, 
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 8), // Spaziatura tra i testi
      Text(
        "Where should I stay?",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
      ),
    ],
  );
}


Widget _buildColumnWidget() {
  return Expanded(
    child: ListView(
      shrinkWrap: true,
      children: const [
        AccomodationTile(
          icondata: Icon(Icons.info, color: Colors.white),
          title: "Hotel Baia del Re ****",
          subtitle: "The event will take place at this hotel",
        ),
        AccomodationTile(
          icondata: Icon(Icons.info, color: Colors.white),
          title: "Villa Aurora B&B",
          subtitle: "5 minutes walking from the tournament location"
        ),
        AccomodationTile(
          icondata: Icon(Icons.info, color: Colors.white),
          title: "B&B Anna",
          subtitle: "5 minutes by car from the tournament location"
        )
      ],
    ),
  );
}


  Widget _buildImageWidget(bool isMobile){
    
    return Image.asset(
      "assets/images/charisma.jpeg",
      width: !isMobile 
        ? min(500, MediaQuery.of(context).size.width/2-32) 
        : MediaQuery.of(context).size.width-32,
      height: !isMobile 
        ? min(500, MediaQuery.of(context).size.width/2-32) 
        : MediaQuery.of(context).size.width-32,
      fit: BoxFit.cover,
    );
  }


  Widget _buildCircleWithText(String number) {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      radius: 20,
      child: Text(
        number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}