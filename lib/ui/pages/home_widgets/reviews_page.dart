import 'package:flutter/material.dart';
import 'package:gelic_bakes/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:gelic_bakes/constants/constants.dart';

class ReviewsPage extends StatefulWidget with NavigationState {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          reviews,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        mini: true,
        backgroundColor: Colors.pink,
      ),
    );
  }
}
