import 'package:flutter/material.dart';
import 'package:flutter_hive/constants.dart';
import 'package:flutter_hive/models/contact.dart';
import 'package:hive/hive.dart';

class NewContactForm extends StatefulWidget {
  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _number;

  void addContact(Contact contact) {
    print('Name ${contact.name}, Number ${contact.number}');

    // insert contact data to hive
    final contactsBox = Hive.box(CONTACT_BOX);
    contactsBox.add(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (val) => _name = val,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Number'),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => _number = val,
                ),
              ),
            ],
          ),
          RaisedButton(
            child: Text('Add New Contact'),
            onPressed: () {
              _formKey.currentState.save();
              final newContact = Contact(_name, _number);
              addContact(newContact);
            }
          ),
        ],
      ),
    );
  }
}
