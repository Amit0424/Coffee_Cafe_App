import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cafe_app/main.dart';
import 'package:coffee_cafe_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/styling.dart';
import 'edit_screen.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({super.key});

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.grey[300],
        surfaceTintColor: Colors.white,
        title: const Text('Products List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStore
                  .collection('products')
                  .orderBy('addedDate', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                }

                return SizedBox(
                  width: screenWidth(context),
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditScreen(
                                        id: document.id,
                                        name: data['name'],
                                        price: double.parse(
                                            data['price'].toString()),
                                        description: data['description'],
                                        image: data['imageUrl'],
                                        category: data['category'],
                                        makingMinutes: data['makingTime'],
                                        inStock: data['inStock'],
                                        isVisible: data['isVisible'],
                                      )));
                            },
                            child: Container(
                              color: const Color(0xffeeeeee),
                              width: screenWidth(context),
                              height: 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: data['imageUrl'],
                                    height: 100,
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          data['price'].toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: greenColor),
                                        ),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Text(
                                              data['description'],
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          data['category'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: screenHeight(context) * 0.08),
        ],
      ),
    );
  }
}
