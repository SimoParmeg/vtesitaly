import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Sostituisci con il tuo file di configurazione o la tua costante
import 'package:vtesitaly/config.dart';

class OtherEventsRow extends StatefulWidget {
  const OtherEventsRow({super.key});

  @override
  State<OtherEventsRow> createState() => _OtherEventsRowState();
}

class _OtherEventsRowState extends State<OtherEventsRow> {
  // URL da lanciare
  final Uri _url = Uri.parse('http://bcncrisis.com/tournament/462');

  // Metodo per lanciare l’URL nel browser
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Testo sopra
          _buildTitleWidget(),
          const SizedBox(height: 20),
          // Immagine sotto
          _buildImageWidget(isMobile),
        ],
      ),
    );
  }

  // Widget per il titolo e il testo (compreso il link cliccabile)
  Widget _buildTitleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Side Events",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Testo con link cliccabile
        Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
            children: [
              const TextSpan(
                text:
                    "In addition to the Grand Prix, we will be hosting another event on Sunday, in the same location.",
              ),
              TextSpan(
                text: " Subscriptions on bcncrisis.com",
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                // TapGestureRecognizer per gestire il click
                recognizer: TapGestureRecognizer()..onTap = _launchUrl,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Widget per l'immagine
  Widget _buildImageWidget(bool isMobile) {
    final double size = !isMobile
        ? min(500, MediaQuery.of(context).size.width / 2 - 32)
        : MediaQuery.of(context).size.width - 32;

    return Image.asset(
      "assets/images/KarlSchrekt.jpeg",
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
