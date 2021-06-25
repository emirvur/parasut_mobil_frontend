import 'package:flutter/material.dart';

class Ders extends StatefulWidget {
  @override
  _DersState createState() => _DersState();
}

class _DersState extends State<Ders> {
  DateTime pickedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickedDate = DateTime.now();
  }

  Future<void> _pickDate() async {
    DateTime date = await showDatePicker(
      locale: Locale("tr"),
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      pickedDate = date;
      setState(() {});
    }
  }

  Future<void> buildparaekle(BuildContext context, Size size, bool girismi) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            print("tt");

            return Container(
                height: (4 * size.height) / 12,
                child: Column(
                    //   mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                          onPressed: () {
                            _pickDate().then((value) {
                              setState(() {});
                            });
                          },
                          child: Text("eee")),
                      Text(pickedDate.toString()),
                    ]));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
            //   mainAxisSize: MainAxisSize.min,
            children: <Widget>[
          SizedBox(
            height: 30,
          ),
          TextButton(
              onPressed: () {
                _pickDate();
              },
              child: Text("eee")),
          Text(pickedDate.toString()),
          TextButton(
              onPressed: () {
                buildparaekle(context, size, true);
              },
              child: Text("vvv")),
        ]));
  }
}
