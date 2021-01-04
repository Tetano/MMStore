import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:michellemirandastore/models/user.dart';

import 'order.dart';

class AdminOrdersManager extends ChangeNotifier{
  User user;

  List<Order> orders = [];

  final Firestore firestore = Firestore.instance;
  StreamSubscription _subscription;

  void updateAdmin({bool adminEnabled}){
    orders.clear();

    _subscription?.cancel();
    if(adminEnabled){
      _listenToOrders();
    }
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders')
        .snapshots().listen(
            (event) {
          orders.clear();
          for(final doc in event.documents){
            orders.add(Order.fromDocument(doc));
          }

          print(orders);
          notifyListeners();
        });
  }

  @override
  void dispose(){
    super.dispose();
    _subscription?.cancel();
  }

}
