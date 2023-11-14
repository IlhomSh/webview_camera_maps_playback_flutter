import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadImageFiles();
  }

  Future<void> _loadImageFiles() async {
    final directory = await getTemporaryDirectory();

    final files = directory.listSync();
    for (var file in files.reversed) {
      if (file is File && file.path.endsWith('.jpg')) {
        _imageFiles.add(file);
      }
    }

    setState(() {}); // Trigger a rebuild to show the images
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images gallery'),
        centerTitle: true,
      ),
      body: _imageFiles.isNotEmpty
          ? ListView.builder(
          itemCount: _imageFiles.length
          ,itemBuilder: (ctx,index){

        return Image.file(
          _imageFiles[index],
          height: 300,
          fit: BoxFit.cover,
        );
      })
          : Center(
        child: Text('No images available'),
      ),
    );
  }
}