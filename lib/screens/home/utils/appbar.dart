// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:binergy/controller/data_controller.dart';
import 'package:binergy/controller/ui_controller.dart';
import 'package:binergy/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  CustomAppBar({super.key});

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

bool focus = false;

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    bool flag = ref.watch(
        dataController.select((value) => value.allRoutes.isNotEmpty && !focus));
    List times = ref.watch(dataController
        .select((value) => value.allRoutes.map((e) => e[1]).toList()));
    final bool loading =
        ref.watch(dataController.select((value) => value.loading));
    final List locs = ref.watch(dataController.select((value) => value.locs));
    times = times.isEmpty ? [0.0, 0.0, 0.0] : times;
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: FloatingSearchBar(
            controller: ref.watch(appBarControllerProvider),
            transition: ExpandingFloatingSearchBarTransition(),
            progress: loading,
            queryStyle: TextStyle(color: Colors.greenAccent),
            margins: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
            iconColor: Colors.greenAccent,
            accentColor: Colors.greenAccent,
            backdropColor: Colors.transparent,
            height: MediaQuery.of(context).size.height / 11,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.black,
            openWidth: MediaQuery.of(context).size.width - 20,
            debounceDelay: Duration(milliseconds: 400),
            hintStyle: TextStyle(color: Colors.greenAccent[100]),
            elevation: 0,
            shadowColor: Colors.transparent,
            onSubmitted: (text) {
              ref.read(dataController.notifier).getLocations(ref, text);
            },
            onQueryChanged: (text) {
              ref.read(dataController.notifier).getLocations(ref, text);
            },
            onFocusChanged: (event) {
              setState(() {
                focus = event;
              });
            },
            builder: (context, transition) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: locs
                        .map((e) => CustomCard(
                              data: e,
                            ))
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 11 + 15,
          left: 10,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: flag
                ? Container(
                    key: ValueKey('1'),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: RouteMode(
                            index: 0,
                            icon: IconData(0xe1d7, fontFamily: 'MaterialIcons'),
                            time: times[0],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: RouteMode(
                            index: 1,
                            icon: Icons.motorcycle,
                            time: times[1],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: RouteMode(
                            index: 2,
                            icon: IconData(0xe1e1, fontFamily: 'MaterialIcons'),
                            time: times[2],
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    key: ValueKey('2'),
                  ),
          ),
        ),
      ],
    );
  }
}

class RouteMode extends ConsumerWidget {
  final int index;
  final IconData icon;
  final double time;
  const RouteMode(
      {super.key, required this.icon, required this.index, required this.time});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          showSnackBar(ref.context, 'Displaying Car Route');
        } else if (index == 1) {
          showSnackBar(ref.context, 'Displaying Motorcycle Route');
        } else {
          showSnackBar(ref.context, 'Displaying Walking Route');
        }
        ref.read(dataController.notifier).updateRoute(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.greenAccent,
            ),
            Text(
              '${double.parse((time / 60).toStringAsFixed(2))} Min(s)',
              style: TextStyle(
                color: Colors.greenAccent[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends ConsumerWidget {
  final Map data;
  const CustomCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(appBarControllerProvider).close();
        ref.read(dataController.notifier).updateTapPos(ref, data['pos']);
        ref.read(mapControllerProvider)!.animateTo(dest: data['pos'], zoom: 15);
      },
      child: Container(
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
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        child: Text(
                          '${data['line1']}',
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        child: Text(
                          '${data['line2']}',
                          style: TextStyle(color: Colors.greenAccent[100]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
