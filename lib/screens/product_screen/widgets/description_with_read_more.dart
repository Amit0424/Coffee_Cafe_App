import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';

class DescriptionWithReadMore extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final int maxLines;

  const DescriptionWithReadMore({
    Key? key,
    required this.text,
    required this.textStyle,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  State<DescriptionWithReadMore> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<DescriptionWithReadMore> {
  late String firstPart;
  late String secondPart;
  bool showReadMore = true;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > 100) {
      // Arbitrary length, adjust based on your needs
      firstPart = widget.text.substring(0, 100);
      secondPart = widget.text.substring(100, widget.text.length);
    } else {
      firstPart = widget.text;
      secondPart = '';
      showReadMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: firstPart, style: widget.textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        if (tp.didExceedMaxLines) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isExpanded
                  ? Text(widget.text, style: widget.textStyle)
                  : Text(firstPart, style: widget.textStyle),
              InkWell(
                child: Row(
                  children: [
                    Text(
                      isExpanded ? 'Read Less' : 'Read More',
                      style: TextStyle(color: darkYellowColor),
                    ),
                    Icon(
                      isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ],
          );
        } else {
          return Text(widget.text, style: widget.textStyle);
        }
      },
    );
  }
}
