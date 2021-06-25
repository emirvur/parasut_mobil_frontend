import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muhmobil/utils/colorloader.dart';
import 'package:intl/intl.dart';

class Load {
  static final numfor = new NumberFormat("#,##0.00", "en_US");
  static double opacit = 0;
  static Widget prog = ColorLoader3();
  static font(int re) {
    switch (re) {
      case 0:
        return GoogleFonts.roboto(color: Colors.black);
        break;
      case 1:
        return GoogleFonts.roboto(color: Colors.grey);
        break;
      case 2:
        return GoogleFonts.roboto(color: Colors.red);
        break;
      case 3:
        return GoogleFonts.roboto(color: Colors.blue);
        break;
      case 4:
        return GoogleFonts.roboto();
        break;
      case 5:
        return GoogleFonts.roboto(color: Colors.white);
        break;
      case 6:
        return GoogleFonts.roboto(color: Colors.red, fontSize: 16);
        break;
      case 7:
        return GoogleFonts.roboto(color: Colors.blue, fontSize: 16);
        break;
      case 8:
        return GoogleFonts.roboto(color: Colors.grey, fontSize: 16);
        break;
      case 9:
        return GoogleFonts.sacramento(color: Colors.black);
        break;
      default:
    }
  }
}

enum renk { siyah, gri, kirmizi, mavi }
