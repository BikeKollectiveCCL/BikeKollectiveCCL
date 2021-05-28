import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/bike.dart';
import '../services/do_uploads.dart';
import '../widgets/text_widgets.dart';

class ReportBikeIssue extends StatefulWidget {
  static const routeName = 'reportBikeIssue';
  @override
  _ReportBikeIssueState createState() => _ReportBikeIssueState();
}

class _ReportBikeIssueState extends State<ReportBikeIssue> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Bike thisBike = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(title: Text('Report bike issue')),
        body: Center(
            child: Column(children: [
          paddedCenteredText(
              'Use the form below to enter any issues with the bike'),
          issueForm(thisBike)
        ])));
  }

  Widget issueForm(Bike thisBike) {
    return Form(
        key: formKey,
        child: Column(children: [
          FractionallySizedBox(
            widthFactor: 0.9,
            child: TextFormField(
              decoration: new InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'If any, enter bike issue(s) here',
                isDense: true,
              ),
              onSaved: (value) {
                if (thisBike.reportedIssues == null) {
                  thisBike.reportedIssues = [];
                }
                if (value != '') {
                  return thisBike.reportedIssues.add(value);
                }
              },
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                formKey.currentState.save();
                updateBikeIssues(thisBike);
                Navigator.pop(context);
              },
              child: Text('Submit issues'))
        ]));
  }
}
