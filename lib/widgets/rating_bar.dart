import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({super.key, required this.productId});
  final String productId;

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  double _rating = 1;

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
                    _rating = index + 1;
                  });
                  log(widget.productId);
                  await fireStore
                      .collection('products')
                      .doc(widget.productId)
                      .update({
                    'rating': FieldValue.arrayUnion([_rating])
                  });
                },
                child: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: index < _rating ? darkYellowColor : yellowColor,
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
          'Your rating: $_rating',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
