import 'package:flutter/material.dart';
import 'package:pdil/utils/utils.dart';

class TextContainer extends StatefulWidget {
  final String judul;
  final String data;
  final bool isBottom;
  final TypeTextContainer type;

  TextContainer({
    Key key,
    this.judul = "title",
    this.data = "data",
    this.isBottom = false,
    this.type = TypeTextContainer.type_a,
  }) : super(key: key);
  @override
  _TextContainerState createState() => _TextContainerState();
}

class _TextContainerState extends State<TextContainer> {
  @override
  Widget build(BuildContext context) {
    return widget.type == TypeTextContainer.type_a
        ? _container(width: 0.7, isMargin: true)
        : Padding(
            padding:
                EdgeInsets.fromLTRB(25, 25, 25, (widget.isBottom) ? 10 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.judul,
                  style: title12,
                ),
                SizedBox(height: 5),
                _container(width: 0.9, isMargin: false),
              ],
            ),
          );
  }

  Widget _container({double width, bool isMargin}) => Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width * width,
        height: 30,
        margin: EdgeInsets.all((isMargin) ? 25 : 0),
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 5),
          scrollDirection: Axis.horizontal,
          children: [Text(widget.data)],
        ),
      );
}

enum TypeTextContainer { type_a, type_b }
