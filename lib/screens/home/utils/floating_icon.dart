// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:binergy/controller/data_controller.dart';
import 'package:binergy/controller/ui_controller.dart';
import 'package:binergy/static/project_constants.dart';
import 'package:flutter/material.dart';
import 'package:binergy/models/bin_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LocationCard extends ConsumerStatefulWidget {
  final Bin bin;

  LocationCard({super.key, required this.bin});

  @override
  ConsumerState<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends ConsumerState<LocationCard> {
  bool tap = false;
  bool infoTap = false;
  @override
  Widget build(BuildContext context) {
    final bool flag = ref.watch(
        dataController.select((value) => value.bins.contains(widget.bin)));
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border.all(color: Colors.black, width: 3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: infoTap
                            ? Column(
                                key: ValueKey(0),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      setState(() {
                                        infoTap = !infoTap;
                                      });
                                      ProjectConstants.logger.d(infoTap);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.arrow_back_outlined,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      'Location:\n${widget.bin.location}\n\nLatitude:\n${widget.bin.pos.latitude}\u00B0\nLongitude:\n${widget.bin.pos.longitude}\u00B0',
                                      style:
                                          TextStyle(color: Colors.greenAccent),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                key: ValueKey(1),
                                children: [
                                  //? Indicator
                                  Flexible(
                                    flex: 5,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                flex: 3,
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.delete_rounded,
                                                    color: pickColor(),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () {
                                                    setState(() {
                                                      infoTap = !infoTap;
                                                    });
                                                    ProjectConstants.logger
                                                        .d(infoTap);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.info_outline,
                                                      color: Colors.greenAccent,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: CircularPercentIndicator(
                                              addAutomaticKeepAlive: false,
                                              radius: 25,
                                              lineWidth: 4.0,
                                              percent: widget.bin.state / 100,
                                              startAngle: 0,
                                              animateFromLastPercent: true,
                                              animationDuration: 1500,
                                              restartAnimation: true,
                                              center: FittedBox(
                                                  child: Text(
                                                widget.bin.state.toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                              progressColor: pickColor(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //? Warning sign
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          pickMsg(),
                                          style: TextStyle(
                                            color: pickColor(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //? Select Button
                                  Flexible(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10, top: 5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            backgroundColor: !flag
                                                ? Colors.black
                                                : Colors.greenAccent),
                                        onPressed: () {
                                          ref
                                              .read(userController.notifier)
                                              .handleBinSelect(context, ref,
                                                  flag, widget.bin);
                                        },
                                        child: FittedBox(
                                          child: Text(
                                            !flag ? 'SELECT' : 'REMOVE',
                                            style: TextStyle(
                                              color: !flag
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
              color: pickColor(),
              size: 35,
            ),
          ),
          //?Number icon
          AnimatedSwitcher(
            duration: Duration(
              milliseconds: 300,
            ),
            child: flag
                ? Align(
                    alignment: Alignment(0, 0.2),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: Text(
                        '${ref.watch(dataController.select((value) => value.bins.indexOf(widget.bin) + 1))}',
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Color pickColor() {
    if (widget.bin.state < 35) {
      return ProjectConstants.floatingIconColor[0];
    } else if (widget.bin.state < 80) {
      return ProjectConstants.floatingIconColor[1];
    }
    return ProjectConstants.floatingIconColor[2];
  }

  String pickMsg() {
    if (widget.bin.state < 35) {
      return ProjectConstants.floatingIconMsg[0];
    } else if (widget.bin.state < 80) {
      return ProjectConstants.floatingIconMsg[1];
    }
    return ProjectConstants.floatingIconMsg[2];
  }
}
