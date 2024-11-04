import 'package:flutter/material.dart';

class MagnitudeColorFormatter {
  static TextStyle getMagnitudeColor(double magnitude) {
    int magnitudeLevel;
    Color magnitudeColor;
        
        if (magnitude < 3) {
            magnitudeLevel = 1;
        } 
        else if (magnitude >= 3 && magnitude < 5) {
            magnitudeLevel = 2;
        }
        else {
            magnitudeLevel = 3;
        }
        
        switch (magnitudeLevel) {
        case 1:
            magnitudeColor = Colors.green;
        case 2:
            magnitudeColor = Colors.orange;
        case 3:
            magnitudeColor = Colors.red;
        default:
            magnitudeColor = Colors.blue;
        }
        
    return TextStyle(color: magnitudeColor, fontWeight: FontWeight.w800, fontSize: 18);
  }
}