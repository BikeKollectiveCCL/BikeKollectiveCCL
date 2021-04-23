import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:location/location.dart';
import '../models/bikeDTO.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/sign_in.dart';


class AddBike extends StatefulWidget {
  static const routeName = 'addBike';
  @override
  _AddBikeState createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {
  String url;
  File imageFile;
  LocationData location;

  final post = BikeDTO();
  final formKey =  GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Bike'),
      ),
      body: new Center(
        child: imageFile == null? (buildColumn()): enableUpload(),
      ),
    );
    }
    else {
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

   Widget enableUpload(){
    return new Container(
      child: new Form(
        key: formKey,
        child: ListView(
          children: <Widget>
          [
            Image.file(imageFile, height: 165.0, width: 330,),
            SizedBox(height: 6.0),
            FractionallySizedBox(
              widthFactor: 0.9,
              child:TextFormField(
                decoration: new InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
                isDense: true,),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Description';
                  } else{
                    return null;
                  }
                },
                onSaved: (value){
                  return post.description = value;
                },
              ),
            ),
            SizedBox(height: 6.0),
            FractionallySizedBox(
              widthFactor: 0.9,
              child:TextFormField(
                decoration: new InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type',
                isDense: true),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Type';
                  } else{
                    return null;
                  }
                },
                onSaved: (value){
                  return post.type = value;
                },
              ),
            ),
            SizedBox(height: 6.0),
            FractionallySizedBox(
              widthFactor: 0.9,
              child:TextFormField(
                decoration: new InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Lock Combination',
                isDense: true,),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Combination';
                  } else{
                    return null;
                  }
                },
                onSaved: (value){
                  return post.lock_combination = value;
                },
              )
            ),
            SizedBox(height: 15.0,),
            Semantics(
              button: true,
              enabled: true,
              onTapHint: 'Upload Bike',
              child: FractionallySizedBox(
                widthFactor: 0.4,
                child:ElevatedButton(
                  child: Text('Add Bike'),
                  onPressed: () {
                    if(formKey.currentState.validate()){
                      formKey.currentState.save();
                      saveToDatabase();
                    }
                  },              
                  ),
            )
            ),
          ],
        ),
      )
    );
  }

  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    var locationService = Location();
    location = await locationService.getLocation();
    setState( () {});
  }

  //gallery picture
  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = tempImage;
    });
  }

  //camera picture
  Future takePicture() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = tempImage;
    });
  }

  void saveToDatabase() async{
    // handle image
    var timeKey = new DateTime.now().toString();
    var firebaseStorage = FirebaseStorage.instance;
    var snapshot = await firebaseStorage.ref().child('images/'+timeKey).putFile(imageFile);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      post.url = downloadUrl;
    });
    post.location = GeoPoint(location.latitude, location.longitude);
    post.upload();
    Navigator.of(context).pop();    
  }


}
