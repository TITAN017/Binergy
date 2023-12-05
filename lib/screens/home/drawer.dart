// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:binergy/controller/data_controller.dart';
import 'package:binergy/controller/ui_controller.dart';
import 'package:binergy/shared/banner.dart';
import 'package:binergy/shared/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  final String name;
  final GlobalKey<ScaffoldState> skey;
  const CustomDrawer({super.key, required this.name, required this.skey});

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final bool dev = ref.watch(userController.select((value) => value.dev));
    return Drawer(
      backgroundColor: Colors.black,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Welcome To Binergy!,\n\n${widget.name == 'NULL' ? 'User' : widget.name}',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 50),
          ListTile(
            onTap: () async {
              await ref.read(userController.notifier).devMode(context, ref);
            },
            tileColor: Colors.grey[850],
            leading: Icon(
              Icons.developer_mode,
              color: Colors.white,
            ),
            title: Text(
              'Dev Mode',
              style: TextStyle(color: Colors.greenAccent),
            ),
            trailing: Icon(
              Icons.circle,
              color: dev ? Colors.green : Colors.red,
            ),
          ),
          SizedBox(height: 10),
          dev
              ? ListTile(
                  onTap: () async {
                    Scaffold.of(context).closeDrawer();
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                    ref.read(idController.notifier).update((state) => null);
                    final String? id = await context.push('/scan') as String?;
                    if (id == null) {
                      showSnackBar(
                          widget.skey.currentContext!, 'Closed Add Bin');
                      return;
                    } else {
                      await Future.delayed(Duration(milliseconds: 100));
                      showBanner(
                        widget.skey,
                        Text(
                          'Place The Bin On The Map',
                          style: TextStyle(color: Colors.greenAccent[100]),
                        ),
                      );
                    }
                  },
                  tileColor: Colors.grey[850],
                  leading: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Add Bin',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                  trailing: Icon(
                    Icons.circle,
                    color: Colors.green,
                  ),
                )
              : SizedBox(),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: IconButton(
              onPressed: () async {
                ref.read(userController.notifier).logoutWrapper(context, ref);
              },
              color: Colors.grey[850],
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.greenAccent,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
