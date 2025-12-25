import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final bool showFilterBottom;
  const SearchScreen({super.key, required this.showFilterBottom});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(showFilterBottom ? "Filter Search" : "Search")),
      body: Center(child: Text("Filter Open: $showFilterBottom")),
    );
  }
}