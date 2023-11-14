import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMapPage extends StatefulWidget {
  @override
  _MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  late GoogleMapController _controller;
  CameraPosition _initialPosition = CameraPosition(target: LatLng(41.318589651043766, 69.29530485506442), zoom: 12.0);
  double _zoomValue = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Demo'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
            },
            initialCameraPosition: _initialPosition,
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    _moveCamera(CameraUpdate.scrollBy(0, -10.0));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    _moveCamera(CameraUpdate.scrollBy(0, 10.0));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () {
                    _moveCamera(CameraUpdate.scrollBy(-10.0, 0));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {
                    _moveCamera(CameraUpdate.scrollBy(10.0, 0));
                  },
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _goToInitialPosition();
                  },
                  child: Text('Домой'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Column(
              children: [
                Text('Zoom'),
                Slider(
                  value: _zoomValue,
                  min: 5.0,
                  max: 20.0,
                  onChanged: (value) {
                    setState(() {
                      _zoomValue = value;
                    });
                    _moveCamera(CameraUpdate.newLatLngZoom(_initialPosition.target, value));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _moveCamera(CameraUpdate cameraUpdate) {
    _controller.animateCamera(cameraUpdate);
  }

  void _goToInitialPosition() {

    _moveCamera(CameraUpdate.newCameraPosition(_initialPosition));
  }
}