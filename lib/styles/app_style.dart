import 'package:flutter/material.dart';

class AppStyle{
static progress(context){
  showDialog(context: context, builder: (context){
    return const Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  );
}
}
  