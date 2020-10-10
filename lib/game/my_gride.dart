import 'package:flutter/material.dart';
class MyGride extends StatelessWidget {
  List<int> shaps;
  List<int> previoeShapes;
  Color pieceColor;
  MyGride({this.shaps, this.pieceColor, this.previoeShapes});
  @override
  Widget build(BuildContext context) {
   
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 150,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
      itemBuilder: (context, index) {
      
        return Container(
         
          decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              color: shaps.contains(index) || previoeShapes.contains(index)
                  ? pieceColor
                  : Colors.black),
        );
      },
    );
  }
}
