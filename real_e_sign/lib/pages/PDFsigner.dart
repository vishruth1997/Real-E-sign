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
  late Uint8List currentPDF; //working file pdf
  final GlobalKey<SfSignaturePadState> _signaturePadGlobalKey = GlobalKey();
  var isSaved = "";
  @override
  void initState() {
    super.initState();
    currentPDF = widget.pdf;
  }

  void Sign(int PageNumber, Offset Position) async {
    print("Signing");
    print(PageNumber);
    print(Position.dx);
    print(Position.dy);
    final data =
        await _signaturePadGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final sigbytes = await data.toByteData(format: ui.ImageByteFormat.png);
    PdfDocument document = PdfDocument(inputBytes: currentPDF);
    PdfPage page = document.pages[PageNumber];
    //center the sig on the click
    double xPos = Position.dx - 75; 
    double yPos = Position.dy - 25; 
    page.graphics?.drawImage(PdfBitmap(sigbytes!.buffer.asUint8List()),
        Rect.fromLTWH(xPos, yPos, 150, 50));
    document.form.flattenAllFields();
    currentPDF = Uint8List.fromList(await document.save());
    document.dispose();

    setState(() {});
  }

  // save the working pdf to the original pdf bytes (not on disk file) passed from select document
  void Save() {
    widget.pdfcb(currentPDF);
    setState(() {
      isSaved = "Saved PDF!";
    });
  }

  //Clear the signature in the pad and reset the pdf to the widget.pdf
  void ClearSignature() {
    _signaturePadGlobalKey.currentState!.clear();
    currentPDF = widget.pdf;
    setState(() {});
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
                child: SfPdfViewer.memory(currentPDF,
                    onTap: (PdfGestureDetails details) {
              print("tappy");
              Sign(details.pageNumber - 1, details.pagePosition);
            })),
            Container(
              height: 220,
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
                          child: const Text('Save'),
                          onPressed: Save,
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
                  ),
                  Text(isSaved)
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            )
          ],
        ));
  }
}
