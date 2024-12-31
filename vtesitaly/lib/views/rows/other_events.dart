import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Sostituisci con il tuo file di configurazione o la tua costante
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/components/rules_tile.dart';
import 'package:vtesitaly/views/components/section_title.dart';

class OtherEventsRow extends StatefulWidget {
  const OtherEventsRow({super.key});

  @override
  State<OtherEventsRow> createState() => _OtherEventsRowState();
}

class _OtherEventsRowState extends State<OtherEventsRow> {
  final Uri _url = Uri.parse('http://bcncrisis.com/tournament/462');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildTitleWidget(),
          const SizedBox(height: 8),
          _buildTournamentInfo(), // Nuova riga aggiunta
          const SizedBox(height: 20),
          _buildLinkWidget(),
          const SizedBox(height: 20),
          _buildImageWidget(isMobile),
        ],
      ),
    );
  }

  Widget _buildTitleWidget() {
    return const SectionTitle(
      title: "Side Events",
      subtitle: "In addition to the Grand Prix, we will be hosting another event on Sunday, in the same location."
    );
  }

  Widget _buildTournamentInfo() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RuleTile(
          iconData: Icons.refresh,
          title: "2 Rounds + Final",
        ),
        RuleTile(
          iconData: Icons.hourglass_bottom_rounded,
          title: "2 Hour Time Limit",
        ),
        RuleTile(
          iconData: Icons.tab_rounded,
          title: "Proxies are allowed",
        ),
        RuleTile(
          iconData: Icons.euro,
          title: "35€ Fee - lunch included",
        ),
      ],
    );
  }

  Widget _buildLinkWidget() {
    return Text.rich(
      TextSpan(
        text: "Subscriptions on bcncrisis.com",
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          decorationColor: Colors.blue,
          fontSize: 30,
          fontWeight: FontWeight.w400,
        ),
        recognizer: TapGestureRecognizer()..onTap = _launchUrl,
      ),
    );
  }

  Widget _buildImageWidget(bool isMobile) {
    final double size = !isMobile
        ? min(480, MediaQuery.of(context).size.width / 2 - 32)
        : MediaQuery.of(context).size.width - 32;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        "assets/images/KarlSchrekt.jpeg",
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
