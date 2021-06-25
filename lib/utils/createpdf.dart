import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muhmobil/model/dtofatode.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future pdfpaylas(
    String ad, String duztar, dynamic lis, List<dynamic> lis1) async {
  final pdf = pw.Document();
  if (lis is Dtofattahs) {
    pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text("Ilgili Firma:"),
                      pw.Text(turkcekar(ad)),
                    ]),
                    pw.Column(children: [
                      pw.Text("Duzenleme Tarihi:"),
                      pw.Text(duztar),
                    ]),
                  ]),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Urun Adi', 'Birim Fiyat', 'Miktar', 'Vergi'],
                ...lis1.map((msg) => [
                      turkcekar(msg.ad),
                      turkcekar(msg.brfiyat.toString()),
                      turkcekar(msg.miktar.toString()),
                      turkcekar(msg.vergi.toString())
                    ]),
              ]),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text("Tahsil edilen miktar:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(lis.alinmism.toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
              ]),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text("Genel Toplam:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(lis.geneltoplam.toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
              ]),
            ])));
    var x = pdf.save();
    return x;
  } else if (lis is Dtofatode) {
    pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text("Ilgili Firma:"),
                      pw.Text(turkcekar(ad)),
                    ]),
                    pw.Column(children: [
                      pw.Text("Duzenleme Tarihi:"),
                      pw.Text(duztar),
                    ]),
                  ]),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Urun Adi', 'Birim Fiyat', 'Miktar', 'Vergi'],
                ...lis1.map((msg) => [
                      turkcekar(msg.ad),
                      turkcekar(msg.brfiyat.toString()),
                      turkcekar(msg.miktar.toString()),
                      turkcekar(msg.vergi.toString())
                    ]),
              ]),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text("Odenen miktar:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(lis.odendimik.toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
              ]),
              pw.SizedBox(height: 10),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text("Genel Toplam:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(lis.geneltoplam.toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
              ]),
            ])));

    var x = pdf.save();
    return x;
  } else if (lis1 is List<Dtofattahs>) {
    pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text("Ilgili Firma:"),
                      pw.Text(ad),
                    ]),
                    pw.Column(children: [
                      pw.Text("Bakiye:"),
                      pw.Text(lis.bakiye.toString()),
                    ]),
                  ]),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Fatura aciklamasi',
                  'Duzenleme Tarihi',
                  'Vade Tarihi',
                  'Kalan Meblag'
                ],
                ...lis1.map((msg) => [
                      "q" //msg.fataciklama,
                          "f" // msg.duztarih.toString(),
                          "d" //   msg.vadta.toString(),
                          "" //   "${msg.geneltoplam - msg.alinmism}" //  msg.vergi.toString()
                    ]),
              ]),
              pw.Text("ytfhgfgf")
            ])));
    var x = pdf.save();
    return x;
  } else if (1 == 1) {
    pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text("Ilgili Firma:"),
                      pw.Text("ad"),
                    ]),
                    pw.Column(children: [
                      pw.Text("Bakiye:"),
                      pw.Text("lis.bakiye.toString()"),
                    ]),
                  ]),
              pw.SizedBox(height: 20),
              pw.Text("ytfhgfgf")
            ])));

    var x = pdf.save();
    return x;
  }
}

String turkcekar(String x) {
  return x
      .replaceAll("ö", "o")
      .replaceAll("ş", "s")
      .replaceAll("ü", "u")
      .replaceAll("ç", "c")
      .replaceAll("ı", "i")
      .replaceAll("ğ", "g")
      .replaceAll("Ö", "O")
      .replaceAll("Ş", "S")
      .replaceAll("Ü", "U")
      .replaceAll("Ç", "C")
      .replaceAll("İ", "I")
      .replaceAll("Ğ", "G");
}

