import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/musteriayrinti.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/ui/yenimusteri.dart';
import 'package:muhmobil/ui/yenisatisfat.dart';
import 'package:muhmobil/utils/load.dart';

import '../model/dtofattahs.dart';

class Carihesap extends StatefulWidget {
  @override
  _CarihesapState createState() => _CarihesapState();
}

class _CarihesapState extends State<Carihesap> with TickerProviderStateMixin {
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
    APIServices.musterial().then((value) {
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
    _tabController.dispose();
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
                  MaterialPageRoute(builder: (context) => Yenimusteri()));
            },
            child: Icon(FontAwesomeIcons.plus),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(105, 110, 135, 1),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: Column(
              children: [],
            ),
          ),
          title: isara == false
              ? Text("Cari Hesaplar(Müşteri)", style: Load.font(5))
              : TextField(
                  decoration: new InputDecoration(
                      hintText: 'Ara...', hintStyle: Load.font(0)),
                  onChanged: (v) {
                    APIServices.mustara(v).then((value) {
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
                      Musterilis(lis, lisara, isara),
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

class Musterilis extends StatefulWidget {
  final List<Dtocarilist> listdt;
  final List<Cari> lisara;
  final bool isara;
  Musterilis(this.listdt, this.lisara, this.isara);

  @override
  _MusterilisState createState() => _MusterilisState();
}

class _MusterilisState extends State<Musterilis>
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
                print("fff");
                print(dt.bakiye.toString());
                //    c.bakiye = dt.bakiye;
                //      c.cariId = dt.cariId;
                //        c.cariunvani = dt.cariunvani;
                //     c.katad = "";

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Musteriayrinti(c)),
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
                child: Icon(FontAwesomeIcons.building,
                    size: 18, color: Colors.blue),
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
                      Text("${Load.numfor.format(dt.bakiye.round())}",
                          style: Load.font(0)),
                      Icon(
                        FontAwesomeIcons.liraSign,
                        size: 12,
                      )
                    ],
                  ),
                  Text("Tahsil edilecek", style: Load.font(1)),
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
                  MaterialPageRoute(builder: (context) => Musteriayrinti(dt)),
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
                child: Icon(FontAwesomeIcons.building,
                    size: 18, color: Colors.blue),
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
                      Text("${Load.numfor.format(dt.bakiye.round())}",
                          style: Load.font(0)),
                      Icon(
                        FontAwesomeIcons.liraSign,
                        size: 12,
                      )
                    ],
                  ),
                  Text("Tahsil edilecek", style: Load.font(1))
                ],
              )),
        ));
  }
}
