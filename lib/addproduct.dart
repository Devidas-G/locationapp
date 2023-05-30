import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController longitude = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();

  final ImagePicker picker = ImagePicker();
  File? image;
  final storageref = FirebaseStorage.instance.ref();
  CollectionReference products =
      FirebaseFirestore.instance.collection('Products');
  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude.text = position.latitude.toString();
      longitude.text = position.longitude.toString();
    });
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  pickimage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      final imgtemp = File(image.path);
      setState(() {
        this.image = imgtemp;
      });
    }
  }

  savetofirestore(String name, var price, var long, var lat, File image) async {
    var imageurl;
    storageref
        .child("/$name.jpg")
        .putFile(image)
        .then((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.success) {
        FirebaseStorage.instance
            .ref()
            .child("/$name.jpg")
            .getDownloadURL()
            .then((url) {
          products.add({
            'Name': name,
            'Price': price,
            'Long': long,
            'Lat': lat,
            'url': url
          }).then((value) {
            Navigator.pop(context);
          });
        }).catchError((onError) {
          print("Got Error $onError");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                    width: size.width,
                  ),
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Stack(children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: size.width / 4,
                        child: image != null
                            ? ClipOval(
                                child: Image.file(
                                image!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ))
                            : Image.asset(
                                "image/add-image-1.png",
                                height: 120,
                                width: 120,
                              ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: () {
                            pickimage();
                          },
                          child: const Icon(Icons.add),
                        ),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: name,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Product Name'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter value';
                      }
                      return null;
                    },
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Price'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width / 1.2,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Click Location button';
                                }
                                return null;
                              },
                              controller: longitude,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Longitude'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Click Location button';
                                }
                                return null;
                              },
                              controller: latitude,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'latitude'),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            getLocation();
                          },
                          icon: const Icon(
                            Icons.location_searching,
                            color: Colors.blue,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
              height: 50,
              width: 100,
              child: ElevatedButton(
                  onPressed: () {
                    if (image != null) {
                      if (_formKey.currentState!.validate()) {
                        savetofirestore(name.text, price.text, longitude.text,
                            latitude.text, image!);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please select a image",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: const Text(
                    "save",
                    style: TextStyle(fontSize: 20),
                  ))),
        ],
      ),
    ));
  }
}