Future ekstrepdfmusteri(String ad, List<Dtofattahs> lis) async {
  num g = 0;
  print("111");
  for (var i in lis) {
    print("222");
    print(i.geneltoplam.toString());
    print(i.alinmism.toString());
    // num x = num.tryParse(Load.numfor.format(i.geneltoplam));
    print("kk");
    //print(x.toString());
    //  num y = num.tryParse(Load.numfor.format(i.alinmism));
    print("ll");
    //print(y.toString());
    //int n = x.toInt();
    //  int m = y.toInt();
    g = g + (i.geneltoplam - i.alinmism);
    print("xx");
    print("33");
  }
  print("444");
  final pdf = pw.Document();
  pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.Text("Buse Tekstil"),
                    //  pw.Text("ad"),
                  ]),
                  pw.Column(children: [
                    pw.Text("Ilgili Firma:"),
                    pw.Text(turkcekar(ad)),
                  ]),
                ]),
            pw.SizedBox(height: 20),
            pw.Text("ISLEM DOKUMU"),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>[
                'Islem Tarihi',
                'Aciklama',
                'Vade Tarihi',
                'Kalan Meblag'
              ],
              ...lis.map((msg) => [
                    msg.duztarih.toString(),
                    turkcekar(msg.fataciklama),
                    msg.vadta.toString(),
                    (msg.geneltoplam - msg.alinmism).toString()
                    //        Load.numfor.format((msg.geneltoplam - msg.alinmism)
                    //              .toString()) //  "${msg.geneltoplam - msg.alinmism}" //  msg.vergi.toString()
                  ]),
            ]),
            pw.SizedBox(height: 20),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text("Toplam Borc:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(g.toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
              ]),
              //  pw.Text(turkcekar("ööööö"))
            ]),
            pw.Spacer(),
            pw.Text(
                "Bu fatura ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} tarihinde düzenlenmistir")
          ])));
  print("88");
  var x = await pdf.save();
  //File y=await File('deneme.pdf').writeAsBytes(x);
  //PDFDocument z=await PDFDocument.fromFile(y);
  // PDFViewer(document:z,zoomSteps: 1, );
  return x;
}

Future ekstrepdftedar(String ad, List<Dtofatode> lis) async {
  num g = 0;
  for (var i in lis) {
    g = g +
        (i.geneltoplam -
            i.odendimik); //+ num.tryParse(Load.numfor.format((i.geneltoplam - i.odendimik)));
  }
  final pdf = pw.Document();
  pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.Text("Buse Tekstil"),
                    //  pw.Text("ad"),
                  ]),
                  pw.Column(children: [
                    pw.Text("Ilgili Firma:"),
                    pw.Text(turkcekar(ad)),
                  ]),
                ]),
            pw.SizedBox(height: 20),
            pw.Text("ISLEM DOKUMU"),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>[
                'Islem Tarihi',
                'Aciklama',
                'Odeme Tarihi',
                'Kalan Meblag'
              ],
              ...lis.map((msg) => [
                    msg.duztarih.toString(),
                    turkcekar(msg.fataciklama),
                    msg.odenecektar.toString(),
                    (msg.geneltoplam - msg.odendimik).toString()
                    //         Load.numfor.format((msg.geneltoplam - msg.odendimik)
                    //           .toString()) //  "${msg.geneltoplam - msg.alinmism}" //  msg.vergi.toString()
                  ]),
            ]),
            pw.SizedBox(height: 20),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text("Toplam Odenecek:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(g.toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
              ]),
              //  pw.Text(turkcekar("ööööö"))
            ]),
            pw.Spacer(),
            pw.Text(
                "Bu fatura ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} tarihinde düzenlenmistir")
          ])));
  var x = await pdf.save();
  //File y=await File('deneme.pdf').writeAsBytes(x);
  //PDFDocument z=await PDFDocument.fromFile(y);
  // PDFViewer(document:z,zoomSteps: 1, );
  return x;
}

Future izlemepdf() async {
  final pdf = pw.Document();
  pdf.addPage(pw.Page(
      build: (pw.Context context) => pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.Text("a"),
                    pw.Text("ad"),
                  ]),
                  pw.Column(children: [
                    pw.Text("d"),
                    pw.Text("b"),
                  ]),
                ]),
            pw.SizedBox(height: 20),
            pw.Text("k")
          ])));
  print("11");
  var x = await pdf.save();
  print("22");
  final Directory directory = await getApplicationDocumentsDirectory();
  print("${directory.path}");
  final File y = File('${directory.path}/my_file.pdf');
  print("44");
  await y.writeAsBytes(x);
  print("55");
  // File y = await File('deneme.pdf').writeAsBytes(x);
  PDFDocument z = await PDFDocument.fromFile(y);
  print("66");
  // PDFViewer(document:z,zoomSteps: 1, );
  return z;
}
