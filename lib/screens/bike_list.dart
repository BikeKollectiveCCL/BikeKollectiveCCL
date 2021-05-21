import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../models/bike.dart';
import '../screens/bike_view.dart';
import '../widgets/navdrawer.dart';
import '../widgets/ratingDisplay.dart';
import '../screens/sign_in.dart';
import '../helpers/tags.dart';

class BikeList extends StatefulWidget {
  static const routeName = 'bikeList';
  @override
  _BikeListState createState() => _BikeListState();
}

class _BikeListState extends State<BikeList> {
  TextEditingController editingController = TextEditingController();
  bool activeSearch;
  var searchQuery;

  @override
  void initState() {
    super.initState();
    activeSearch = false;
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return Scaffold(
        appBar: _appBar(),
        body: bikeList(),
        drawer: navDrawer(context),
      );
    } else {
      return SignIn();
    }
  }

  StreamBuilder bikeList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('bikes')
            .orderBy('checked_out')
            .orderBy('rating', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data.docs != null &&
              snapshot.data.docs.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) => _buildListItem(context, snapshot.data.docs[index]),
                // {
                // var thisBike = Bike.fromMap(snapshot.data.docs[index].data(), snapshot.data.docs[index].reference.id);
                // var thisBikeTags = thisBike.tags;
                // if (searchQuery == null){
                //   return _buildListItem(context, snapshot.data.docs[index]);
                // }
                // else if (thisBikeTags != null && thisBikeTags.containsKey(searchQuery)) {
                //   return _buildListItem(context, snapshot.data.docs[index]);
                // }
                // } 
            );
          } else {
            print(snapshot);
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final thisBike = Bike.fromMap(document.data(), document.reference.id);
    var rating;
    if (thisBike.averageRating != null) {
      rating = double.parse(thisBike.averageRating.toStringAsFixed(1));
    } else {
      rating = 'n/a';
    }
    return Semantics(
        button: true,
        onTapHint: 'view bike',
        child: ListTile(
          leading: Image.network(thisBike.url,
              height: 50, width: 70, fit: BoxFit.fill),
          trailing: rating != 'n/a' ? ratingDisplay(rating, 15.0) : Text('n/a'),
          title: Text('${thisBike.bikeType}'),
          subtitle: Flexible(
            child: new Container(
              padding: new EdgeInsets.only(right: 13.0),
              child: new Text(
                '${thisBike.bikeDescription}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(BikeView.routeName, arguments: thisBike);
          },
          tileColor: thisBike.isCheckedOut ? Colors.red.shade100 : Colors.white,
        ));
  }

  PreferredSizeWidget _appBar() {
    if (activeSearch == true) {
      return AppBar(
        leading: Icon(Icons.search),
        title: DropdownButton(
          value: searchQuery,
          hint: Text('Search by tag'),
          items: availableTags.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => setState(() {
              activeSearch = false;
              searchQuery = null;
            }               
            ),
          )
        ],
      );
    } else {
      return AppBar(
        title: Text("Bike Kollective"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => setState(() => activeSearch = true),
          ),
        ],
      );
    }
  }
}
