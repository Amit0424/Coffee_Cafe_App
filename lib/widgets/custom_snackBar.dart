import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    super.key,
    required this.upperText,
    required this.lowerText,
  });

  final String upperText;
  final String lowerText;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            height: 90,
            decoration: const BoxDecoration(
                color: Color(0xffc72c41),
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Row(
              children: [
                const SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upperText,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        lowerText,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.only(bottomLeft: Radius.circular(20.0)),
              child: SvgPicture.asset(
                'assets/images/bubbles.svg',
                height: 48,
                width: 40,
                color: const Color(0xff801336),
              ),
            ),
          ),
          Positioned(
            top: -20.0,
            left: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/fail.svg',
                  height: 40,
                ),
                Positioned(
                  top: 10.0,
                  child: SvgPicture.asset(
                    'assets/images/close.svg',
                    height: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
