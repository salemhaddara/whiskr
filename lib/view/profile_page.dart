import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  List<String> images = [];
  String name = "";
  FocusNode focusNodeName = FocusNode();
  DateTime selectedDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  XFile? pickedFile;
  TextEditingController? _nameController;
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController?.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Builder(builder: (context) {
              if (images.isEmpty) {
                return InkWell(
                  child: Icon(Icons.image),
                  onTap: () async {
                    pickImagesFromGallery();
                  },
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: ListView.builder(
                    itemCount: images.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Container(
                                  width: 100.0,
                                  height: 100.0,
                                  margin: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    images[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                );
              }
            }),
            Text("Name"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
/*             keyboardType: TextInputType.multiline,
                maxLines: null, */
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1)),
                  fillColor: Colors.grey,
                ),
                focusNode: focusNodeName,
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    name = value!;
                  });
                },
              ),
            ),
            Text("Bio"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1)),
                  fillColor: Colors.grey,
                ),
                focusNode: focusNodeName,
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    name = value!;
                  });
                },
              ),
            ),
            InkWell(
              onTap: () async {
                _selectDate(context);
              },
              child: Text("Date of Birth"),
            )
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.input,
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> pickImagesFromGallery() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      for (final file in pickedFiles) {
        // Check if the widget is still mounted
        if (!mounted) return;
        String uuid = Uuid().v4();
        var fileIMage = await file.readAsBytes();
        var reference = FirebaseStorage.instance.ref().child("images/$uuid");
        var result = await reference.putData(fileIMage);

        var urlReceived = await reference.getDownloadURL();
        setState(() {
          images.add(urlReceived);
        });
      }
    }
  }
}
