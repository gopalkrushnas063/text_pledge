import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PdfViewScreen extends StatefulWidget {
  final String path; // Can be asset or URL
  final bool isFromUrl;

  const PdfViewScreen({required this.path, this.isFromUrl = false});

  @override
  _PdfViewScreenState createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    widget.isFromUrl ? downloadFromUrl() : loadFromAsset();
  }

  Future<void> loadFromAsset() async {
    final bytes = await rootBundle.load(widget.path);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp_asset.pdf');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    setState(() => localPath = file.path);
  }

  Future<void> downloadFromUrl() async {
    final response = await http.get(Uri.parse(widget.path));
    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/downloaded.pdf');
      await file.writeAsBytes(response.bodyBytes);
      setState(() => localPath = file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load PDF'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Book"),
        backgroundColor: Color(0xFF4A4ED4),
      ),
      body: localPath == null
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath!,
              autoSpacing: true,
              swipeHorizontal: false,
              pageSnap: true,
            ),
    );
  }
}
