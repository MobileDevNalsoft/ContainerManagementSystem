import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:three_js/three_js.dart';
import 'package:warehouse_3d/bloc/container_interaction_bloc.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: BlocConsumer<ContainerInteractionBloc, ContainerInteractionState>(
            listenWhen: (previous, current) => previous.getLotsDataStatus != current.getLotsDataStatus || previous.webLoaded != current.webLoaded,
            listener: (context, state) {
              if (state.getLotsDataStatus == LotsDataStatus.success) {
                state.webViewController!.evaluateJavascript(source: "storeLotsData('${jsonEncode(_containerInteractionBloc.state.lotsData)}');");
              }
            },
            builder: (context, state) {
              return InAppWebView(
                initialFile: 'assets/web_pro/index.html',
                onWebViewCreated: (controller) async {
                  _containerInteractionBloc.state.webViewController = controller;
                  _containerInteractionBloc.add(GetLotsData());
                },
                onConsoleMessage: (controller, consoleMessage) {
                  if (consoleMessage.messageLevel.toNativeValue() == 1 && consoleMessage.message.contains('{"')) {
                    Map<String, dynamic> message = jsonDecode(consoleMessage.message);
                    jsToFlutter(message);
                  }
                },
                onLoadStart: (controller, url) {
                  state.webViewController!.evaluateJavascript(source: "storeLotsData('${jsonEncode(_containerInteractionBloc.state.lotsData)}');");
                },
              );
            },
          ),
        ),
        if (context.watch<ContainerInteractionBloc>().state.getAddContainerStatus == AddContainerStatus.loading ||
            context.watch<ContainerInteractionBloc>().state.getLotsDataStatus == LotsDataStatus.loading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    ));
  }

  void jsToFlutter(Map<String, dynamic> data) {
    print(data);
    if (data.keys.first == 'lotNo') {
      Customs.AddContainerDialog(context: context, lotNo: data.values.first, area: data.values.last);
    } else if (data.keys.first == 'containerNbr') {
      Customs.RelocateContainerDialog(context: context, containerNbr: data.values.first, area: data.values.last);
    } else if (data.keys.first == 'deleteContainer') {
      Customs.DeleteContainerDialog(context: context, containerNbr: data.values.first, area: data.values.last);
    }
  }
}
