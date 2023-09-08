import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:testapp/addproduct.dart';
import 'package:testapp/auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var products = FirebaseFirestore.instance.collection("Products").snapshots();
  List productlist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      Auth(FirebaseAuth.instance).singOut();
                    },
                    child: Text("SignOut"))
              ],
            )
          ],
        ),
      )),
      body: StreamBuilder(
        stream: products,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Connection error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }
          var docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(docs[index]["url"])),
                  title: Text(docs[index]["Name"]),
                  subtitle: Text("Price: ${docs[index]["Price"]}"),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                  onTap: () {
                    MapsLauncher.launchCoordinates(
                        double.parse(docs[index]["Lat"]),
                        double.parse(docs[index]["Long"]));
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddProduct()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
