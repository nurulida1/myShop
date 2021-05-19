import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshop/main.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  TextEditingController _prnameController = new TextEditingController();
  TextEditingController _prtypeController = new TextEditingController();
  TextEditingController _prpriceController = new TextEditingController();
  TextEditingController _prqtyController = new TextEditingController();
  String pathAsset = "assets/images/camera.png";
  String _prtype;
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (content) => MainLayout()));
                setState(() {});
              }),
          title: Text(
            "ADD PRODUCT",
            style: TextStyle(color: Colors.white),
          )),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _chooseImage();
            },
            child: Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: _image == null
                            ? AssetImage("assets/images/camera.png")
                            : FileImage(_image))),
              ),
            ),
          ),
          SizedBox(height: 30),
          TextField(
            controller: _prnameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                labelText: 'Product Name',
                icon: Icon(Icons.business),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32))),
          ),
          SizedBox(height: 30),
          TextField(
            controller: _prtypeController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                labelText: 'Product Type',
                icon: Icon(Icons.add_business_rounded),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32))),
          ),
          SizedBox(height: 30),
          TextField(
            controller: _prpriceController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                labelText: 'Price (RM)',
                icon: Icon(Icons.money),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32))),
          ),
          SizedBox(height: 30),
          TextField(
            controller: _prqtyController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                labelText: 'Quantity Available',
                icon: Icon(Icons.add_business_sharp),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32))),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 30.0, left: 8.0, right: 8.0, bottom: 20),
            child: Center(
              child: Container(
                  height: 50,
                  width: 200,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.black,
                    onPressed: () {
                      _addProduct();
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add Product",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 10),
                        ]),
                  )),
            ),
          ),
        ],
      )),
    );
  }

  void _chooseImage() {
    final snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: Container(
          height: 100,
          child: Column(
            children: [
              Text("Select Image",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 60,
                      width: 50,
                      child: GestureDetector(
                        onTap: () {
                          _chooseGallery();
                        },
                        child: Column(
                          children: [
                            Icon(Icons.image_rounded, color: Colors.black),
                            Text(
                              "Gallery",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      )),
                  Container(
                      height: 60,
                      width: 70,
                      child: GestureDetector(
                        onTap: () {
                          _chooseCamera();
                        },
                        child: Column(
                          children: [
                            Icon(Icons.camera_alt_rounded, color: Colors.black),
                            Text(
                              "Camera",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      )),
                  Container(
                      height: 60,
                      width: 60,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      )),
                ],
              )
            ],
          ),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print("No Image Selected");
    }
    _cropImage();
  }

  Future<void> _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print("No Image Selected");
      Navigator.of(context).pop();
    }
    _cropImage();
  }

  Future<void> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).accentColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _addProduct() {
    String prname = _prnameController.text.toString();
    String prtype = (_prtypeController.text == "")
        ? _prtype
        : _prtypeController.text.toString();
    String prprice = _prpriceController.text.toString();
    String prqty = _prqtyController.text.toString();
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post(
        Uri.parse("https://nurulida1.com/272932/myshop/php/newproduct.php"),
        body: {
          "prname": prname,
          "prtype": prtype,
          "prprice": prprice,
          "prqty": prqty,
          "encoded_string": base64Image,
        }).then((response) {
      print(response.body);
      if (response.body == "Success") {
        Fluttertoast.showToast(
            msg: "Product successfully added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);

        setState(() {
          _prnameController.text = "";
          _prpriceController.text = "";
          _prqtyController.text = "";
          _prtypeController.text = "";
          _image = null;
        });
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Product failed to add",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        return;
      }
    });
  }
}
