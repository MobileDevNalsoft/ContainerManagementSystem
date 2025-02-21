import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class ContainerYard3DView extends StatefulWidget {
  const ContainerYard3DView({super.key});

  @override
  State<ContainerYard3DView> createState() => _ContainerYard3DViewState();
}

class _ContainerYard3DViewState extends State<ContainerYard3DView> with TickerProviderStateMixin {
  late InAppWebViewController webViewController;
  late final ContainerInteractionBloc _containerInteractionBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _containerInteractionBloc = context.read<ContainerInteractionBloc>();
    _containerInteractionBloc.add(GetLotsData());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: BlocConsumer<ContainerInteractionBloc, ContainerInteractionState>(
            listenWhen: (previous, current) => previous.getLotsDataStatus != current.getLotsDataStatus || previous.webLoaded != current.webLoaded,
            listener: (context, state) {
              if (state.getLotsDataStatus == LotsDataStatus.success && state.webLoaded!) {
                state.webViewController!.evaluateJavascript(source: "storeLotsData('${jsonEncode(_containerInteractionBloc.state.lotsData)}');");
                state.webViewController!.evaluateJavascript(source: "setCustomer('Sravan');");
              }
            },
            buildWhen: (previous, current) => previous.sentDataToJS != current.sentDataToJS,
            builder: (context, state) {
              return state.sentDataToJS!
                  ? InAppWebView(
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
                      onLoadStop: (controller, url) {
                        _containerInteractionBloc.add(WebLoaded(loaded: true));
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ),
        if (context.watch<ContainerInteractionBloc>().state.modelLoaded! == false)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Color.fromRGBO(192, 208, 230, 1)),
              child: Lottie.asset('assets/lottie/rendering.json'),
            ),
          ),
      ],
    ));
  }

  void jsToFlutter(Map<String, dynamic> data) {
    print(data);
    if (data.keys.first == 'lotNo') {
      Customs.AddContainerDialog(context: context, lotNo: data.values.first, area: data.values.last);
    } else if (data.keys.first == 'containerNbr') {
      Customs.RelocateContainerDialog(context: context, containerNbr: data.values.first, area: data['area'], lotNo: data.values.last);
    } else if (data.keys.first == 'deleteContainer') {
      Customs.DeleteContainerDialog(context: context, containerNbr: data.values.first, area: data.values.last);
    } else if (data.keys.first == 'loaded') {
      _containerInteractionBloc.add(ModelLoaded(loaded: true));
    }
  }
}
