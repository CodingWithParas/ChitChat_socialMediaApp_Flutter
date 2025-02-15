import 'package:chit_chat/Theme/dark_mode.dart';
import 'package:chit_chat/Theme/light_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/*
  THEME PROVIDER

  This help us change the app from dark and light mode

  */

class ThemeProvider extends ChangeNotifier {

  // initially set it as light mode
  ThemeData _themeData = lightMode;

  // get the current theme
  ThemeData get themeData => _themeData;

  // is it dark mode currently?
  bool get isDarkMode => _themeData == darkMode;

  // set the theme
  set themeData(ThemeData themeData){
    _themeData = themeData;

    //  update UI
    notifyListeners();
  }

  // toggle between dark and light
  void toggleTheme(){
    if(_themeData == lightMode) {
      themeData = darkMode;
    }else{
      themeData = lightMode;
    }
  }
}