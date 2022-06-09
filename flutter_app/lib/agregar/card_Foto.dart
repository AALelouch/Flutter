import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/agregar/ImagePickerHandler.dart';
import 'package:image_picker/image_picker.dart';

class CardFotos extends StatefulWidget {
  @override
  CardFoto createState() {
    return CardFoto();
  }
}

class CardFoto extends State<CardFotos> with ImagePickerListener {
  late ImagePickerHandler imagePicker;
  static File? croppedFile;
  @override
  void initState() {
    super.initState();
    imagePicker = ImagePickerHandler(this);
  }

  Widget showImage() {
    if (croppedFile != null) {
      return Image.file(
        croppedFile!,
        width: 300,
        height: 300,
      );
    } else {
      return Image.asset("assets/logo-google.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.5)),
          child: InkWell(
            child: Container(
              height: 200,
              width: 600,
              child: showImage(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //error de FlatButton : se soluciona creando una funcion, en la liena 49 la cree
            FloatingActionButton(
                backgroundColor: Colors.white10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.5)),
                onPressed: () {
                  //
                  imagePicker.pickImageFromGallery(ImageSource.gallery);
                },
                child: const Text("Galeria")),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.white10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.5)),
              onPressed: () {
                imagePicker.pickImageFromGallery(ImageSource.camera);
              },
              child: const Text("Camara"),
            ),
          ],
        ),
      ],
    );
  }

  @override
  userImage(File _image) {
    croppedFile = _image;
    setState(() {});
  }
}
