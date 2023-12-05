import 'package:binergy/controller/data_controller.dart';
import 'package:binergy/screens/auth/utils/button.dart';
import 'package:binergy/static/project_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends ConsumerStatefulWidget {
  const QRScanner({super.key});

  @override
  ConsumerState<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends ConsumerState<QRScanner> {
  late final MobileScannerController controller;

  @override
  void initState() {
    controller = MobileScannerController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final id = ref.watch(idController);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 10),
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.greenAccent[100]!, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MobileScanner(
                    controller: controller,
                    onDetect: (barcode) {
                      ref
                          .read(idController.notifier)
                          .update((state) => barcode.raw[0]['rawValue']);
                      ProjectConstants.logger.d(id);
                      controller.stop();
                    },
                  ),
                ),
              ),
              Button(
                text: 'Scan',
                callback: () {
                  ref.read(idController.notifier).update((state) => null);
                  controller.start();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Button(
                text: 'Cancel',
                callback: () {
                  ref.read(idController.notifier).update((state) => null);
                  context.pop(null);
                },
              ),
              id != null
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          height: 50,
                          child: Text(
                            'Bin ID : $id',
                            style: TextStyle(color: Colors.greenAccent[100]),
                          ),
                        ),
                        Button(
                            text: 'Confirm',
                            callback: () {
                              context.pop(id);
                            }),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      )),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
