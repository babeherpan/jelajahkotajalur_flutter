import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'wisata.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LihatPage extends StatefulWidget {
  final Wisata wisata;
  LihatPage(this.wisata);
  @override
  _LihatPageState createState() => _LihatPageState();
}

class _LihatPageState extends State<LihatPage> {
  static double nLat;
  static double nLong;
  dynamic gab;

  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String a = widget.wisata.latitude;
    String b = widget.wisata.longitude;
    nLat = double.parse(a);
    nLong = double.parse(b);
  }

//
  static LatLng _center =  LatLng(nLat, nLong);
////
////
  LatLng _lastPosition = _center;


  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(nLat, nLong), zoom: 25.0);

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(nLat, nLong),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
//
////
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: _lastPosition,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.wisata.nama_wisata}"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 2000.0,
            child: Column(
              children: <Widget>[
                Card(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(
                        "${widget.wisata.gambar}",
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      Text(
                        "${widget.wisata.nama_wisata}",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text("${widget.wisata.deskripsi}"),
                      ),
                      new Column(
                        children: <Widget>[
                          new Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: new GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              _onAddMarkerButtonPressed();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: Text('To the lake!'),
          icon: Icon(Icons.directions_boat),
        )
    );
  }
}

//
//class MapUtils {
//  static openMap(double latitude, double longitude) async {
//    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//    if (await canLaunch(googleUrl)) {
//      await launch(googleUrl);
//    } else {
//      throw 'Could not open the map.';
//    }
//  }
//}
