// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: FloatingSearchBar(
        transition: ExpandingFloatingSearchBarTransition(),
        progress: false,
        queryStyle: TextStyle(color: Colors.greenAccent),
        margins: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
        iconColor: Colors.greenAccent,
        accentColor: Colors.greenAccent,
        backdropColor: Colors.transparent,
        height: MediaQuery.of(context).size.height / 11,
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.black,
        openWidth: MediaQuery.of(context).size.width - 20,
        debounceDelay: Duration(milliseconds: 100),
        hintStyle: TextStyle(color: Colors.greenAccent[100]),
        elevation: 0,
        shadowColor: Colors.transparent,
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: List.generate(10, (index) => CustomCard()),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 15,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[850],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                IconData(0xe3ab, fontFamily: 'MaterialIcons'),
                color: Colors.greenAccent,
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Center(
              child: Text(
                'Location...',
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
