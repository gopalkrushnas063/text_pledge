import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PermissionLetter extends StatefulWidget {
  const PermissionLetter({super.key});

  @override
  State<PermissionLetter> createState() => _PermissionLetterState();
}

class _PermissionLetterState extends State<PermissionLetter> {
  bool _isLoading = true;
  String? _errorMessage;
  String? _localPath;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAssets();
  }

  Future<void> _loadPdfFromAssets() async {
    try {
      final ByteData data = await rootBundle.load(
        'assets/pdf/Permission_Slip.pdf',
      );
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = '${tempDir.path}/permission_slip_temp.pdf';
      final File tempFile = File(tempPath);
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);

      setState(() {
        _localPath = tempPath;
        _isLoading = false;
        if (_localPath == null) {
          _errorMessage = 'Failed to create local copy of PDF';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading PDF from assets: $e';
      });
      print('Error loading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Permission and Media Release'),
        centerTitle: true,
        actions: [
          if (_isReady)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '${_currentPage + 1}/$_totalPages',
                  style: const TextStyle(fontSize: 16),
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
    return Stack(
      children: [
        if (_localPath != null)
          PDFView(
            filePath: _localPath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: true,
            pageFling: true,
            fitPolicy: FitPolicy.BOTH,
            nightMode: false,
            onRender: (pages) {
              setState(() {
                _totalPages = pages!;
                _isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                _errorMessage = error.toString();
                _isLoading = false;
              });
            },
            onPageError: (page, error) {
              setState(() {
                _errorMessage = 'Page $page: ${error.toString()}';
              });
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
          ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
        if (_errorMessage != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      _loadPdfFromAssets();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
      ],
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
              icon: const Icon(Icons.arrow_back_ios, size: 28),
              onPressed:
                  _currentPage == 0
                      ? null
                      : () {
                        _pdfViewController?.setPage(_currentPage - 1);
                      },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 28),
              onPressed:
                  _currentPage == _totalPages - 1
                      ? null
                      : () {
                        _pdfViewController?.setPage(_currentPage + 1);
                      },
            ),
          ],
        ),
      ),
    );
  }
}
