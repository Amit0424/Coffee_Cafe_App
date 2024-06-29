import 'dart:developer';

import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/rating_provider.dart';

class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({super.key, required this.productId});
  final String productId;

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  int _rating = 1;

  @override
  Widget build(BuildContext context) {
    final RatingProvider ratingProvider = Provider.of<RatingProvider>(context);
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
                  ratingProvider.setRatings({widget.productId: _rating}, index);
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
          'Your rating: ${ratingProvider.ratings[_rating-1][widget.productId] ?? 0}',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
