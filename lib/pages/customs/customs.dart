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
import 'package:warehouse_3d/bloc/area/area_bloc.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';
import 'package:warehouse_3d/models/areas_model.dart';
import 'package:warehouse_3d/models/summary_model.dart';
import 'package:warehouse_3d/pages/customs/animated_toggle.dart';
import 'package:warehouse_3d/utils/url_navigator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Customs {
  static Widget DataSheet(
      {required Size size, required String title, required List<Widget> children, controller, required BuildContext context, void Function()? onExit}) {
    final ContainerInteractionBloc containerInteractionBloc = context.read<ContainerInteractionBloc>();
    return Container(
      height: size.height * 0.92,
      width: size.width * 0.22,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
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
                color: const Color.fromRGBO(121, 65, 177, 1),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 1.5, spreadRadius: 0.5)],
                border: Border.all(width: 1.5, color: const Color.fromARGB(255, 96, 46, 147)),
              ),
              child: Row(
                children: [
                  InkWell(
                      onTap: onExit,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.keyboard_arrow_left_rounded,
                          color: Colors.white,
                        ),
                      )),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(-size.width * 0.0065, 0),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: size.width * 0.012, letterSpacing: 1.6, fontWeight: FontWeight.bold),
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
      decoration: BoxDecoration(color: const Color.fromRGBO(191, 208, 228, 1), borderRadius: BorderRadius.circular(15)),
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

  static Widget CMSSfCircularChart(
      {required BoxConstraints lsize,
      String title = 'Title',
      double titleFontSize = 16,
      Props? props,
      bool legendVisibility = false,
      String? Function(PieData datum, int index)? dataLabelMapper}) {
    return SfCircularChart(
      title: ChartTitle(text: title, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize)),
      legend: Legend(
        isVisible: legendVisibility,
        alignment: ChartAlignment.center,
        position: LegendPosition.right,
        textStyle: TextStyle(fontSize: 10),
      ),
      margin: EdgeInsets.only(left: lsize.maxWidth * 0.02),
      series: <CircularSeries>[
        PieSeries<PieData, String>(
          dataSource: props!.dataSource,
          dataLabelMapper: dataLabelMapper,
          strokeColor: Colors.black,
          strokeWidth: 0.2,
          dataLabelSettings: DataLabelSettings(
              // Renders the data label
              isVisible: true,
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: props.labelFontSize, color: Colors.black),
              alignment: ChartAlignment.center),
          radius: '${lsize.maxWidth * 0.12}%',
          pointColorMapper: props.pointColorMapper,
          onPointTap: props.onPointTap,
          xValueMapper: (PieData data, _) => data.xData,
          yValueMapper: (PieData data, _) => data.yData,
        )
      ],
    );
  }

  static void SummaryDialog({required BuildContext context, Widget? content}) {
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
            child: BlocBuilder<ContainerInteractionBloc, ContainerInteractionState>(builder: (context, state) {
              bool isEnabled = state.getSummaryStatus != SummaryStatus.success;
              return Container(
                  height: size.height * 0.8,
                  width: size.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: const Color(0xFFF2F2F2),
                  ),
                  child: LayoutBuilder(builder: (context, parent) {
                    return Column(
                      children: [
                        Gap(parent.maxHeight * 0.02),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "ICD Summary",
                                style: TextStyle(fontSize: size.height * 0.032, color: Colors.black, decoration: TextDecoration.none, letterSpacing: 0.4),
                              ),
                            ),
                            Positioned(
                              right: size.width * 0.1,
                              child: AnimatedToggleButton(
                                height: size.height * 0.05,
                                width: size.width * 0.075,
                                toggleColor: const Color.fromRGBO(121, 65, 177, 1),
                                onToggle: (value) {
                                  context.read<ContainerInteractionBloc>().add(LotsToggled(toggled: value));
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: size.width * 0.006),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: size.height * 0.032,
                                    )),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Wrap(alignment: WrapAlignment.center, spacing: parent.maxWidth * 0.03, runSpacing: parent.maxWidth * 0.03, children: [
                              PendingDialogChildContianer(
                                  parent: parent,
                                  heading: "Yard",
                                  colors: [const Color.fromARGB(255, 163, 221, 210), Color.fromRGBO(87, 163, 145, 1)],
                                  lots: state.lotsToggled!,
                                  isEnabled: isEnabled,
                                  areaSummary: state.summary?.yard),
                              PendingDialogChildContianer(
                                  parent: parent,
                                  heading: "Refrigerated",
                                  colors: [const Color.fromRGBO(193, 194, 234, 41), Color.fromRGBO(129, 130, 182, 1)],
                                  lots: state.lotsToggled!,
                                  isEnabled: isEnabled,
                                  areaSummary: state.summary?.refrigerated),
                              PendingDialogChildContianer(
                                  parent: parent,
                                  heading: "Dry",
                                  colors: [const Color.fromARGB(255, 158, 212, 223), Color.fromRGBO(75, 160, 176, 1)],
                                  lots: state.lotsToggled!,
                                  isEnabled: isEnabled,
                                  areaSummary: state.summary?.dry),
                              PendingDialogChildContianer(
                                  parent: parent,
                                  heading: "Empty",
                                  colors: [const Color.fromARGB(255, 161, 215, 244), Color.fromRGBO(76, 144, 181, 1)],
                                  lots: state.lotsToggled!,
                                  isEnabled: isEnabled,
                                  areaSummary: state.summary?.empty),
                              PendingDialogChildContianer(
                                  parent: parent,
                                  heading: "Damaged",
                                  colors: [const Color.fromRGBO(220, 163, 214, 41), Color.fromRGBO(184, 116, 176, 1)],
                                  lots: state.lotsToggled!,
                                  isEnabled: isEnabled,
                                  areaSummary: state.summary?.damaged),
                            ]),
                          ),
                        ),
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
      {required BoxConstraints parent,
      required String heading,
      required List<Color> colors,
      bool lots = true,
      bool isEnabled = true,
      AreaSummary? areaSummary}) {
    return Container(
      alignment: Alignment.center,
      height: parent.maxHeight * 0.4,
      width: parent.maxWidth * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Color.fromRGBO(121, 65, 177, 1), spreadRadius: 4, blurRadius: 2, blurStyle: BlurStyle.outer)],
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return isEnabled
              ? CircularProgressIndicator()
              : Stack(
                  children: [
                    CMSSfCircularChart(
                        lsize: parent,
                        title: heading,
                        titleFontSize: 13,
                        legendVisibility: true,
                        props: Props(
                          dataSource: [
                            PieData(xData: 'Available', yData: lots ? areaSummary!.availableLots! : areaSummary!.availableSlots!),
                            PieData(xData: 'Occupied', yData: lots ? areaSummary.occupiedLots! : areaSummary.occupiedSlots!),
                          ],
                          labelFontSize: 12,
                          pointColorMapper: (p0, p1) {
                            return colors[p1];
                          },
                        ),
                        dataLabelMapper: (datum, index) {
                          return '${datum.yData}(${((datum.yData / (lots ? areaSummary.totalLots! : areaSummary.totalSlots!)) * 100).round()}%)';
                        }),
                    Positioned(
                        right: constraints.maxWidth * 0.14,
                        bottom: constraints.maxHeight * 0.05,
                        child: Material(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Text(
                                  lots ? areaSummary.totalLots.toString() : areaSummary.totalSlots.toString(),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Gap(constraints.maxHeight * 0.01),
                                Text(
                                  'Total',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ))),
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

  static void DeleteContainerDialog(
      {required BuildContext context, required String containerNbr, required String area, required PageController pageController}) {
    Size size = MediaQuery.of(context).size;
    final AreaBloc areaBloc = context.read<AreaBloc>();
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
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Gap(size.height * 0.01),
                            TextButton(
                                onPressed: () {
                                  // containerInteractionBloc.add(DeleteContainer(area: area, containerNbr: containerNbr));
                                  if (areaBloc.state.customers![areaBloc.state.selectedCustomerIndex!].containers!.length == 1) {
                                    pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                    areaBloc.state.customers!.removeAt(areaBloc.state.selectedCustomerIndex!);
                                  } else {
                                    print('delete initiated');
                                    areaBloc.state.customers![areaBloc.state.selectedCustomerIndex!].containers!
                                        .removeAt(areaBloc.state.selectedContainerIndex!);
                                  }
                                  state.webViewController!.evaluateJavascript(source: 'deleteContainer("$containerNbr", "$area");');
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
                                  // containerInteractionBloc
                                  //     .add(RelocateContainer(area: area, containerNbr: containerNbr, lotNo: lotNoTextEditingController.text));
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

  static Widget DetentionIndicator({required Size size}) {
    return ClipPath(
      clipper: DetentionIndicatorClipper(),
      child: Container(
        height: size.width * 0.033,
        width: size.width * 0.033,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color.fromARGB(255, 216, 97, 97)),
      ),
    );
  }
}

class PieData {
  PieData({required this.xData, required this.yData, this.text, this.color});
  final String xData;
  final num yData;
  String? text;
  Color? color;
}

class Props {
  List<PieData>? dataSource;
  double labelFontSize;
  double? maximumValue;
  Color? Function(PieData, int)? pointColorMapper;
  void Function(ChartPointDetails pointInteractionDetails)? onPointTap;
  Props({this.dataSource, this.labelFontSize = 14, this.maximumValue, this.pointColorMapper, this.onPointTap});
}

String? containerNbrValidator(String value) {
  RegExp regex = RegExp(r'^[A-Za-z]{2}\d{8}-\d{4}$');
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

class DetentionIndicatorClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double x = size.width;
    double y = size.height;
    path.lineTo(0, y * 0.9);
    path.quadraticBezierTo(x * 0.2, y * 0.2, x * 0.9, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;
}
