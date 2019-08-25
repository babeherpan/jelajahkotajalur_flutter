import 'wisata.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'lihat_page.dart';


class MainPage extends StatefulWidget {
  final Wisata list;
  MainPage({this.list});
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = "Wisata";
  List<Wisata> postsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference postRef =
    FirebaseDatabase.instance.reference().child("Wisata");
    postRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      postsList.clear();

      for (var satuKey in KEYS) {
        Wisata wisata1 = new Wisata(
            DATA[satuKey]['nama_wisata'],
            DATA[satuKey]['deskripsi'],
            DATA[satuKey]['latitude'],
            DATA[satuKey]['longitude'],
            DATA[satuKey]['gambar']);
        postsList.add(wisata1);
      }
      setState(() {
        print('Length : $postsList.length');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wisata Nusantara'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Visibility(
              visible: postsList.isEmpty,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Visibility(
              visible: postsList.isNotEmpty,
              child: Flexible(
                child: postsList.length == 0
                    ? new Text("Data Tidak Ada")
                    : new ListView.builder(
                  itemCount: postsList.length,
                  itemBuilder: (context, index) {
                    return new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) =>
                                LihatPage(postsList[index])));
                      },
                      child: ShowData(
                          postsList[index].nama_wisata,
                          postsList[index].deskripsi,
                          postsList[index].latitude,
                          postsList[index].longitude,
                          postsList[index].gambar
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget ShowData(String nama_wisata, String deskripsi, String latitude, String longitude, String gambar){
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(gambar, fit:BoxFit.cover),
            SizedBox(
              height: 10.0,
            ),
            Text(nama_wisata,style: Theme.of(context).textTheme.subhead, textAlign:TextAlign.center),
          ],
        ),
      ),
    );
  }
}
