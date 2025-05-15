import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class FullScreenPdfViewer extends StatefulWidget {
  final String pdfPath;
  final bool isAsset;

  const FullScreenPdfViewer({
    required this.pdfPath,
    this.isAsset = false,
  });

  @override
  _FullScreenPdfViewerState createState() => _FullScreenPdfViewerState();
}

class _FullScreenPdfViewerState extends State<FullScreenPdfViewer> {
  String? _localPath;
  int? _totalPages;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;
  bool _isReady = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.isAsset ? _loadFromAsset() : _downloadFromUrl();
  }

  Future<void> _loadFromAsset() async {
    try {
      final bytes = await rootBundle.load(widget.pdfPath);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp_asset.pdf');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      setState(() {
        _localPath = file.path;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PDF: $e')),
      );
    }
  }

  Future<void> _downloadFromUrl() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfPath));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/downloaded.pdf');
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          _localPath = file.path;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download PDF')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Book"),
        backgroundColor: Color(0xFF4A4ED4),
        actions: [
          if (_isReady)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '${_currentPage + 1}/${_totalPages ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _isReady ? _buildBottomNavBar() : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_localPath == null) {
      return Center(child: Text('Failed to load PDF'));
    }

    return PDFView(
      filePath: _localPath,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: true,
      pageFling: true,
      fitPolicy: FitPolicy.BOTH,
      onRender: (pages) {
        setState(() {
          _totalPages = pages;
          _isReady = true;
        });
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF Error: $error')),
        );
      },
      onPageError: (page, error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Page $page Error: $error')),
        );
      },
      onViewCreated: (PDFViewController controller) {
        _pdfViewController = controller;
      },
      onPageChanged: (int? page, int? total) {
        setState(() {
          if (page != null) _currentPage = page;
          if (total != null) _totalPages = total;
        });
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 28),
              onPressed: _currentPage == 0
                  ? null
                  : () => _pdfViewController?.setPage(_currentPage - 1),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 28),
              onPressed: _currentPage == (_totalPages! - 1)
                  ? null
                  : () => _pdfViewController?.setPage(_currentPage + 1),
            ),
          ],
        ),
      ),
    );
  }
}