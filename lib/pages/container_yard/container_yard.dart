import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';
import 'package:warehouse_3d/bloc/area/area_bloc.dart';
import 'package:warehouse_3d/bloc/work_queue/work_queue_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/customs/searchbar_dropdown.dart';
import 'package:warehouse_3d/pages/data_sheets/area_data_sheet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ContainerYard3DView extends StatefulWidget {
  const ContainerYard3DView({super.key});

  @override
  State<ContainerYard3DView> createState() => _ContainerYard3DViewState();
}

class _ContainerYard3DViewState extends State<ContainerYard3DView> with TickerProviderStateMixin {
  late InAppWebViewController webViewController;
  late final ContainerInteractionBloc _containerInteractionBloc;

  late AnimationController animationController;
  late Animation<double> widthAnimation;
  late Animation<double> positionAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _containerInteractionBloc = context.read<ContainerInteractionBloc>();

    _containerInteractionBloc.add(Intercepting(intercepting: false));
    animationController = AnimationController(duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 100), vsync: this);
    widthAnimation =
        Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));
    positionAnimation =
        Tween<double>(begin: -350, end: 0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeIn, reverseCurve: Curves.easeIn.flipped));
    listenStateChanges();
  }

  void listenStateChanges() {
    _containerInteractionBloc.stream.listen((state) {
      if (!state.dataFromJS!.keys.contains('object') && state.dataFromJS!.keys.first != 'percentComplete') {
        animationController.forward(); // Start animation when data sheet is visible
      } else {
        animationController.reverse(); // Reverse when not visible
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => false,
      canPop: false,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                          height: size.height * 0.08,
                          width: size.width * 0.12,
                          color: Color.fromRGBO(121, 65, 177, 1),
                          alignment: Alignment.centerLeft,
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Padding(
                              padding: EdgeInsets.only(left: constraints.maxWidth * 0.1),
                              child:
                                  Text('NALSOFT', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600, fontFamily: 'Ethnocentric')),
                            );
                          })),
                      Expanded(
                        child: Container(
                          height: size.height * 0.08,
                          color: Color.fromRGBO(195, 169, 219, 1),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: BlocConsumer<ContainerInteractionBloc, ContainerInteractionState>(
                          // listenWhen: (previous, current) => previous.getLotsDataStatus != current.getLotsDataStatus || previous.webLoaded != current.webLoaded,
                          listener: (context, state) {
                            if (state.getLotsDataStatus == LotsDataStatus.success && state.webLoaded!) {
                              state.webViewController!.evaluateJavascript(source: "storeLotsData('${jsonEncode(_containerInteractionBloc.state.lotsData)}');");
                              state.webViewController!.evaluateJavascript(source: "setCustomer('Sravan');");
                            }

                            if (state.webLoaded! &&
                                context.read<WorkQueueBloc>().state.workQueueShownInitially != null &&
                                !context.read<WorkQueueBloc>().state.workQueueShownInitially!) {
                              // context.read<WorkQueueBloc>().add(const GetWorkQueueData());
                              // Customs.PendigDialog(context: context);
                              // context.read<WorkQueueBloc>().state.workQueueShownInitially = true;
                            }
                          },
                          buildWhen: (previous, current) => previous.sentDataToJS != current.sentDataToJS,
                          builder: (context, state) {
                            return AnimatedBuilder(
                                animation: widthAnimation,
                                builder: (context, child) {
                                  return SizedBox(
                                    height: size.height * 0.92,
                                    width: size.width * widthAnimation.value,
                                    child: InAppWebView(
                                      initialFile: 'assets/web_pro/index.html',
                                      onWebViewCreated: (controller) async {
                                        _containerInteractionBloc.state.webViewController = controller;
                                      },
                                      onConsoleMessage: (controller, consoleMessage) {
                                        if (consoleMessage.messageLevel.toNativeValue() == 1 && consoleMessage.message.contains('{"')) {
                                          Map<String, dynamic> message = jsonDecode(consoleMessage.message);
                                          jsToFlutter(message);
                                        }
                                      },
                                      onLoadStop: (controller, url) async {
                                        _containerInteractionBloc.add(WebLoaded(loaded: true));
                                        _containerInteractionBloc.state.webViewController!.evaluateJavascript(source: 'storeLotsDataFromLocal();');
                                        await controller.webStorage.localStorage.getItem(key: 'area_lots_data').then(
                                          (value) {
                                            _containerInteractionBloc.state.lotsData = value;
                                            print(_containerInteractionBloc.state.lotsData);
                                          },
                                        );
                                      },
                                    ),
                                  );
                                });
                            // : const Center(
                            //     child: CircularProgressIndicator(),
                            //   );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BlocBuilder<ContainerInteractionBloc, ContainerInteractionState>(builder: (context, state) {
                          return PointerInterceptor(
                            intercepting: state.intercepting!,
                            child: Container(
                              height: size.height * 0.92,
                              width: size.width,
                              color: Colors.transparent,
                            ),
                          );
                        }),
                      ),
                      AnimatedBuilder(
                          animation: positionAnimation,
                          builder: (context, child) {
                            return Positioned(
                              right: positionAnimation.value,
                              child: PointerInterceptor(
                                child: getDataSheetFor(context.watch<ContainerInteractionBloc>().state.dataFromJS!.keys.first,
                                        context.watch<ContainerInteractionBloc>().state.dataFromJS!.values.first.toString()) ??
                                    const SizedBox(),
                              ),
                            );
                          }),
                      if (context.watch<ContainerInteractionBloc>().state.modelLoaded! == false)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: size.height * 0.92,
                            width: size.width,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(color: Color.fromRGBO(242, 228, 255, 1)),
                            child: SpinKitCubeGrid(
                              color: Color.fromRGBO(121, 65, 177, 1),
                              size: size.height * 0.15,
                            ),
                          ),
                        ),
                      if (context.watch<ContainerInteractionBloc>().state.modelLoaded == true)
                        Positioned(
                            left: 0,
                            bottom: 16,
                            child: PointerInterceptor(
                                child: Container(
                              height: size.height * 0.064,
                              width: size.width * 0.03,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                                  color: Color.fromRGBO(121, 65, 177, 1)),
                              child: IconButton(
                                  onPressed: () {
                                    context.read<WorkQueueBloc>().add(const GetWorkQueueData());
                                    Customs.PendigDialog(context: context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_right_alt_rounded,
                                    color: Colors.white,
                                  )),
                            )))
                    ],
                  ),
                ],
              ),
              Positioned(left: size.width * 0.15, top: size.height * 0.013, child: PointerInterceptor(child: SearchBarDropdown(size: size))),
            ],
          )),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    _containerInteractionBloc.close();
    super.dispose();
  }

  void jsToFlutter(Map<String, dynamic> data) {
    print(data);
    switch (data.keys.first) {
      case 'lotNo':
        Customs.AddContainerDialog(context: context, lotNo: data.values.first, area: data.values.last);
        break;
      case 'containerNbr':
        Customs.RelocateContainerDialog(context: context, containerNbr: data.values.first, area: data['area'], lotNo: data.values.last);
        break;
      case 'deleteContainer':
        Customs.DeleteContainerDialog(context: context, containerNbr: data.values.first, area: data.values.last);
        break;
      case 'loaded':
        _containerInteractionBloc.add(ModelLoaded(loaded: true));
        break;
      case 'object':
      case 'area':
        _containerInteractionBloc.add(DataFromJS(dataFromJS: data));
        break;
      case 'getLotsData':
        _containerInteractionBloc.add(GetLotsData());
        break;
      default:
        null;
    }
  }

  Widget? getDataSheetFor(
    String objectName,
    String objectValue,
  ) {
    print("getDataSheetFor $objectName ${objectValue.toLowerCase().split('_')[0]}");
    switch (objectValue.toLowerCase().split('_')[0]) {
      case 'refrigerated':
      case 'dry':
      case 'damaged':
      case 'empty':
      case 'unassigned':
        return AreaDataSheet(area: objectValue.split('_')[0], key: ValueKey(objectValue.split('_')[0]));
      default:
        return null;
    }
  }
}
