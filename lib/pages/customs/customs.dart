// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // Import the HTML library

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

class Customs {
  static Widget DataSheet({required Size size, required String title, required List<Widget> children, controller, required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(12, 46, 87, 1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)]),
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.height * 0.02),
          margin: EdgeInsets.only(top: size.height * 0.02, bottom: size.height * 0.004, right: size.height * 0.01),
          height: size.height * 0.06,
          width: size.width * 0.22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: size.width * 0.012, letterSpacing: 1.6, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              InkWell(onTap: () async {}, child: const Icon(Icons.cancel_rounded, color: Colors.white))
            ],
          ),
        ),
        Container(
          height: size.height * 0.86,
          width: size.width * 0.22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color.fromRGBO(12, 46, 87, 1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 10)]),
          padding: EdgeInsets.all(size.height * 0.012),
          child: LayoutBuilder(builder: (context, layout) {
            return Column(
              children: [Gap(size.height * 0.01), ...children],
            );
          }),
        ),
      ],
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
                                    state.webViewController!.evaluateJavascript(source: 'addContainer("${containerNbrTextEditingController.text}","$area");');
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
                                          child: Text(
                                            containerNbr,
                                            style: TextStyle(fontWeight: FontWeight.bold),
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
                                  containerInteractionBloc.add(DeleteContainer(area: area, containerNbr: containerNbr));
                                  state.webViewController!.evaluateJavascript(source: 'deleteContainer();');
                                  Navigator.pop(context);
                                },
                                child: PointerInterceptor(child: const Text("delete"))),
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
                                        Expanded(
                                          child: Text(
                                            "Container Nbr",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Gap(size.height * 0.01),
                                        Expanded(
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
                                            style: TextStyle(fontWeight: FontWeight.bold),
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
                                                        focusedBorder: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder())),
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
                                                      (e) => e.contains(pattern) && state.lotsData!['${area.toLowerCase()}_area'][e].length < 5 && e != lotNo)
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
                                  containerInteractionBloc.add(AddContainer(area: area, containerNbr: containerNbr, lotNo: lotNoTextEditingController.text));
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
