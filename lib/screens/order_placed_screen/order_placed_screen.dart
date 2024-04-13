import 'package:coffee_cafe_app/constants/styling.dart';
import 'package:coffee_cafe_app/screens/cart_screen/models/cart_model.dart';
import 'package:coffee_cafe_app/screens/order_placed_screen/utils/place_order_funtion.dart';
import 'package:coffee_cafe_app/screens/parent_screen/providers/parent_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen(
      {super.key,
      required this.cartItems,
      required this.payableAmount,
      required this.paymentMethod,
      required this.orderName,
      required this.isFromCart});

  static String routeName = '/orderPlacedScreen';
  final CartModel cartItems;
  final double payableAmount;
  final String paymentMethod;
  final String orderName;
  final bool isFromCart;

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen>
    with SingleTickerProviderStateMixin {
  bool _animationFinished = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final ParentProvider parentProvider =
        Provider.of<ParentProvider>(context, listen: false);
    placeOrder(context, widget.cartItems, widget.payableAmount,
        widget.paymentMethod, widget.orderName, widget.isFromCart);
    _controller =
        AnimationController(duration: const Duration(seconds: 6), vsync: this);
    _controller.forward();
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        setState(() {
          _animationFinished = true;
        });
        parentProvider.currentIndex = 0;
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.transparent,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (value) {
          if (value) return;
          // if (_animationFinished) {
          //   Navigator.pop(context);
          // }
        },
        child: SizedBox(
          width: screenWidth(context),
          height: screenHeight(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/coffee_animation.json',
                controller: _controller,
                height: screenHeight(context) * 0.4,
                reverse: false,
                repeat: false,
              ),
              const SizedBox(
                height: 20,
              ),
              if (_animationFinished)
                Text(
                  'Order Placed',
                  style: TextStyle(
                    color: greenColor,
                    fontSize: screenHeight(context) * 0.08,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Whisper',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
