import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myshop/newproduct.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: MainLayout());
  }
}

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  double screenWidth;
  double screenHeight;
  List _productList;
  String _titlecenter = 'Loading...';
  bool _visible = true;
  bool _isgridview = true;
  final df = new DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _loadproducts();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'MYSHOP',
          style: TextStyle(letterSpacing: 7),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
                child: _productList == null
                    ? Flexible(
                        child: Center(
                            child: Container(
                        height: 20,
                      )))
                    : Flexible(
                        child: Center(
                            child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 2,
                        children: List.generate(_productList.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(1),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: (_isgridview == true)
                                          ? screenHeight / 5
                                          : screenWidth / 2,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "https://nurulida1.com/272932/myshop/images/product/${_productList[index]['prid']}.png",
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 8, right: 8),
                                    child: Text(
                                      productName(
                                          _productList[index]['prname']),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      productName(
                                          _productList[index]['prtype']),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 8, right: 8),
                                    child: Row(
                                      children: [
                                        Text("RM",
                                            style: TextStyle(fontSize: 12)),
                                        Text(
                                          _productList[index]['prprice'],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: [
                                        Text("Quantity:"),
                                        Text(
                                          productName(
                                              _productList[index]['prqty']),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          df.format(DateTime.parse(
                                              _productList[index]
                                                  ['datecreated'])),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      )))),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: _visible,
        child: FloatingActionButton.extended(
            label: Text('ADD PRODUCT'),
            icon: Icon(Icons.add),
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (content) => NewProduct()),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _loadproducts() {
    http.post(
        Uri.parse("https://nurulida1.com/272932/myshop/php/loadProducts.php"),
        body: {}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _titlecenter = "No Product";
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        _productList = jsondata["products"];
        setState(() {
          print(_productList);
        });
      }
    });
  }

  String productName(String productName) {
    if (productName.length < 20) {
      return productName;
    } else {
      return productName.substring(0, 20) + "...";
    }
  }
}

