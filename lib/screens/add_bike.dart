import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'dart:io';
import 'dart:async';
import 'package:location/location.dart';
import '../models/bikeDTO.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/sign_in.dart';
import '../screens/bike_list.dart';

class AddBike extends StatefulWidget {
  static const routeName = 'addBike';
  @override
  _AddBikeState createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {
  String url;
  File imageFile;
  LocationData location;
  List<String> _availableTags;

  final post = BikeDTO();
  final formKey = GlobalKey<FormState>();
  var checkboxValue = false; 

  @override
  void initState() {
    super.initState();
    getLocation();
    loadAvailableTags();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Add Bike'),
        ),
        body: new Center(
          child: imageFile == null ? (buildColumn()) : enableUpload(),
        ),
      );
    } else {
      return SignIn();
    }
  }

  Column buildColumn() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Semantics(
              button: true,
              enabled: true,
              onTapHint: 'Choose Image from Gallery',
              child: ElevatedButton(
                onPressed: getImage,
                child: Text('Choose Image'),
              ),
            ),
            SizedBox(width: 3.0),
            SizedBox(width: 3.0),
            Semantics(
              button: true,
              enabled: true,
              onTapHint: 'Take a Picture',
              child: ElevatedButton(
                onPressed: takePicture,
                child: Text('Take Picture'),
              ),
            ),
          ],
        ),
        Semantics(
          button: true,
          enabled: true,
          onTapHint: 'Cancel',
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ),
      ],
    );
  }

  Widget enableUpload() {
    return new Container(
        child: new Form(
      key: formKey,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 6.0),
          Image.file(
            imageFile,
            height: 165.0,
            width: 330,
          ),
          SizedBox(height: 6.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: TextFormField(
              decoration: new InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
                isDense: true,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Description';
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                return post.description = value;
              },
            ),
          ),
          SizedBox(height: 6.0),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: DropdownButtonFormField<String>(
              decoration: new InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: post.type,
              hint: Text(
                'Select type'
              ),
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              onChanged: (String newValue) {
                setState(() {
                  post.type = newValue;
                });
              },
              validator: (value) => value == null ? 'Select type' : null,
              items: <String>[
                'BMX','City','Cruiser','Mountain', 'Road', 'Recumbent',
                'Tandem', 'Touring', 'Other',
              ]
            .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            ),
          ),
          SizedBox(height: 6.0),
          FractionallySizedBox(
              widthFactor: 0.9,
              child: TextFormField(
                decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lock Combination',
                  isDense: true,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Combination';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  return post.lock_combination = value;
                },
              )),
          SizedBox(height: 6.0),
          FractionallySizedBox(widthFactor: 0.9, child: showTags(context)),
          SizedBox(height:8.0),
          FractionallySizedBox(
            widthFactor:0.9,
            child: CheckboxListTile(
              value: checkboxValue,
              onChanged: (val) {
                setState(() => checkboxValue = val);
              },
              subtitle: !checkboxValue
                  ? Text(
                      'Required.',
                      style: TextStyle(color: Colors.red),
                    )
                  : null,
              title: new Text(
                'I agree to a release of interest.',
                style: TextStyle(fontSize: 14.0),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.green,
            )),
          SizedBox(
            height: 15.0,
          ),
          Semantics(
              button: true,
              enabled: true,
              onTapHint: 'Upload Bike',
              child: FractionallySizedBox(
                widthFactor: 0.4,
                child: ElevatedButton(
                  child: Text('Add Bike'),
                  onPressed: () {
                    if (formKey.currentState.validate() && checkboxValue) {
                      formKey.currentState.save();
                      saveToDatabase();
                    }
                  },
                ),
              )),
        ],
      ),
    ));
  }

  @override
  Widget showTags(BuildContext context) {
    double _fontSize = 14;
    post.tags = {};
    return Tags(
      key: _tagStateKey,
      itemCount: _availableTags.length, // required
      itemBuilder: (int index) {
        final tag = _availableTags[index];

        return ItemTags(
          // Each ItemTags must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.
          key: Key(index.toString()),
          active: false,
          color: Colors.white,
          activeColor: Colors.blueAccent,
          index: index, // required
          title: tag,
          textStyle: TextStyle(
            fontSize: _fontSize,
          ),
          combine: ItemTagsCombine.withTextBefore,
          onPressed: (tag) {
            print(tag);
            post.tags[tag.title] = tag.active;
          },
          onLongPressed: (tag) => print(tag),
        );
      },
    );
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
// Allows you to get a list of all the ItemTags
  _getAllItem() {
    List<Item> lst = _tagStateKey.currentState?.getAllItem;
    if (lst != null)
      lst.where((a) => a.active == true).forEach((a) => print(a.title));
  }

  void getLocation() async {
    var locationService = Location();
    location = await locationService.getLocation();
    setState(() {});
  }

  //gallery picture
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = tempImage;
    });
  }

  //camera picture
  Future takePicture() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = tempImage;
    });
  }

  void saveToDatabase() async {
    // handle image
    var timeKey = new DateTime.now().toString();
    var firebaseStorage = FirebaseStorage.instance;
    var snapshot = await firebaseStorage
        .ref()
        .child('images/' + timeKey)
        .putFile(imageFile);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      post.url = downloadUrl;
    });
    post.location = GeoPoint(location.latitude, location.longitude);
    post.upload();
    Navigator.of(context).pushNamed(BikeList.routeName);
  }

  // load tags from file in assets/text directory
  void loadAvailableTags() async {
    String txt = await rootBundle.loadString("assets/text/tags.txt");
    _availableTags = txt.split('\n');
  }
}
