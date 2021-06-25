import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/dtoirsaliye.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:muhmobil/utils/load.dart';
import 'package:muhmobil/utils/testsearch.dart';

import '../model/dtofattahs.dart';
import 'irsayrinti.dart';

class Irsaliyelist extends StatefulWidget {
  @override
  _IrsaliyelistState createState() => _IrsaliyelistState();
}

class _IrsaliyelistState extends State<Irsaliyelist>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<Dtoirsaliye> lis = [];
  List<Dtoirsaliye> lisara = [];
  List<Dtoirsaliye> lisirsedil = [];
  List<Dtoirsaliye> lisarairsedil = [];
  List<Dtoirsaliye> lisirgecik = [];
  List<Dtoirsaliye> lisarairsgecik = [];
  bool isara = false;
  bool isfiltre = false;
  bool _isloading = true;
  String duztar = "";
  TextEditingController contara;
  DateTime today = DateTime.now();
  GlobalKey _toolTipKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    contara = TextEditingController();
    APIServices.irsaliyeal().then((value) {
      setState(() {
        lis = value;
        _isloading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    contara.dispose();
    //tab controller dispose yap
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton(
            backgroundColor: Color.fromRGBO(252, 188, 25, 1),
            onPressed: () {
              final dynamic _toolTip = _toolTipKey.currentState;
              _toolTip.ensureTooltipVisible();
            },
            child: Tooltip(
                key: _toolTipKey,
                message: "Web uygulamasından yeni irsaliye oluşturabilirsiniz",
                child: Icon(FontAwesomeIcons.plus)),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(252, 188, 25, 1),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: Column(
              children: [
                TabBar(
                  //  isScrollable: true,
                  unselectedLabelColor: Colors.grey[300],
                  labelColor: Colors.white,
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 8.0),
                    insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                  ),
                  tabs: <Widget>[
                    Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "TÜMÜ",
                      ),
                    ),
                    Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "GELEN",
                      ),
                    ),
                    Container(
                      width: size.width / 3,
                      child: Tab(
                        text: "GİDEN",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          title: isara == false
              ? Text("İrsaliyeler", style: Load.font(50))
              : TextField(
                  decoration: new InputDecoration(
                      hintText: 'Ara...', hintStyle: Load.font(0)),
                  onChanged: (v) {
                    APIServices.irsara(v).then((value) {
                      setState(() {
                        lisara = value;
                        _isloading = false;
                      });
                    });
                  },
                ),
          actions: [
            Container(
              padding: EdgeInsets.all(6.0),
              decoration: new BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(4),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Search(title: "w")))
                      .then((value) {
                    if (value == 1) {
                      APIServices.irsaliyeal().then((value) {
                        setState(() {
                          lis = value;
                          _isloading = false;
                        });
                      });
                    }
                  });
                },
                child: Center(
                  child: Text("Toplu fatura", style: Load.font(5)),
                ),
              ),
            ),
            /*    isara == false
                ? isfiltre == false
                    ? IconButton(
                        icon: Icon(
                          FontAwesomeIcons.calendar, size: 18,
                          // color: Colors.white,
                        ),
                        onPressed: () {
                          buildduztarModBottomSheet(context, size);
                        },
                      )
                    : Text(duztar)
                : Text(""),*/
            isara == false
                ? IconButton(
                    icon: Icon(
                      FontAwesomeIcons.search, size: 18,
                      // color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isara = !isara;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.cancel,
                      // color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isara = !isara;
                      });
                    },
                  )
          ],
        ),
        body: LoadingOverlay(
          isLoading: _isloading,
          opacity: Load.opacit,
          progressIndicator: Load.prog,
          child: Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                //   Align(alignment: Alignment.centerLeft, child: Text("Nisan 2021")),
                Expanded(
                  // child: Container(
                  //     color: Colors.grey[300],
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      Irstum(lis, lisara, isara),
                      Irsgelen(),
                      Irsgelen(),
                    ],
                  ),
                  //    ),
                ),
              ],
            ),
          ),
        ));
  }

  Future buildduztarModBottomSheet(BuildContext context, Size size) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: size.height / 4,
            child: Column(
              //   mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "İptal",
                          style: Load.font(2),
                        )),
                    Text("Düzenleme Tarihini seçiniz", style: Load.font(3)),
                    TextButton(onPressed: () {}, child: Text(""))
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                            isfiltre = true;
                            duztar = "1";
                          });
                        },
                        child: Text("Tümü", style: Load.font(0))),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                            isfiltre = true;
                            duztar = "2";
                          });
                        },
                        child: Text("Bugün", style: Load.font(0))),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                            isfiltre = true;
                            duztar = "3";
                          });
                        },
                        child: Text("Bu hafta", style: Load.font(0))),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                            isfiltre = true;
                            duztar = "4";
                          });
                        },
                        child: Text("Bu ay", style: Load.font(0))),
                  ],
                )
              ],
            ),
          );
        });
  }
}

