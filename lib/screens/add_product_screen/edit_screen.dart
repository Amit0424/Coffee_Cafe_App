import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants/styling.dart';
import '../../main.dart';

class EditScreen extends StatefulWidget {
  const EditScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.image,
      required this.category});

  final String id;
  final String name;
  final double price;
  final String description;
  final String image;
  final String category;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController image = TextEditingController();

  String selectedCategory = 'Hot Coffee';
  bool inStock = true;
  bool isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.name;
    price.text = widget.price.toString();
    description.text = widget.description;
    image.text = widget.image;
    selectedCategory = widget.category;
  }

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
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    name.clear();
                  });
                },
                child: const Text('clear previous name')),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'Enter Product Name',
              ),
              controller: name,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    price.clear();
                  });
                },
                child: const Text('clear previous price')),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Product Price',
                hintText: 'Enter Product Price',
              ),
              controller: price,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    description.clear();
                  });
                },
                child: const Text('clear previous description')),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Product Description',
                hintText: 'Enter Product Description',
              ),
              controller: description,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    image.clear();
                  });
                },
                child: const Text('clear previous image')),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        inStock = !inStock;
                      });
                    },
                    child: const Text('In Stock')),
                Checkbox(
                    value: inStock,
                    onChanged: (value) {
                      setState(() {
                        inStock = value!;
                      });
                    }),
                SizedBox(
                  width: screenWidth(context) * 0.2,
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    child: const Text('Is Visible')),
                Checkbox(
                    value: isVisible,
                    onChanged: (value) {
                      setState(() {
                        isVisible = value!;
                      });
                    }),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                final double pric = double.parse(price.text.trim());
                await fireStore.collection('products').doc(widget.id).update({
                  'name': name.text.trim(),
                  'price': pric,
                  'description': description.text.trim(),
                  'imageUrl': image.text.trim(),
                  'category': selectedCategory,
                  'inStock': inStock,
                  'isVisible': isVisible,
                });
                Fluttertoast.showToast(
                    msg: "Changes Done👍",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    // Positioning the toast. Other values include TOP, CENTER, etc.
                    timeInSecForIosWeb: 1,
                    // Duration the toast displays on iOS and web
                    backgroundColor: Colors.red,
                    // Background color of the toast
                    textColor: Colors.white,
                    // Text color
                    fontSize: 16.0 // Font size
                    );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
