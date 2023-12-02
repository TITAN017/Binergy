// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:binergy/controller/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  CustomAppBar({super.key});

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    bool flag =
        ref.watch(dataController.select((value) => value.allRoutes.isNotEmpty));
    List times = ref.watch(dataController
        .select((value) => value.allRoutes.map((e) => e[1]).toList()));
    times = times.isEmpty ? [0.0, 0.0, 0.0] : times;
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
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
            onFocusChanged: (event) {
              setState(() {
                flag = flag && !event;
              });
            },
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
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
  });

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
