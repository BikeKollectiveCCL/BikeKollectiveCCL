import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BikeKollective',
      home: BikeView(),
    );
  }
}

class BikeView extends StatelessWidget {

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['type'],
              style: Theme.of(context).textTheme.headline5,
            )
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffddddff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(document['rating'].toString()),
            )
        ],
      ),
      subtitle: Text("[${document['location'].latitude.toString()}, ${document['location'].longitude.toString()}]"),
      // onTap: () {
      //   // detail view implementation
      // }
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('BikeKollective'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('bikes').snapshots(),
        builder: (context, snapshot){
          if(!(snapshot.hasData && snapshot.data.documents != null && snapshot.data.documents.length > 0)) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
              _buildListItem(context, snapshot.data.documents[index]),
          );
        }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
              //addBike();
            },
        ),
      );
  }
}


