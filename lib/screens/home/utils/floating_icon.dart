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
  final List<Color> colors = [Colors.green, Colors.orange[300]!, Colors.red];
  bool tap = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tap = !tap;
        });
      },
      child: SizedBox(
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
                        width: 100,
                        height: 150,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: pickColor(),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(flex: 3, child: Text('Information!')),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Consumer(builder: (context, ref, _) {
                                  final bool flag = ref.watch(
                                      dataController.select((value) =>
                                          value.bins.contains(widget.bin.id)));
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        backgroundColor: !flag
                                            ? Colors.greenAccent
                                            : Colors.red),
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
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
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
            Icon(
              IconData(
                0xe3ab,
                fontFamily: 'MaterialIcons',
              ),
              color: Colors.red,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }

  Color pickColor() {
    if (widget.bin.state < 35) {
      return colors[0];
    } else if (widget.bin.state < 80) {
      return colors[1];
    }
    return colors[2];
  }
}
