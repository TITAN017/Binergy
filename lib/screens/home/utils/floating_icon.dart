// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:binergy/controller/data_controller.dart';
import 'package:binergy/controller/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:binergy/models/bin_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationCard extends StatefulWidget {
  final Bin bin;

  LocationCard({super.key, required this.bin});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  final List<List<Color>> colors = [
    [Color(0xFF11998e), Color(0xFF38ef7d)],
    [Color.fromRGBO(255, 190, 32, 1), Color.fromRGBO(251, 112, 71, 1)],
    [Color(0xFFe52d27), Color(0xFFb31217)]
  ];
  bool tap = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: !tap
                ? SizedBox()
                : Align(
                    alignment: Alignment(0, -1.25),
                    child: AnimatedContainer(
                      width: 120,
                      height: 150,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: pickColor(),
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.red[500]!, width: 3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(flex: 5, child: Text('Information!')),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Consumer(builder: (context, ref, _) {
                                final bool flag = ref.watch(
                                    dataController.select((value) =>
                                        value.bins.contains(widget.bin.id)));
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 9),
                                      backgroundColor:
                                          !flag ? Colors.black : Colors.white),
                                  onPressed: () {
                                    if (flag) {
                                      ref
                                          .read(dataController.notifier)
                                          .removeBin(widget.bin.id);
                                    } else {
                                      ref
                                          .read(dataController.notifier)
                                          .addBins(widget.bin.id);
                                    }
                                  },
                                  child: FittedBox(
                                    child: Text(
                                      !flag ? 'SELECT' : 'REMOVE',
                                      style: TextStyle(
                                        color:
                                            !flag ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                tap = !tap;
              });
            },
            child: Icon(
              IconData(
                0xe3ab,
                fontFamily: 'MaterialIcons',
              ),
              color: pickColor()[0],
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> pickColor() {
    if (widget.bin.state < 35) {
      return colors[0];
    } else if (widget.bin.state < 80) {
      return colors[1];
    }
    return colors[2];
  }
}
