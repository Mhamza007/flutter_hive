import 'package:flutter/material.dart';
import 'package:flutter_hive/constants.dart';
import 'package:flutter_hive/models/contact.dart';
import 'package:flutter_hive/new_contact_form.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Hive'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildListView()),
          NewContactForm(),
        ],
      ),
    );
  }
}

Widget _buildListView() {
  // final contactBox = Hive.box(CONTACT_BOX);
  return WatchBoxBuilder(
    box: Hive.box(CONTACT_BOX),
    builder: (context, contactBox) {
      return ListView.builder(
        itemCount: contactBox.length,
        itemBuilder: (context, index) {
          final contact = contactBox.getAt(index) as Contact;
          return ListTile(
            title: Text(contact.name),
            subtitle: Text(contact.number),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    contactBox.putAt(
                      index,
                      Contact('${contact.name}*', contact.number),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    contactBox.deleteAt(index);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
