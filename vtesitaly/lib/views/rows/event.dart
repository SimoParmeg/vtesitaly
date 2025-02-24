import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/services.dart' show rootBundle;
import 'package:vtesitaly/config.dart';
import 'package:vtesitaly/views/forms/registration.dart';

class EventRow extends StatefulWidget {
  const EventRow({super.key});

  @override
  State<EventRow> createState() => _EventRowState();
}

class _EventRowState extends State<EventRow> {
  late Timer _timer;
  Duration _remainingTime = const Duration();
  final DateTime _targetDateTime = DateTime(2025, 3, 1, 9, 30, 0);
  String formattedCountdown = "";
  bool mouseOverSubscribe = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _remainingTime = _targetDateTime.difference(now);

      if (_remainingTime.isNegative) {
        _timer.cancel();
        formattedCountdown = "Event Started!";
      } else {
        final int totalDays = _remainingTime.inDays;
        final int years = totalDays ~/ 365;
        final int months = (totalDays % 365) ~/ 30;
        final int days = (totalDays % 365) % 30;
        final int hours = _remainingTime.inHours % 24;
        final int minutes = _remainingTime.inMinutes % 60;
        final int seconds = _remainingTime.inSeconds % 60;

        formattedCountdown = '${years > 0 ? "$years anni " : ""}'
            '${months > 0 ? "$months months " : ""}'
            '${days > 0 ? "$days days " : ""}'
            '${hours.toString().padLeft(2, '0')}:'  
            '${minutes.toString().padLeft(2, '0')}:'  
            '${seconds.toString().padLeft(2, '0')}';
      }
    });
  }

  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const SubscriptionForm(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < TRESHOLD_MOBILEMAXWIDTH;

    return !isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Flexible(child: _buildColumnWidget()), 
                    _buildImageWidget(isMobile),
                ],
                ),
                const SizedBox(height: 20),
                const Text(
                "Table Seating - Round 1:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const ExcelTableWidget(),
                const SizedBox(height: 20),
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
              const Text(
                "Table Seating - Round 1:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const ExcelTableWidget(),
              const SizedBox(height: 20),
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
        const SizedBox(height: 12),
        Text(
          formattedCountdown,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        const SizedBox(height: 20),
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

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    ByteData data = await rootBundle.load("assets/archon/archon.xlsx");
    Uint8List bytes = data.buffer.asUint8List();
    var excelFile = excel.Excel.decodeBytes(bytes);

    List<List<String>> rows = [];

    if (excelFile.tables.containsKey("Round 1")) {
      var sheet = excelFile.tables["Round 1"]!;
      int headerRowIndex = 0; // Supponiamo che la riga 6 contenga le intestazioni

      if (headerRowIndex < sheet.maxRows) {
        // Aggiungere le intestazioni
        rows.add(["Table #", "First Name", "Last Name", "Seat Number"]);

        String? currentTable;
        int seatNumber = 1;

        for (int i = headerRowIndex + 1; i < sheet.maxRows; i++) {
          var row = sheet.rows[i];

          if (row.length >= 4 && row[0]?.value != null) {
            String tableNumber = row[3]?.value.toString() ?? "";

            // Se cambiamo table #, resettiamo seatNumber a 1
            if (currentTable != tableNumber) {
              currentTable = tableNumber;
              seatNumber = 1;

              rows.add(["Table $tableNumber", "", "", ""]);
            }

            rows.add([
              tableNumber, // Table
              row[1]?.value.toString() ?? "", // First Name
              row[2]?.value.toString() ?? "", // Last Name
              seatNumber.toString(), // Seat Number
            ]);

            // Incrementa seatNumber
            seatNumber += 1;
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
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Bordo tabella
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: WidgetStateColor.resolveWith((states) => Colors.blue.shade100), // Sfondo intestazioni
                dataRowColor: WidgetStateColor.resolveWith(
                  (states) => states.contains(WidgetState.selected) ? Colors.blue.shade200 : Colors.white,
                ),
                border: TableBorder.all(color: Colors.grey), // Bordo celle
                columns: tableData.first
                    .map((col) => DataColumn(label: Text(col, style: const TextStyle(fontWeight: FontWeight.bold))))
                    .toList(),
                rows: tableData.skip(1).map((row) {
                  bool isSeparator = row[1] == "" && row[2] == "" && row[3] == "";
                  return DataRow(
                    cells: row.map((cell) {
                      return DataCell(
                        Text(
                          cell,
                          style: TextStyle(
                            fontWeight: isSeparator ? FontWeight.bold : FontWeight.normal,
                            fontSize: isSeparator ? 16 : 14,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          );
  }
}