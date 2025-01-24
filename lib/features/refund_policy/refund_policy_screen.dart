import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class RefundPolicyScreen extends StatefulWidget {
  const RefundPolicyScreen({Key? key}) : super(key: key);

  @override
  State<RefundPolicyScreen> createState() => _RefundPolicyScreenState();
}

class _RefundPolicyScreenState extends State<RefundPolicyScreen> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPdfFile();
  }

  Future<void> loadPdfFile() async {
    try {
      final ByteData bytes =
          await rootBundle.load('assets/pdf/CommercePal Refund Policy.pdf');
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/refund_policy.pdf');

      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Refund Policy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath == null
              ? const Center(child: Text('Error loading PDF'))
              : PDFView(
                  filePath: localPath!,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                  pageSnap: true,
                  fitPolicy: FitPolicy.BOTH,
                  onError: (error) {
                    print('Error: $error');
                  },
                ),
    );
  }
}
