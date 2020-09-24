import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:michellemirandastore/models/section.dart';

class HomeManager extends ChangeNotifier {

  HomeManager(){
    _loadSections();
  }

  List<Section> sections = [];

  final Firestore firestore = Firestore.instance;

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen((snapshot) {
      sections.clear();
      for(final DocumentSnapshot document in snapshot.documents){
        sections.add(Section.fromDocument(document));
      }
      print(sections);
      notifyListeners();
    });
  }
}