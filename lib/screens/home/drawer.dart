// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:binergy/controller/ui_controller.dart';
import 'package:binergy/shared/banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDrawer extends ConsumerWidget {
  final String name;
  final GlobalKey<ScaffoldState> skey;
  const CustomDrawer({super.key, required this.name, required this.skey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              'Welcome To Binergy!,\n\n${name == 'NULL' ? 'User' : name}',
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
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    showBanner(
                        skey,
                        Text(
                          'Place The Bin On The Map',
                          style: TextStyle(color: Colors.greenAccent[100]),
                        ),
                        () {});
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
