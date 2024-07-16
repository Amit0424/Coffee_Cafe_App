import 'dart:developer';

import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';

class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget(
      {super.key,
      required this.productId,
      required this.index,
      required this.ratings});

  final String productId;
  final int index;
  final List<Map<String, int>> ratings;

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  List<String> selectedFeedback = [];
  int rating = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: screenHeight(context) * 0.05,
          width: screenWidth(context) * 0.4,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    rating = index + 1;
                  });
                  widget.ratings[widget.index] = {widget.productId: rating};
                  log(widget.ratings.toString());
                  log(widget.productId);
                },
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: index < rating ? darkYellowColor : yellowColor,
                  size: screenWidth(context) * 0.08,
                ),
              );
            },
          ),
        ),
        // PannableRatingBar(
        //   rate: _rating,
        //   items: List.generate(
        //     5,
        //     (index) => RatingWidget(
        //       selectedColor: yellowColor,
        //       unSelectedColor: Colors.grey,
        //       child: Icon(
        //         Icons.star_border,
        //         size: screenHeight(context) * 0.04,
        //       ),
        //     ),
        //   ),
        //   onHover: (value) {
        //     // the rating value is updated every time the cursor moves over a new item.
        //     setState(() {
        //       _rating = value;
        //     });
        //   },
        // ),
        Text(
          'Your rating: $rating',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
