import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

/// Represents the PDF stateful widget class.
/// class SignaturePadApp extends StatelessWidget {

typedef pdfCallback = void Function(Uint8List callbackpdf);

class PDFSigner extends StatefulWidget {
  final pdfCallback pdfcb;
  late Uint8List pdf;
  PDFSigner({Key? key, required this.pdf, required this.pdfcb});

  @override
  PDFSignerState createState() => PDFSignerState();
}

class PDFSignerState extends State<PDFSigner> {
  final GlobalKey<SfSignaturePadState> _signaturePadGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void Sign() async {
    final data =
        await _signaturePadGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final sigbytes = await data.toByteData(format: ui.ImageByteFormat.png);
    PdfDocument document = PdfDocument(inputBytes: widget.pdf);
    PdfPage page = document.pages[0];

    page.graphics?.drawImage(PdfBitmap(sigbytes!.buffer.asUint8List()),
        const Rect.fromLTWH(350, 500, 125, 100));
    document.form.flattenAllFields();   
    widget.pdf = Uint8List.fromList(await document.save());
    document.dispose();
    //widget.pdfcb(widget.pdf); //set state in doc
    setState(() {});
  }

  //Clear the signature in the SfSignaturePad.
  void ClearSignature() {
    _signaturePadGlobalKey.currentState!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            //add actions here
            ),
        body: Column(
          children: [
            Expanded(
              child: SfPdfViewer.memory(
                widget.pdf,
              ),
            ),
            Container(
              height: 200,
              margin: const EdgeInsets.only(
                  left: 8.0, top: 2.0, bottom: 2.0, right: 8.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 230, 205, 231),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 100,
                      width: 300,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: SfSignaturePad(
                          key: _signaturePadGlobalKey,
                          backgroundColor: Colors.white,
                          strokeColor: Colors.black,
                          minimumStrokeWidth: 1.0,
                          maximumStrokeWidth: 4.0),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                          child: const Text('Add Signature'),
                          onPressed: Sign,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                          child: const Text('Clear'),
                          onPressed: ClearSignature,
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            )
          ],
        ));
  }
}
