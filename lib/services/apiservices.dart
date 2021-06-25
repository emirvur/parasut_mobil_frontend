import 'dart:convert';

import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/model/dtofatode.dart';
import 'package:muhmobil/model/dtofattahs.dart';
import 'package:http/http.dart' as http;
import 'package:muhmobil/model/dtoirsaliye.dart';
import 'package:muhmobil/model/dtoirsurunhar.dart';
import 'package:muhmobil/model/dtokasahar.dart';
import 'package:muhmobil/model/dtoodeharfat.dart';
import 'package:muhmobil/model/dtostokdetay.dart';
import 'package:muhmobil/model/dtotahsharfat.dart';
import 'package:muhmobil/model/dtourun.dart';
import 'package:muhmobil/model/dtourungecmisi.dart';
import 'package:muhmobil/model/dtourunhareket.dart';
import 'package:muhmobil/model/gunceldurummod.dart';
import 'package:muhmobil/model/gunceldurummod1.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/model/kasahar.dart';
import 'package:muhmobil/model/labelcari.dart';
import 'package:muhmobil/model/odeput.dart';
import 'package:muhmobil/model/postfat.dart';
import 'package:muhmobil/model/tahsput.dart';
import 'package:muhmobil/model/urun.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIServices {
/* 
todo 1. kullanıcı eklede 500 status codeu duzelt
*/
  static String tok = "1";
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${APIServices.tok}'
  };

  static String url =
      // Platform.isAndroid
      //? "https://192.168.1.103:45455"
      //:
      //  "https://localhost:44311";
      //  "https://192.168.1.104:45455";
      "yourApiUrl";
  // "https://10.0.2.2:8080";

  //"https://localhost:44311";

  static Future tokenal() async {
    print("token al baslıyr");

    http.Response res =
        await http.get("$url/api/calisans/token", headers: header);
    print(res.statusCode.toString());
    if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    var re = json.decode(res.body);
    APIServices.tok = re;
    APIServices.header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $re'
    };
    print(re.toString());
    print("tokenaall bitii");
    return re;
  }

  static Future tokentest() async {
    print("urun ara baslıyr");
    SharedPreferences sp = await SharedPreferences.getInstance();
    var re = sp.getString("token");

    header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $re'
    };
    http.Response res = await http.get("$url/weatherforecast", headers: header);
    print("yy");
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      return -1;
    } else if (res.statusCode == 200) {
      print(res.statusCode.toString());
      return 0;
    } else {
      print(res.statusCode.toString());
      return 1;
    }
  }

  static Future callstp(DateTime ilk, DateTime son) async {
    print("cari ara baslıyr");
    print("tyu");
    print(header.toString());
    http.Response res =
        await http.get("$url/api/calisans/sp/$ilk/$son", headers: header);

    print(header.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        print("wer");
        print(value.toString());
        APIServices.tok = value;
        callstp(ilk, son);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Gunceldurummod> list = [];
    for (var l in re) {
      list.add(Gunceldurummod.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future kasabakiye() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/kasas/b", headers: header);
    print(header.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        kasabakiye();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    var re = json.decode(res.body);

    return re;
  }

  static Future satfatal() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/faturas/lt", headers: header);
    print(header.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        satfatal();
        print("rr");
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future satfatalara(String ad) async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/s/$ad", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        satfatalara(ad);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future irsurunharal(int id) async {
    print("ctahsfssari ara baslıyr");

    http.Response res =
        await http.get("$url/api/urunharekets/i/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        irsurunharal(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtoirsurunhar> list = [];
    for (var l in re) {
      list.add(Dtoirsurunhar.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future irsara(String id) async {
    print("ctahsfssari ara baslıyr");

    http.Response res =
        await http.get("$url/api/irsaliyes/m/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        irsara(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtoirsaliye> list = [];
    for (var l in re) {
      list.add(Dtoirsaliye.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future<List<int>> irsifatyap(int id, String ilkt, String sont) async {
    print("girdiii fat ekleye");
    var x = Map<String, dynamic>();
    //  map['cariId'] = cariId;
    x['id'] = id;
    var maps = json.encode(x);
    print(maps.toString());

    var res = await http.put(
      "$url/api/irsaliyes/$id/$ilkt/$sont",
      headers: header,
      //     body: maps
    );
    print(res.statusCode.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        irsifatyap(id, ilkt, sont);
        return;
      });
    } else if (res.statusCode != 200) {
      throw Exception;
    }
    print(res.body.toString());
    print("fff");

    List<int> l = [
      json.decode(res.body)['fatid'],
      json.decode(res.body)["tahs"]['tahsid']
    ];
    return l;
  }

  static Future tahsharfaticin(int id) async {
    print("ctahsfssari ara baslıyr");

    http.Response res =
        await http.get("$url/api/tahshars/f/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        tahsharfaticin(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtotahsharfat> list = [];
    for (var l in re) {
      list.add(Dtotahsharfat.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future<int> tedarekl(Cari kasa) async {
    print("girdiii kasa ekleye");
    var maps = json.encode(kasa.toMap(2));
    print(maps.toString());

    var res = await http.post("$url/api/caris", headers: header, body: maps);
    print(res.statusCode.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        tedarekl(kasa);
        return;
      });
    } else if (res.statusCode != 201) {
      throw Exception;
    }
    int cid = json.decode(res.body)["cariId"];
    return cid;
  }

  static Future<int> musteriekle(Cari kasa) async {
    print("girdiii kasa ekleye");
    var maps = json.encode(kasa.toMap(1));
    print(maps.toString());

    var res = await http.post("$url/api/caris", headers: header, body: maps);
    print(res.statusCode.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        musteriekle(kasa);
        return;
      });
    } else if (res.statusCode != 201) {
      throw Exception;
    }
    int cid = json.decode(res.body)["cariId"];
    return cid;
  }

  static Future<bool> tahsharguncelle(Tahsput pf) async {
    print("girdiii fat ekleye");
    var maps = json.encode(pf.toMap());
    print(maps.toString());

    var res = await http.put("$url/api/tahsilats", headers: header, body: maps);
    print(res.statusCode.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        tahsharguncelle(pf);
        return;
      });
    } else if (res.statusCode != 200) {
      throw Exception;
    }
    return Future.value(
        res.statusCode == 200 || res.statusCode == 201 ? true : false);
  }

  static Future satfatalacikfat() async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/lt/at", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        satfatalacikfat();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future satfatalkapali() async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/lt/kt", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        satfatalkapali();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future odemegecikal() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/faturas/go", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        odemegecikal();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future tahsgecikmisal() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/faturas/gt", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        tahsgecikmisal();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future alisfatara(String ara) async {
    print("fat ara baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/a/$ara", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        alisfatara(ara);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future odenecekfatal() async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/od/gt", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        odenecekfatal();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future odefatalacik() async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/od/a", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        odefatalacik();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future odefatalkapali() async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/od/k", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        odefatalkapali();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future odeharfaticin(int id) async {
    print("odeharfaticin ara baslıyr");

    http.Response res =
        await http.get("$url/api/odehars/f/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        odeharfaticin(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("testt sama");
    print("$re");
    List<Dtoodeharfat> list = [];
    for (var l in re) {
      list.add(Dtoodeharfat.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future<bool> odeharguncelle(Odeput pf) async {
    print("girdiii fat ekleye");
    var maps = json.encode(pf.toMap());
    print(maps.toString());

    var res = await http.put("$url/api/odemelers", headers: header, body: maps);
    print(res.statusCode.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        odeharguncelle(pf);
        return;
      });
    } else if (res.statusCode != 200) {
      throw Exception;
    }
    return Future.value(
        res.statusCode == 200 || res.statusCode == 201 ? true : false);
  }

  static Future musterial() async {
    print("musteri al baslıyr");

    http.Response res = await http.get("$url/api/caris/m", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        musterial();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtocarilist> list = [];
    for (var l in re) {
      list.add(Dtocarilist.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future mustara(String ara) async {
    print("cari ara baslıyr");

    http.Response res =
        await http.get("$url/api/caris/m/$ara", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        mustara(ara);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Cari> list = [];
    for (var l in re) {
      list.add(Cari.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future verial() async {
    print("cari ara baslıyr");

    http.Response res = await http.get("$url/api/calisans/v", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        verial();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Gunceldurummod1> list = [];
    for (var l in re) {
      list.add(Gunceldurummod1.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future tarihliirsaliyeal(
      int cid, DateTime ilktar, DateTime sontar) async {
    print("rsaliye al baslıyr");

    http.Response res = await http
        .get("$url/api/irsaliyes/$cid/$ilktar/$sontar", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        tarihliirsaliyeal(cid, ilktar, sontar);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtoirsaliye> list = [];
    for (var l in re) {
      list.add(Dtoirsaliye.fromMap(l));
    }
    print("sorual bitii");
    return list;

    // return List<Kullaniciliste>.from(re.map((x) => Kullaniciliste.fromMap(x)));
  }

  static Future getcariris(int cid) async {
    print("rsaliye al baslıyr");

    http.Response res =
        await http.get("$url/api/irsaliyes/c/$cid", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        getcariris(cid);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    print(res.body.toString());
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtoirsaliye> list = [];
    for (var l in re) {
      list.add(Dtoirsaliye.fromMap(l));
    }
    print("sorual bitii");
    return list;

    // return List<Kullaniciliste>.from(re.map((x) => Kullaniciliste.fromMap(x)));
  }

  static Future irsaliyeal() async {
    print("rsaliye al baslıyr");

    http.Response res = await http.get("$url/api/irsaliyes/i", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        irsaliyeal();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtoirsaliye> list = [];
    for (var l in re) {
      list.add(Dtoirsaliye.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future tedarara(String ara) async {
    print("cari ara baslıyr");

    http.Response res =
        await http.get("$url/api/caris/t/$ara", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        tedarara(ara);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Cari> list = [];
    for (var l in re) {
      list.add(Cari.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future searchmust(String ara) async {
    print("cari ara baslıyr");

    http.Response res =
        await http.get("$url/api/caris/m/$ara", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        searchmust(ara);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Labcari> list = [];
    for (var l in re) {
      list.add(Labcari.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future carialfatal(int id) async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/oc/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        carialfatal(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future satisay() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/faturas/sa", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        satisay();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future satishafta() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/faturas/sh", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        satishafta();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future satisgun() async {
    print("satisgunnnntest al baslıyr");

    http.Response res = await http.get("$url/api/faturas/sg", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        satisgun();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future alisay() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/faturas/aa", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        alisay();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future<List<int>> faturaekle(Postfatura pf) async {
    print("girdiii fat ekleye");
    //  var maps = json.encode(pf.toMap());
    var maps = json.encode(pf.toJson());
    print(maps.toString());

    var res = await http.post("$url/api/faturas", headers: header, body: maps);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        faturaekle(pf);
        return;
      });
    } else if (res.statusCode != 201) {
      throw Exception;
    }
    print(res.statusCode.toString());
    print(res.body);
    List<int> l;
    if (json.decode(res.body)['fatTur'] == 1) {
      print(json.decode(res.body)["tahs"]['tahsid'].toString());
      l = [
        json.decode(res.body)['fatid'],
        json.decode(res.body)["tahs"]['tahsid']
      ];
    } else {
      print(json.decode(res.body)["ode"]['odeid'].toString());
      l = [
        json.decode(res.body)['fatid'],
        json.decode(res.body)["ode"]['odeid']
      ];
    }

    return l;
  }

  static Future<int> tedarekle(Cari kasa) async {
    print("girdiii kasa ekleye");
    var maps = json.encode(kasa.toMap(2));
    print(maps.toString());

    var res = await http.post("$url/api/caris", headers: header, body: maps);
    print(res.statusCode.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        tedarekle(kasa);
        return;
      });
    } else if (res.statusCode != 201) {
      throw Exception;
    }
    int cid = json.decode(res.body)["cariId"];
    return cid;
  }

  static Future alishafta() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/faturas/ah", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        alishafta();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future alisgun() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/faturas/ag", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        alisgun();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future urunbarkodara(String ara) async {
    print("urun ara baslıyr");

    http.Response res = await http.get("$url/api/uruns/$ara", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        urunbarkodara(ara);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    var re = json.decode(res.body);

    return re;
  }

  static Future barkodluurun(String b) async {
    print("urun ara baslıyr");

    http.Response res = await http.get("$url/api/uruns/c/$b", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        barkodluurun(b);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    var re = json.decode(res.body);
    print("ikinci sama");
    print("$re");

    Dtourun dt = (Dtourun.fromMap(re));

    print("sorual bitii");
    return dt;
  }

  static Future urunara(String ara) async {
    print("urun ara baslıyr");

    http.Response res =
        await http.get("$url/api/uruns/a/$ara", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        urunara(ara);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtourun> list = [];
    for (var l in re) {
      list.add(Dtourun.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future<bool> urunekle(Urun urun) async {
    print("girdiii urun ekleye");
    var maps = json.encode(urun.toMap());
    print(maps.toString());

    var res = await http.post("$url/api/uruns", headers: header, body: maps);
    print(res.statusCode.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        urunekle(urun);
        return;
      });
    } else if (res.statusCode != 201) {
      throw Exception;
    } else {
      return Future.value(
          res.statusCode == 200 || res.statusCode == 201 ? true : false);
    }
  }

  static Future odecariacikfatal(int id) async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/od/a/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        odecariacikfatal(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;

    // return List<Kullaniciliste>.from(re.map((x) => Kullaniciliste.fromMap(x)));
  }

  static Future carisatfatal(int id) async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/c/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        carisatfatal(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future mustacikfat(int id) async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/lt/a/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        mustacikfat(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future mustgecmis(int id) async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/lt/g/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        mustacikfat(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future tedargecmis(int id) async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/od/g/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        mustacikfat(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future tedaral() async {
    print("musteri al baslıyr");

    http.Response res = await http.get("$url/api/caris/t", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        tedaral();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    print(res.body.toString());
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtocarilist> list = [];
    for (var l in re) {
      list.add(Dtocarilist.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future safcarial(int x) async {
    print("musteri al baslıyr");

    http.Response res = await http.get("$url/api/caris/$x", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        safcarial(x);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    var re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    /*  List<Cari> list = [];
    for (var l in re) {
      list.add(Cari.fromMap(l));
    }*/
    Cari ca = Cari.fromMap(re);
    print("sorual bitii");
    return ca;
  }

  static Future satcarifatal(int id) async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/lt/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        satcarifatal(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofattahs> list = [];
    for (var l in re) {
      list.add(Dtofattahs.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future kasaal() async {
    print("kasa al baslıyr");

    http.Response res1 = await http.get("$url/api/kasas", headers: header);
    if (res1.statusCode == 401) {
      http.Response res =
          await http.get("$url/api/calisans/token", headers: header);
      print(res.statusCode.toString());
      if (res.statusCode != 200) {
        print(res.statusCode.toString());
        throw Exception;
      }
      var re = json.decode(res.body);
      APIServices.tok = re;
      APIServices.header = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${APIServices.tok}'
      };
      http.Response res2 = await http.get("$url/api/kasas", headers: header);
      List re1 = json.decode(res2.body);
      List<Kasa> list = [];
      for (var l in re1) {
        list.add(Kasa.fromMap(l));
      }
      print("ksaaall bitii");

      return list;
    } else if (res1.statusCode == 200) {
      List re = json.decode(res1.body);
      List<Kasa> list = [];
      for (var l in re) {
        list.add(Kasa.fromMap(l));
      }
      print("sorual bitii");

      return list;
    } else {
      print(res1.statusCode.toString());
      throw Exception;
    }
  }

  static Future kasahar(int id) async {
    print("kasahar ara baslıyr");

    http.Response res =
        await http.get("$url/api/kasahars/t/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        kasahar(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtokasahar> list = [];
    for (var l in re) {
      list.add(Dtokasahar.fromMap(l));
    }
    print("sorual bitii");
    return list;

    // return List<Kullaniciliste>.from(re.map((x) => Kullaniciliste.fromMap(x)));
  }

  static Future urunal() async {
    print("urun al baslıyr");

    http.Response res = await http.get("$url/api/uruns", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        print("vv");
        print(value.toString());
        print(APIServices.tok);
        APIServices.tok = value;
        print(APIServices.tok);
        APIServices.header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${APIServices.tok}'
        };
        urunal();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtourun> list = [];
    for (var l in re) {
      list.add(Dtourun.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future odefatal() async {
    print("satfatall al baslıyr");

    http.Response res = await http.get("$url/api/faturas/od", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        odefatal();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future odenecektumfatal() async {
    print("satfatall al baslıyr");

    http.Response res =
        await http.get("$url/api/faturas/od/od", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        odefatal();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtofatode> list = [];
    for (var l in re) {
      list.add(Dtofatode.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future urungecmisial(String x) async {
    print("urungecmis al baslıyr");

    http.Response res =
        await http.get("$url/api/urunharekets/b/$x", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        urungecmisial(x);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtourungecmisi> list = [];
    for (var l in re) {
      list.add(Dtourungecmisi.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future kasalistal() async {
    print("kas al baslıyr");

    http.Response res = await http.get("$url/api/kasas", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        kasalistal();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Kasa> list = [];
    for (var l in re) {
      list.add(Kasa.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future stokdetayfatsatis(String x) async {
    print("musteri al baslıyr");

    http.Response res =
        await http.get("$url/api/urunharekets/st/$x", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        stokdetayfatsatis(x);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    var re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtostokdetay> list = [];
    for (var l in re) {
      list.add(Dtostokdetay.fromMap(l));
    }

    print("sorual bitii");
    return list;
  }

  static Future stokdetayfatalis(int x) async {
    print("musteri al baslıyr");

    http.Response res =
        await http.get("$url/api/urunharekets/al/$x", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        stokdetayfatalis(x);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    var re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtostokdetay> list = [];
    for (var l in re) {
      list.add(Dtostokdetay.fromMap(l));
    }

    print("sorual bitii");
    return list;
  }

  static Future fatuurundetay(int id) async {
    print("fayurungdd al baslıyr");

    http.Response res =
        await http.get("$url/api/urunharekets/f/$id", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        fatuurundetay(id);
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtourunhareket> list = [];
    for (var l in re) {
      list.add(Dtourunhareket.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future<bool> kasaharekle(Kasahar pf) async {
    print("girdiii fat ekleye");
    var maps = json.encode(pf.toMap());
    print(maps.toString());

    var res = await http.post("$url/api/kasahars", headers: header, body: maps);
    print(res.statusCode.toString());
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        kasaharekle(pf);
        return;
      });
    } else if (res.statusCode != 201) {
      throw Exception;
    }
    return Future.value(
        res.statusCode == 200 || res.statusCode == 201 ? true : false);
  }

  static Future urunalazdancoga() async {
    print("urun al baslıyr");

    http.Response res = await http.get("$url/api/uruns/ac", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        urunalazdancoga();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtourun> list = [];
    for (var l in re) {
      list.add(Dtourun.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }

  static Future urunalcoktanaza() async {
    print("urun al baslıyr");

    http.Response res = await http.get("$url/api/uruns/ca", headers: header);
    if (res.statusCode == 401) {
      print(res.statusCode.toString());
      tokenal().then((value) {
        APIServices.tok = value;
        urunalcoktanaza();
        return;
      });
    } else if (res.statusCode != 200) {
      print(res.statusCode.toString());
      throw Exception;
    }
    List re = json.decode(res.body);
    print("ikinci sama");
    print("$re");
    List<Dtourun> list = [];
    for (var l in re) {
      list.add(Dtourun.fromMap(l));
    }
    print("sorual bitii");
    return list;
  }
}
