import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:whiskr/model/profile.dart';

class ProfilePage extends StatefulWidget {
  final ProfileModel? model;

  const ProfilePage({super.key, this.model});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<String> images = widget.model?.photos.toList() ?? [];
  late String name = widget.model?.name ?? '';
  FocusNode focusNodeName = FocusNode();
  FocusNode bioFocusNode = FocusNode();
  late int selectedDate = widget.model?.dob ?? 0;

  final _formKey = GlobalKey<FormState>();
  late AnimalType? type = widget.model?.type;
  late String? bio = widget.model?.bio ?? '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focusNodeName.dispose();
    bioFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                if (images.isEmpty) {
                  return Center(
                    child: InkWell(
                      child: Icon(Icons.image),
                      onTap: () async {
                        pickImagesFromGallery();
                      },
                    ),
                  );
                } else {
                  return Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.image);
                                      },
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
                  initialValue: name,
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1)),
                    fillColor: Colors.grey,
                  ),
                  focusNode: focusNodeName,
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
                  validator: (value) {
                    if (name == "" || name.isEmpty) {
                      return "name is required";
                    }

                    return null;
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
                  focusNode: bioFocusNode,
                  initialValue: bio,
                  onChanged: (value) {
                    setState(() {
                      bio = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      bio = value!;
                    });
                  },
                ),
              ),
              selectedDate == 0
                  ? InkWell(
                      onTap: () async {
                        _selectDate(context);
                      },
                      child: Text("Year Of Birth"),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(selectedDate.toString()),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Type"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<AnimalType>(
                  value: type,
                  items: AnimalType.values.map((AnimalType value) {
                    return DropdownMenuItem<AnimalType>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                  onChanged: (AnimalType? value) {
                    if (value != null) {
                      setState(() {
                        type = value;
                      });
                    }
                  },
                  validator: (value) =>
                      value == null ? 'Type is required' : null,
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      ProfileModel profile = ProfileModel(
                          uid: uid,
                          name: name,
                          bio: bio ?? '',
                          photos: images.toSet(),
                          dob: selectedDate,
                          type: type!);
                      if (widget.model == null) {
                        FirebaseFirestore.instance
                            .collection("profiles")
                            .doc(uid)
                            .set(profile.toJson());
                      } else {
                        FirebaseFirestore.instance
                            .collection("profiles")
                            .doc(uid)
                            .update(profile.toJson());
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile Updated'),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
    );
    if (picked != null || picked!.year != 0) {
      setState(() {
        selectedDate = picked.year;
      });
    }
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
