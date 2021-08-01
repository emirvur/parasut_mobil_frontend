import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:muhmobil/model/cari.dart';
import 'package:muhmobil/model/dtocarilist.dart';
import 'package:muhmobil/services/apiservices.dart';
import 'package:muhmobil/ui/musteriayrinti.dart';
import 'package:muhmobil/ui/tedarayrinti.dart';
import 'package:muhmobil/ui/yenimusteri.dart';
import 'package:muhmobil/ui/yenitedarikci.dart';
import 'package:muhmobil/utils/load.dart';

class Tedarliscontroller extends GetxController {
  var isLoading = true.obs;
  var listdtofatta = List<Dtocarilist>().obs;
  num tahsmik = 0.obs();

  @override
  void onInit() {
    fetchfinaltodo();
    super.onInit();
  }

  void fetchfinaltodo() async {
    isLoading(true);
    try {
      var todos = await APIServices.tedaral();
      if (todos != null) {
        listdtofatta.value = todos;
      }
    } finally {
      isLoading(false);
    }
  }

  void guncelle(int index, num deg) async {
    isLoading(true);

    try {} finally {
      isLoading(false);
    }
  }

  void tedarbakguncel(int index, num deg) async {
    isLoading(true);

    try {
      for (var i in listdtofatta) {
        if (i.cariId == index) {
          i.bakiye = i.bakiye - deg;
        }
      }
      tahsmik = tahsmik - deg;
    } finally {
      isLoading(false);
    }
  }

  void yenitedar(Dtocarilist yeni) async {
    isLoading(true);

    try {
      listdtofatta.add(yeni);
    } finally {
      isLoading(false);
    }
  }
}

class Tedarikcili extends StatefulWidget {
  @override
  _TedarikciliState createState() => _TedarikciliState();
}

class _TedarikciliState extends State<Tedarikcili>
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
          backgroundColor: Color.fromRGBO(105, 110, 135, 1),
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
            children: [],
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
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Obx(() {
                    if (Get.find<Tedarliscontroller>().isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Tedarli(Get.find<Tedarliscontroller>().listdtofatta,
                        lisara, isara);
                  }),
                ],
              ),
              //    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tedarli extends StatefulWidget {
  final List<Dtocarilist> listdt;
  final List<Cari> lisara;
  final bool isara;
  Tedarli(this.listdt, this.lisara, this.isara);

  @override
  _TedarliState createState() => _TedarliState();
}

class _TedarliState extends State<Tedarli> with AutomaticKeepAliveClientMixin {
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
