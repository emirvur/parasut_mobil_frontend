import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/model/kasa.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/musteriayrinti.dart';
import 'package:muhmobil/ui/satisfatayrinti.dart';
import 'package:muhmobil/utils/load.dart';

import '../model/dtofattahs.dart';
import 'kasaayrinti.dart';

class Kasalist extends StatefulWidget {
  @override
  _KasalistState createState() => _KasalistState();
}

class _KasalistState extends State<Kasalist> with TickerProviderStateMixin {
  TabController _tabController;
  List<Kasa> lis = [];
  bool _isloading = true;
  bool isara = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 1);
    print("ilk inittee");
    APIServices.kasaal().then((value) {
      print("kasaala thende");
      print(value.toString());
      setState(() {
        print("sessrt");
        lis = value;
        _isloading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //tab controller dispose yap
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(50, 237, 184, 1),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(25), child: Text("")),
          title: Text("Kasa ve Bankalar", style: Load.font(5)),
          /*isara == false
              ? Text("Kasa ve Bankalar", style: Load.font(5))
              : TextField(
                  decoration: new InputDecoration(hintText: 'Ara...'),
                  onChanged: (v) {
                    /* APIServices.mustara(v).then((value) {
                      setState(() {
                        lisara = value;
                        _isloading = false;
                      });
                    });*/
                  },
                ),*/
          actions: [
            /* isara == false
                ? isfiltre == false
                    ? Text("")
                    : Text("")
                : Text(""),
            isara == false
                ? IconButton(
                    icon: Icon(
                      Icons.search,
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
                  )*/
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
                      Kasalis(lis, false),
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

class Kasalis extends StatefulWidget {
  final List<Kasa> listdt;
  final bool isara;
  Kasalis(this.listdt, this.isara);

  @override
  _KasalisState createState() => _KasalisState();
}

class _KasalisState extends State<Kasalis> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //separatorBuilder: (context, index) => Divider(
      //    color: Colors.black,  ),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.listdt.length,
      //      widget.isara == true ? widget.lisara.length : widget.listdt.length,
      itemBuilder: (context, index) {
        return Buildkasa(dt: widget.listdt[index]);
        /*if (widget.isara == true) {
          dtc = widget.lisara[index];
          return Buildcari(dt: dtc);
        } else {
          dt = widget.listdt[index];
          return Buildcari(dt: dtc);
        }*/
      },
    );
  }
}

class Buildkasa extends StatelessWidget {
  const Buildkasa({
    Key key,
    @required this.dt,
  }) : super(key: key);

  final Kasa dt;

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
                  MaterialPageRoute(builder: (context) => Kasaayrinti(dt)),
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
                child: Icon(FontAwesomeIcons.moneyBill,
                    size: 18, color: Colors.blue),
              ),
              title: Text(
                dt.kasaAd,
                style: Load.font(0),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Load.numfor.format(dt.bakiye.round()),
                      style: Load.font(0)),
                  Icon(
                    FontAwesomeIcons.liraSign,
                    size: 12,
                  )
                ],
              )),
        ));
  }
}
