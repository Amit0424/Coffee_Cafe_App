import 'dart:developer';

import 'package:coffee_cafe_app/main.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  static String routeName = '/addProductScreen';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController image = TextEditingController();

  String selectedCategory = 'Hot Coffee';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'Enter Product Name',
              ),
              controller: name,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Product Price',
                hintText: 'Enter Product Price',
              ),
              controller: price,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Product Description',
                hintText: 'Enter Product Description',
              ),
              controller: description,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Product Image',
                hintText: 'Enter Product Image',
              ),
              controller: image,
            ),
            DropdownButton(
              hint: const Text('Please choose a category'),
              value: selectedCategory,
              items: const [
                DropdownMenuItem(
                    value: 'Hot Coffee', child: Text('Hot Coffee')),
                DropdownMenuItem(
                    value: 'Cold Coffee', child: Text('Cold Coffee')),
                DropdownMenuItem(value: 'Iced Tea', child: Text('Iced Tea')),
                DropdownMenuItem(value: 'Hot Tea', child: Text('Hot Tea')),
                DropdownMenuItem(value: 'Smoothie', child: Text('Smoothie')),
                DropdownMenuItem(value: 'Milkshake', child: Text('Milkshake')),
                DropdownMenuItem(value: 'Soda', child: Text('Soda')),
                DropdownMenuItem(value: 'Juice', child: Text('Juice')),
              ],
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
                log(selectedCategory);
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final id = fireStore.collection('products').doc().id;
                final double pric = double.parse(price.text.trim());
                await fireStore.collection('products').doc(id).set({
                  'id': id,
                  'name': name.text.trim(),
                  'price': pric,
                  'description': description.text.trim(),
                  'imageUrl': image.text.trim(),
                  'category': selectedCategory,
                });
                name.clear();
                price.clear();
                image.clear();
                description.clear();
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