class Irstum extends StatefulWidget {
  final List<Dtoirsaliye> listdt;
  final List<Dtoirsaliye> lisara;
  final bool isara;
  Irstum(this.listdt, this.lisara, this.isara);

  @override
  _IrstumState createState() => _IrstumState();
}

class _IrstumState extends State<Irstum> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //separatorBuilder: (context, index) => Divider(
      //    color: Colors.black,  ),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount:
          widget.isara == true ? widget.lisara.length : widget.listdt.length,
      itemBuilder: (context, index) {
        Dtoirsaliye dt =
            widget.isara == true ? widget.lisara[index] : widget.listdt[index];
        return Card(
            elevation: 0,
            margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Irsayrinti(dt)),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                leading: Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: new BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                      border: new Border(
                          right: new BorderSide(width: 1.0, color: Colors.grey),
                          left: new BorderSide(width: 1.0, color: Colors.grey),
                          top: new BorderSide(width: 1.0, color: Colors.grey),
                          bottom:
                              new BorderSide(width: 1.0, color: Colors.grey))),
                  child: Icon(FontAwesomeIcons.fileAlt, color: Colors.blue),
                ),
                title: Text(
                  dt.aciklama,
                  style: Load.font(0),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    Text(
                      "${dt.cariad} ,${dt.tarih}",
                      style: Load.font(1),
                    )
                    //      Text(" Intermediate", style: TextStyle(color: Colors.black))
                  ],
                ),
                /*    trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "3 gün", //   " ${dt.geneltoplam - dt.alinmism}",
                      style: TextStyle(color: Colors.black),
                    ),
                    dt.vadta == null
                        ? Text("nu")
                        : Text(" ${dt.vadta.substring(0, 4)}",
                            style: TextStyle(color: Colors.grey))
                  ],
                ),*/
              ),
            ));
      },
    );
  }
}

class Irsgelen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("YAKINDA")),
    );
  }
}
/*
class Irsgelen extends StatefulWidget {
  final bool isara;
  Irsgelen(this.isara);

  @override
  _IrsgelenState createState() => _IrsgelenState();
}

class _IrsgelenState extends State<Irsgelen>
    with AutomaticKeepAliveClientMixin {
  List<Dtoirsaliye> listdttahsedil = [];
  List<Dtoirsaliye> lisaratahsedil = [];

  @override
  void initState() {
    super.initState();
    print("ilktee");
    APIServices.satfatalacikfat().then((value) {
      setState(() {
        print(value.toString());
        listdttahsedil = value;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //separatorBuilder: (context, index) => Divider(
      //    color: Colors.black,  ),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount:
          widget.isara == true ? lisaratahsedil.length : listdttahsedil.length,
      itemBuilder: (context, index) {
        Dtofattahs dt = widget.isara == true
            ? lisaratahsedil[index]
            : listdttahsedil[index];
        return Card(
            elevation: 0,
            margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
                ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Satisfatayrinti(dt)),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                leading: Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: new BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                      border: new Border(
                          right: new BorderSide(width: 1.0, color: Colors.grey),
                          left: new BorderSide(width: 1.0, color: Colors.grey),
                          top: new BorderSide(width: 1.0, color: Colors.grey),
                          bottom:
                              new BorderSide(width: 1.0, color: Colors.grey))),
                  child: Icon(Icons.file_copy, color: Colors.blue),
                ),
                title: Text(
                  dt.fataciklama,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    dt.duztarih == null
                        ? Text("nu")
                        : Text(
                            " ${dt.cariad},${dt.duztarih.substring(0, 4)}",
                            style: TextStyle(color: Colors.grey),
                          )
                    //      Text(" Intermediate", style: TextStyle(color: Colors.black))
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "3 gün", //   " ${dt.geneltoplam - dt.alinmism}",
                      style: TextStyle(color: Colors.black),
                    ),
                    dt.vadta == null
                        ? Text("nu")
                        : Text(" ${dt.vadta.substring(0, 4)}",
                            style: TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ));
      },
    );
  }
}*/
