// ignore_for_file: unused_element, library_private_types_in_public_api

import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/services.dart' show rootBundle;
import 'package:vtesitaly/config.dart';

class EventRow extends StatefulWidget {
  const EventRow({super.key});

  @override
  State<EventRow> createState() => _EventRowState();
}

class _EventRowState extends State<EventRow> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;

    return !isMobile
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildColumnWidget(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: _buildImageWidget(isMobile),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageWidget(isMobile),
              const SizedBox(height: 20),
              _buildColumnWidget(),
              const SizedBox(height: 40),
            ],
          );
  }

  Widget _buildColumnWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Italian ",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              TextSpan(
                text: "Grand Prix ",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              TextSpan(
                text: "2024-25",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text("Modena, Italy", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black54)),
        const SizedBox(height: 4),
        const Text("March 1st, 2025", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.blue)),
        const SizedBox(height: 20),
        const Text(
          "TOURNAMENT IS OVER. CONGRATS TO FREDERIC FOR THE VICTORY", 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.red)
        ),
                const Text(
          "AND THANKS TO ALL PARTECIPANT FROM THE COMMUNITY OF MODENA!", 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.red)
        ),
      ],
    );
  }

  Widget _buildImageWidget(bool isMobile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        "assets/images/logo_gp.png",
        width: !isMobile ? min(475, MediaQuery.of(context).size.width / 2 - 32) : MediaQuery.of(context).size.width - 64,
        height: !isMobile ? min(475, MediaQuery.of(context).size.width / 2 - 32) : MediaQuery.of(context).size.width - 64,
        fit: BoxFit.cover,
      ),
    );
  }
}


class ExcelTableWidget extends StatefulWidget {
  const ExcelTableWidget({super.key});

  @override
  _ExcelTableWidgetState createState() => _ExcelTableWidgetState();
}

class _ExcelTableWidgetState extends State<ExcelTableWidget> {
  List<List<String>> tableData = [];
  final ScrollController _scrollController = ScrollController();
  late Timer _scrollTimer;
  final int rowsPerScroll = 6;
  double rowHeight = 48.0;

  @override
  void initState() {
    super.initState();
    _loadExcelData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    bool isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;
    if (isMobile) return;

    _scrollTimer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (_scrollController.hasClients) {
        double maxScrollExtent = _scrollController.position.maxScrollExtent;
        double currentPosition = _scrollController.position.pixels;
        double scrollAmount = rowsPerScroll * rowHeight;

        _scrollController.animateTo(
          currentPosition + scrollAmount <= maxScrollExtent
              ? currentPosition + scrollAmount
              : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadExcelData() async {
    ByteData data = await rootBundle.load("assets/archon/archon.xlsx");
    Uint8List bytes = data.buffer.asUint8List();
    var excelFile = excel.Excel.decodeBytes(bytes);

    List<List<String>> rows = [];

    if (excelFile.tables.containsKey("Standings")) {
      var sheet = excelFile.tables["Standings"]!;
      int headerRowIndex = 0; 

      if (headerRowIndex < sheet.maxRows) {
        rows.add(["Final Rank", "Name", "Prelim GWs", "Prelim VPs", "Final VPs", "TPs"]);

        for (int i = 1; i < sheet.maxRows; i++) {
          var row = sheet.rows[i];

          if (row.length >= 6 && row[0]?.value != null) {
            rows.add([
            row[0]?.value.toString() ?? "", // Final Rank
            row[1]?.value.toString() ?? "", // Name
            row[2]?.value.toString() ?? "", // Prelim GWs
            row[3]?.value.toString() ?? "", // Prelim VPs
            row[4]?.value.toString() ?? "", // Final VPs
            row[5]?.value.toString() ?? "", // TPs
          ]);
          }
        }
      }
    }

    setState(() {
      tableData = rows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return tableData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Container(
            height: 346,
            width: 600,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 600,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 3,
                      headingRowColor:
                          WidgetStateColor.resolveWith((states) => Colors.blue.shade100),
                      dataRowColor: WidgetStateColor.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? Colors.blue.shade200
                              : Colors.white),
                      border: TableBorder.all(color: Colors.grey),
                      columns: const [
                        DataColumn(label: Text("Final Rank", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Prelim GWs", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Prelim VPs", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Final VPs", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("TPs", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: tableData.skip(1).map((row) {
                        return DataRow(
                          cells: row.map((cell) => DataCell(Text(cell))).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
        );
    }
}