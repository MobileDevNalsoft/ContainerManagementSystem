// ignore: avoid_web_libraries_in_flutter

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';
import 'package:warehouse_3d/bloc/work_queue/work_queue_bloc.dart';
import 'package:warehouse_3d/models/areas_model.dart';
import 'package:warehouse_3d/utils/url_navigator.dart';

class Customs {
  static Widget DataSheet(
      {required Size size, required String title, required List<Widget> children, controller, required BuildContext context, void Function()? onExit}) {
    final ContainerInteractionBloc containerInteractionBloc = context.read<ContainerInteractionBloc>();
    return Container(
      height: size.height * 0.92,
      width: size.width * 0.22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          // color: Color.fromRGBO(54, 24, 110, 1),
          // color: Color.fromRGBO(198, 142, 253, 1),
          color: Color.fromRGBO(242, 228, 255, 1),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10, spreadRadius: 5, offset: Offset(0, 8))]),
      padding: EdgeInsets.only(right: size.height * 0.012, bottom: size.height * 0.012, top: size.height * 0.012, left: size.height * 0.012),
      child: LayoutBuilder(builder: (context, layout) {
        return Column(
          children: [
            Container(
              height: size.height * 0.065,
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Color.fromRGBO(82, 39, 155, 1),
                color: Color.fromRGBO(164, 111, 218, 1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1.5, spreadRadius: 0.5)],
                border: Border.all(
                    // color: Color.fromRGBO(117, 72, 195, 1)
                    width: 1.5,
                    color: Color.fromRGBO(111, 54, 167, 1)),
              ),
              child: Row(
                children: [
                  InkWell(
                      onTap: onExit,
                      child: const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Color.fromRGBO(111, 54, 167, 1),
                      )),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(-size.width * 0.0065, 0),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color.fromRGBO(111, 54, 167, 1), fontSize: size.width * 0.012, letterSpacing: 1.6, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(size.height * 0.02),
            ...children
          ],
        );
      }),
    );
  }

  static Widget AreaData({required Area area, required Size size}) {
    return Container(
      height: size.height * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(color: Color.fromRGBO(191, 208, 228, 1), borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Avalable Lots',
                style: TextStyle(fontSize: 16),
              ),
              Text('Occupied Lots', style: TextStyle(fontSize: 16)),
              Text('Total Lots', style: TextStyle(fontSize: 16))
            ],
          ),
          Gap(size.width * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(area.lots!.where((lot) => lot.containers!.length < 3).length.toString(), style: const TextStyle(fontSize: 16)),
              Text(area.lots!.where((lot) => lot.containers!.length == 3).length.toString(), style: const TextStyle(fontSize: 16)),
              Text(area.lots!.length.toString(), style: const TextStyle(fontSize: 16))
            ],
          )
        ],
      ),
    );
  }

  static void AnimatedDialog({required BuildContext context, required Widget header, required List<Widget> content, Function? onClose}) {
    Size size = MediaQuery.of(context).size;

    showGeneralDialog(
      context: context,
      barrierColor: Colors.black45,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.bounceInOut.transform(animation.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(builder: (context, state) {
          return PointerInterceptor(
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.4),
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.only(top: size.height * 0.035),
                      width: size.width * 0.16,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: size.height * 0.005, right: size.width * 0.002),
                              child: PointerInterceptor(
                                child: InkWell(
                                  onTap: () {
                                    if (onClose != null) {
                                      onClose();
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    weight: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ...content,
                          Gap(size.height * 0.01),
                        ],
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: DialogTopClipper(),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 35,
                      child: Transform.translate(offset: Offset(0, -size.height * 0.01), child: header),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static void PendigDialog({required BuildContext context, Widget? content}) {
    Size size = MediaQuery.of(context).size;
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black45,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.bounceInOut.transform(animation.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(builder: (context, state) {
          return PointerInterceptor(
            child: BlocBuilder<WorkQueueBloc, WorkQueueState>(builder: (context, state) {
              print("state change ${state.workQueueStatus}");
              return Container(
                  height: size.height * 0.6,
                  width: size.width * 0.54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: const Color(0xFFF2F2F2),
                  ),
                  child: LayoutBuilder(builder: (context, parent) {
                    return Column(
                      children: [
                        Gap(parent.maxHeight * 0.024),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Gap(parent.maxWidth * 0.33),
                            SizedBox(
                              width: parent.maxWidth * 0.33,
                              child: Text(
                                "Containers Work Queue",
                                style: TextStyle(fontSize: size.height * 0.032, color: Colors.black, decoration: TextDecoration.none, letterSpacing: 0.4),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: parent.maxWidth * 0.33,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 8),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: size.height * 0.032,
                                  )),
                            )
                          ],
                        ),
                        Gap(parent.maxHeight * 0.048),
                        Skeletonizer(
                          enabled: state.workQueueStatus == WorkQueueStatus.loading,
                          child: Align(
                            alignment: Alignment.center,
                            child: Wrap(
                                spacing: parent.maxWidth * 0.02,
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                runSpacing: parent.maxWidth * 0.02,
                                children: [
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 120, 154, 95),
                                      contentValue: state.workQueueData != null ? state.workQueueData!.ordersAwaitingReceiving.toString() : " null value",
                                      imagePath: "assets/images/orders_awaiting_receiving.png",
                                      heading: "Orders Awaiting Receiving"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 236, 178, 102),
                                      contentValue: state.workQueueData!.ordersAwaitingFulfilment.toString(),
                                      imagePath: "assets/images/order_awaiting_fulfilment.png",
                                      heading: "Orders Awaiting Fulfilment"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 10, 162, 222),
                                      contentValue: state.workQueueData!.openPickingTask.toString(),
                                      imagePath: "assets/images/open_picking_tasks.png",
                                      heading: "Open Picking Task"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 120, 154, 95),
                                      contentValue: state.workQueueData!.pendingAsn.toString(),
                                      imagePath: "assets/images/asn_awaiting_receipt.png",
                                      heading: "ASNs Awaiting Receipt"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 236, 178, 102),
                                      contentValue: state.workQueueData!.loadingQueue.toString(),
                                      imagePath: "assets/images/loading_queue.png",
                                      heading: "Loading Queue"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 10, 162, 222),
                                      contentValue: state.workQueueData!.pendingCycleCounts.toString(),
                                      imagePath: "assets/images/cycle_count.png",
                                      heading: "Pending Cycle Counts"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 120, 154, 95),
                                      contentValue: state.workQueueData!.pendingPutaways.toString(),
                                      imagePath: "assets/images/pending_putaway.png",
                                      heading: "Pending Putaways"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 236, 178, 102),
                                      contentValue: state.workQueueData!.ordersToBeShipped.toString(),
                                      imagePath: "assets/images/orders_to_be_shipped.png",
                                      heading: "Orders To Be Shipped"),
                                  PendingDialogChildContianer(
                                      parent: parent,
                                      iconBgColor: Color.fromARGB(255, 10, 162, 222),
                                      contentValue: state.workQueueData!.openWorkOrders.toString(),
                                      imagePath: "assets/images/open_work_orders.png",
                                      heading: "Open Work Orders"),
                                ]),
                          ),
                        ),
                        Gap(parent.maxHeight * 0.032),
                        Padding(
                          padding: EdgeInsets.only(right: parent.maxHeight * 0.04),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                onPressed: () {
                                  UrlNavigator().launchOrFocusUrl('https://tg1.wms.ocs.oraclecloud.com/emg_test/index/');
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                    minimumSize: WidgetStatePropertyAll(Size(parent.maxWidth * 0.064, parent.maxHeight * 0.088)), // Set the desired size

                                    foregroundColor: WidgetStateColor.resolveWith((state) {
                                      if (state.contains(WidgetState.hovered)) {
                                        return Colors.black;
                                      }
                                      return Colors.white;
                                    }),
                                    backgroundColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                                      if (states.contains(WidgetState.hovered)) {
                                        return Colors.white;
                                      }
                                      return Color.fromRGBO(68, 98, 136, 1);
                                    })),
                                child: Text(
                                  "Take Action",
                                  style: TextStyle(),
                                )),
                          ),
                        )
                      ],
                    );
                  }));
            }),
          );
        });
      },
    );
  }

  static Widget PendingDialogChildContianer(
      {required BoxConstraints parent, String? imagePath, Color? iconBgColor, String? contentValue, required String heading}) {
    return Container(
      alignment: Alignment.center,
      height: parent.maxHeight * 0.21,
      width: parent.maxWidth * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.blue.shade900, spreadRadius: 2, blurRadius: 2, blurStyle: BlurStyle.outer)],
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Flex(
            direction: Axis.horizontal,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.3,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(constraints.maxHeight * 0.08),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconBgColor,
                  ),
                  height: constraints.maxHeight * 0.5,
                  child: Image.asset(
                    color: Colors.white,
                    imagePath ?? "assets/images/status.png",
                    // fit: BoxFit.cover,
                    height: constraints.maxHeight * 0.3,
                  ),
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.7,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      heading,
                      style:
                          TextStyle(decoration: TextDecoration.none, fontSize: constraints.maxWidth * 0.054, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      contentValue ?? "NA",
                      style: TextStyle(decoration: TextDecoration.none, fontSize: constraints.maxWidth * 0.1, color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static void AddContainerDialog({required BuildContext context, required String lotNo, required String area}) {
    Size size = MediaQuery.of(context).size;
    final ContainerInteractionBloc containerInteractionBloc = context.read<ContainerInteractionBloc>();
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black45,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.bounceInOut.transform(animation.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        FocusNode containerNbrFocusNode = FocusNode();
        TextEditingController containerNbrTextEditingController = TextEditingController();
        return BlocBuilder<ContainerInteractionBloc, ContainerInteractionState>(builder: (context, state) {
          return PointerInterceptor(
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35),
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: size.height * 0.015, left: size.height * 0.015, right: size.height * 0.015, bottom: size.height * 0.01),
                        margin: EdgeInsets.symmetric(horizontal: size.width * 0.003, vertical: size.height * 0.04),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Container Nbr",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: TextFormField(
                                                controller: containerNbrTextEditingController,
                                                focusNode: containerNbrFocusNode,
                                                autofocus: true,
                                                inputFormatters: [UpperCaseTextFormatter()],
                                                decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.only(left: size.width * 0.005),
                                                    focusedBorder: const OutlineInputBorder(),
                                                    enabledBorder: const OutlineInputBorder()))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(size.height * 0.01),
                            TextButton(
                                onPressed: () {
                                  String? message = containerNbrValidator(containerNbrTextEditingController.text);
                                  if (message != null) {
                                    CMSFlushbar(size, context, message: message);
                                  } else {
                                    containerInteractionBloc.add(AddContainer(area: area, containerNbr: containerNbrTextEditingController.text, lotNo: lotNo));
                                    Navigator.pop(context);
                                  }
                                },
                                child: PointerInterceptor(child: const Text("add"))),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.005, right: size.width * 0.002),
                          child: PointerInterceptor(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: size.height * 0.03,
                                width: size.height * 0.03,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  weight: 1,
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
          );
        });
      },
    );
  }

  static void DeleteContainerDialog({required BuildContext context, required String containerNbr, required String area}) {
    Size size = MediaQuery.of(context).size;
    final ContainerInteractionBloc containerInteractionBloc = context.read<ContainerInteractionBloc>();
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black45,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.bounceInOut.transform(animation.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocBuilder<ContainerInteractionBloc, ContainerInteractionState>(builder: (context, state) {
          return PointerInterceptor(
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35),
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: size.height * 0.25,
                  width: size.width * 0.2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: size.height * 0.015, left: size.height * 0.015, right: size.height * 0.015, bottom: size.height * 0.01),
                        margin: EdgeInsets.symmetric(horizontal: size.width * 0.003, vertical: size.height * 0.04),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Text(
                                "Are you sure you want to delete the container with Container Nbr $containerNbr ?",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Gap(size.height * 0.01),
                            TextButton(
                                onPressed: () {
                                  // containerInteractionBloc.add(DeleteContainer(area: area, containerNbr: containerNbr));
                                  state.webViewController!.evaluateJavascript(source: 'deleteContainer("$containerNbr");');
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(backgroundColor: const Color.fromRGBO(121, 65, 177, 1), foregroundColor: Colors.white),
                                child: PointerInterceptor(child: const Text("yes"))),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.005, right: size.width * 0.002),
                          child: PointerInterceptor(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: size.height * 0.03,
                                width: size.height * 0.03,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  weight: 1,
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
          );
        });
      },
    );
  }

  static void RelocateContainerDialog({required BuildContext context, required String containerNbr, required String area, required String lotNo}) {
    Size size = MediaQuery.of(context).size;
    final ContainerInteractionBloc containerInteractionBloc = context.read<ContainerInteractionBloc>();
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black45,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.bounceInOut.transform(animation.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        FocusNode lotNoFocusNode = FocusNode();
        TextEditingController lotNoTextEditingController = TextEditingController();
        SuggestionsController suggestionsController = SuggestionsController();
        return BlocBuilder<ContainerInteractionBloc, ContainerInteractionState>(builder: (context, state) {
          return PointerInterceptor(
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35),
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: size.height * 0.24,
                  width: size.width * 0.2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: size.height * 0.015, left: size.height * 0.015, right: size.height * 0.015, bottom: size.height * 0.01),
                        margin: EdgeInsets.symmetric(horizontal: size.width * 0.003, vertical: size.height * 0.04),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            "Container Nbr",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Gap(size.height * 0.01),
                                        const Expanded(
                                          child: Text(
                                            "To Lot No",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            containerNbr,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Gap(size.height * 0.01),
                                        Expanded(
                                          child: TypeAheadField(
                                            focusNode: lotNoFocusNode,
                                            controller: lotNoTextEditingController,
                                            suggestionsController: suggestionsController,
                                            builder: (context, controller, focusNode) {
                                              return SizedBox(
                                                height: size.height * 0.04,
                                                child: TextFormField(
                                                    controller: controller,
                                                    focusNode: focusNode,
                                                    autofocus: true,
                                                    onChanged: (value) {},
                                                    decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.only(left: size.width * 0.005),
                                                        focusedBorder: const OutlineInputBorder(),
                                                        enabledBorder: const OutlineInputBorder())),
                                              );
                                            },
                                            itemBuilder: (context, value) {
                                              return ListTile(
                                                title: Text(
                                                  value.toString(),
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                              );
                                            },
                                            suggestionsCallback: (pattern) {
                                              return state.lotsData!['${area.toLowerCase()}_area'].keys
                                                  .where(
                                                      (e) => e.contains(pattern) && state.lotsData!['${area.toLowerCase()}_area'][e].length < 3 && e != lotNo)
                                                  .toList()
                                                ..sort((a, b) {
                                                  // Extract numbers from lot names
                                                  int numA = int.tryParse(RegExp(r'\d+').firstMatch(a)?.group(0) ?? '0') ?? 0;
                                                  int numB = int.tryParse(RegExp(r'\d+').firstMatch(b)?.group(0) ?? '0') ?? 0;
                                                  return numA.compareTo(numB);
                                                });
                                            },
                                            onSelected: (value) {
                                              lotNoTextEditingController.text = value;
                                              lotNoFocusNode.unfocus();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Gap(size.height * 0.01),
                            TextButton(
                                onPressed: () {
                                  containerInteractionBloc
                                      .add(RelocateContainer(area: area, containerNbr: containerNbr, lotNo: lotNoTextEditingController.text));
                                  state.webViewController!
                                      .evaluateJavascript(source: 'relocateContainer("${lotNoTextEditingController.text}","$containerNbr","$area");');
                                  Navigator.pop(context);
                                },
                                child: PointerInterceptor(child: const Text("relocate"))),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.005, right: size.width * 0.002),
                          child: PointerInterceptor(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: size.height * 0.03,
                                width: size.height * 0.03,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  weight: 1,
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
          );
        });
      },
    );
  }

  // This function displays a custom flushbar message on the screen
  static Future CMSFlushbar(Size size, BuildContext context, {String message = 'message', Widget? icon}) async {
    // Show the flushbar using Flushbar package
    await Flushbar(
      backgroundColor: Colors.black,
      blockBackgroundInteraction: true,
      messageColor: Colors.white,
      message: message,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.015, horizontal: size.width * 0.005),
      messageSize: 16,
      flushbarPosition: FlushbarPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      borderRadius: BorderRadius.circular(8),
      icon: icon,
      boxShadows: [BoxShadow(blurRadius: 12, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.blue.shade900, offset: const Offset(0, 0))],
    ).show(context);
  }
}

String? containerNbrValidator(String value) {
  RegExp regex = RegExp(r'^[A-Za-z]{4}\d{7}$');
  if (!regex.hasMatch(value)) {
    return "container number should contain first four alphabets followed by seven digits";
  }
  return null;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  /// Converts all input text to uppercase.
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class DialogTopClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double x1 = 0;
    double y1 = 0;
    double x = size.width;
    double y = size.height;

    Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x1, y / 1.4);
    path.lineTo(x, y / 1.4);
    path.lineTo(x, y1);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

extension StringExtensions on String {
  String toInitCapCase() {
    return this
        .split(' ') // Split the string into words
        .map(
            (word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '') // Capitalize the first letter and lowercase the rest
        .join(' '); // Join the words back with spaces
  }
}
