import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/musteriayrinti.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/ui/tedarayrinti.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:muhmobil/ui/yenitedarikci.dart';
import 'package:muhmobil/utils/load.dart';

import '../model/dtofattahs.dart';

class Tedarikcilist extends StatefulWidget {
  @override
  _TedarikcilistState createState() => _TedarikcilistState();
}

class _TedarikcilistState extends State<Tedarikcilist>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<Dtocarilist> lis = [];
  List<Cari> lisara = [];

  bool isara = false;
  bool isfiltre = false;
  bool _isloading = true;
  String duztar = "";
  TextEditingController contara;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 1);
    contara = TextEditingController();
    APIServices.tedaral().then((value) {
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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Yenitedarikci()));
            },
            child: Icon(FontAwesomeIcons.plus),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(105, 110, 135, 1),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: Column(
              children: [
                /*   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Ödenecek",
                            style: Load.font(5),
                          ),
                          Text("xx", style: Load.font(5))
                        ],
                      ),
                      /*  Column(
                        children: [
                          Text("Ödenecek",
                              style: TextStyle(color: Colors.white)),
                          Text("43", style: TextStyle(color: Colors.white))
                        ],
                      )*/
                    ],
                  ),
                ),*/
              ],
            ),
          ),
          title: isara == false
              ? Text("Cari Hesaplar(Tedarikçi)", style: Load.font(4))
              : TextField(
                  decoration: new InputDecoration(hintText: 'Ara...'),
                  onChanged: (v) {
                    APIServices.tedarara(v).then((value) {
                      setState(() {
                        lisara = value;
                        _isloading = false;
                      });
                    });
                  },
                ),
          actions: [
            isara == false
                ? isfiltre == false
                    ? Text("")
                    : Text("")
                : Text(""),
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
                      Tedarlis(lis, lisara, isara),
                      //  Satistahsedil(isara),
                      //    Satistum(lis, lisara, isara),
                    ],
                  ),
                  //    ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Tedarlis extends StatefulWidget {
  final List<Dtocarilist> listdt;
  final List<Cari> lisara;
  final bool isara;
  Tedarlis(this.listdt, this.lisara, this.isara);

  @override
  _TedarlisState createState() => _TedarlisState();
}

class _TedarlisState extends State<Tedarlis>
    with AutomaticKeepAliveClientMixin {
  Dtocarilist dt;
  Cari dtc;
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
        if (widget.isara == true) {
          dtc = widget.lisara[index];
          return Buildcari(dt: dtc);
        } else {
          dt = widget.listdt[index];
          return Builddtocari(dt: dt);
        }
      },
    );
  }
}

class Buildcari extends StatelessWidget {
  const Buildcari({
    Key key,
    @required this.dt,
  }) : super(key: key);

  final Cari dt;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        margin: new EdgeInsets.symmetric(vertical: 1.0 //horizontal:10
            ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white), //Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
              onTap: () {
                Dtocarilist c =
                    Dtocarilist(dt.cariId, dt.cariunvani, "", dt.bakiye);
                //      c.bakiye = dt.bakiye;
                //        c.cariId = dt.cariId;
                //          c.cariunvani = dt.cariunvani;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tedarayrinti(c)),
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
                child: Icon(FontAwesomeIcons.building, color: Colors.blue),
              ),
              title: Text(
                dt.cariunvani,
                style: Load.font(0),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Load.numfor.format(dt.bakiye.round()),
                          style: Load.font(0)),
                      Icon(
                        FontAwesomeIcons.liraSign,
                        size: 12,
                      )
                    ],
                  ),
                  Text("Ödenecek", style: Load.font(1)),
                ],
              )),
        ));
  }
}

class Builddtocari extends StatelessWidget {
  const Builddtocari({
    Key key,
    @required this.dt,
  }) : super(key: key);

  final Dtocarilist dt;

  @override
  Widget build(BuildContext context) {
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
                  MaterialPageRoute(builder: (context) => Tedarayrinti(dt)),
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
                child: Icon(FontAwesomeIcons.building, color: Colors.blue),
              ),
              title: Text(
                dt.cariunvani,
                style: Load.font(0),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Load.numfor.format(dt.bakiye.round()),
                          style: Load.font(0)),
                      Icon(
                        FontAwesomeIcons.liraSign,
                        size: 12,
                      )
                    ],
                  ),
                  Text("Ödenecek", style: Load.font(1)),
                ],
              )),
        ));
  }
}
