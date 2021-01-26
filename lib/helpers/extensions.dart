import 'package:flutter/material.dart';

extension Extra on TimeOfDay{
  String formatted(){
    return '${hour.toString().padLeft(2,'0')}h:${minute.toString().padLeft(2,'0')}h';
  }

  int toMinutes() => hour*60 + minute;
}