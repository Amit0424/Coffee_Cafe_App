import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Products'),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _productsStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: LoadingWidget(),
                );
              }

              return Container(
                height: screenHeight(context) * 0.8,
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
                                    )));
                          },
                          child: Container(
                            color: const Color(0xffeeeeee),
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: data['imageUrl'],
                                height: 100,
                              ),
                              title: Text(data['name']),
                              subtitle: Text(data['price'].toString()),
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
          SizedBox(height: screenHeight(context) * 0.08),
        ],
      ),
    );
  }
}
