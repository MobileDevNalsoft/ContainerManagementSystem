import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';
import 'package:warehouse_3d/bloc/area/area_bloc.dart';
import 'package:warehouse_3d/models/area_model.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class AreaDataSheet extends StatefulWidget {
  AreaDataSheet({required this.area, Key? key}) : super(key: key);
  String area;

  @override
  State<AreaDataSheet> createState() => _AreaDataSheetState();
}

class _AreaDataSheetState extends State<AreaDataSheet> {
  PageController pageController = PageController(initialPage: 0);

  late ContainerInteractionBloc _containerInteractionBloc;
  late AreaBloc _areaBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _containerInteractionBloc = context.read<ContainerInteractionBloc>();
    _areaBloc = context.read<AreaBloc>();
    _areaBloc.state.getAreaStatus = AreaStatus.initial;
    _areaBloc.add(GetAreaData(area: widget.area));
    _containerInteractionBloc.add(SelectedArea(selectedArea: AreaName.values.firstWhere((e) => e.name == initcapcase(widget.area))));
    _areaBloc.state.selectedCustomerIndex = 0;
    // you will get the searched container area data
    // find the customer index from customers in area data then animate page with selected customer then container index using the customer data
    // then animate scroll to that container index.
  }

  Future<void> navigateToItem(String value, Size size) async {
    String customer = _containerInteractionBloc.state.searchedContainer!.customerName!;
    int custIndex = _areaBloc.state.customers!.indexWhere((element) => element.customerName == customer);
    _areaBloc.state.selectedCustomerIndex = 2;
    if (pageController.hasClients) {
      await pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
    int containerIndex = _areaBloc.state.customers![custIndex].containers!.indexWhere((element) => element.containerNbr == value);
    if (containerIndex != -1 && _scrollController.hasClients) {
      double scrollOffset = containerIndex * size.height * 0.13; // Assuming each item has a height of 50.0
      _scrollController.animateTo(
        scrollOffset,
        duration: Duration(seconds: 1),
        curve: Curves.linear,
      );
      _containerInteractionBloc.state.getSearchStatus = SearchStatus.initial;
    } else {
      print('Item not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Customs.DataSheet(
        context: context,
        size: size,
        title: '${widget.area} AREA',
        onExit: () {
          if (pageController.page == 1) {
            pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.linear);
          } else {
            _containerInteractionBloc.add(DataFromJS(dataFromJS: const {"object": "null"}));
            _containerInteractionBloc.state.webViewController!.evaluateJavascript(source: 'switchCamera("YARD")');
            _containerInteractionBloc.state.searchTextController!.clear();
            _containerInteractionBloc.state.searchedContainer = null;
            _containerInteractionBloc.add(SelectedArea(selectedArea: AreaName.Area));
          }
        },
        children: [
          BlocConsumer<AreaBloc, AreaState>(
            listener: (context, state) {
              if (_containerInteractionBloc.state.getSearchStatus == SearchStatus.success && state.getAreaStatus == AreaStatus.success) {
                navigateToItem(_containerInteractionBloc.state.searchedContainer!.containerNbr!, size);
              }
            },
            builder: (context, state) {
              bool isEnabled = state.getAreaStatus != AreaStatus.success;
              return Expanded(
                child: isEnabled
                    ? const Center(child: CircularProgressIndicator())
                    : LayoutBuilder(builder: (context, lsize) {
                        return PageView(
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ListView.builder(
                                  itemCount: state.customers!.length,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: size.height * 0.016,
                                              left: size.height * 0.01,
                                              right: size.height * 0.01,
                                              top: index == 0 ? size.height * 0.01 : 0),
                                          child: InkWell(
                                            onTap: () {
                                              _areaBloc.add(SelectedCustomer(index: index));
                                              pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.linear);
                                            },
                                            onHover: (value) {
                                              _areaBloc.add(AreaTileHovered(index: value ? index : null));
                                            },
                                            child: Container(
                                              height: lsize.maxHeight * 0.12,
                                              width: double.infinity,
                                              padding: EdgeInsets.only(right: lsize.maxWidth * 0.025),
                                              decoration: BoxDecoration(
                                                color: state.areaTileHoveredIndex == index ? Color.fromRGBO(107, 54, 160, 1) : Color.fromRGBO(142, 84, 199, 1),
                                                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: 0.5)],
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              alignment: Alignment.centerRight,
                                              child: const Icon(
                                                Icons.keyboard_arrow_right_rounded,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: lsize.maxHeight * 0.12,
                                          width: lsize.maxWidth * 0.9,
                                          padding: const EdgeInsets.all(5),
                                          margin: EdgeInsets.only(
                                              bottom: size.height * 0.016,
                                              left: size.height * 0.01,
                                              right: lsize.maxWidth * 0.12,
                                              top: index == 0 ? size.height * 0.01 : 0),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(121, 65, 177, 1),
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: Color.fromRGBO(142, 84, 199, 1), width: 2)),
                                          child: LayoutBuilder(builder: (context, lsize) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Gap(lsize.maxHeight * 0.08),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/businessman.png',
                                                      scale: lsize.maxHeight * 0.045,
                                                      color: Colors.white,
                                                    ),
                                                    Gap(lsize.maxWidth * 0.01),
                                                    Text(
                                                      state.customers![index].customerName!,
                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: lsize.maxWidth * 0.09, top: lsize.maxHeight * 0.1),
                                                  child: Text(
                                                    '${state.customers![index].containers!.length.toString()} containers',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: const Color.fromARGB(255, 193, 193, 193), fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  IntrinsicWidth(
                                    child: Container(
                                      height: size.height * 0.05,
                                      padding: EdgeInsets.symmetric(horizontal: lsize.maxWidth * 0.03),
                                      margin: EdgeInsets.only(bottom: lsize.maxHeight * 0.03),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(164, 111, 218, 1),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(width: 3, color: Color.fromRGBO(111, 54, 167, 1)),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/businessman.png',
                                            scale: lsize.maxHeight * 0.004,
                                            color: Color.fromRGBO(111, 54, 167, 1),
                                          ),
                                          Gap(lsize.maxWidth * 0.05),
                                          Expanded(
                                            child: Transform.translate(
                                              offset: Offset(-size.width * 0.0065, 0),
                                              child: Text(
                                                state.customers![state.selectedCustomerIndex!].customerName!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(111, 54, 167, 1), fontSize: 16, letterSpacing: 1.6, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: ListView.builder(
                                          controller: _scrollController,
                                          itemCount: state.customers![state.selectedCustomerIndex!].containers!.length,
                                          itemBuilder: (context, index) {
                                            state.customers![state.selectedCustomerIndex!].containers!.sort(
                                              (a, b) =>
                                                  int.parse(RegExp(r'\d+').stringMatch(a.lotNo!)!).compareTo(int.parse(RegExp(r'\d+').stringMatch(b.lotNo!)!)),
                                            );
                                            ContainerData container = state.customers![state.selectedCustomerIndex!].containers![index];
                                            return Container(
                                              height: lsize.maxHeight * 0.14,
                                              width: lsize.maxWidth * 0.985,
                                              padding: EdgeInsets.all(lsize.maxWidth * 0.02),
                                              margin: EdgeInsets.only(bottom: size.height * 0.018),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(121, 65, 177, 1),
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(width: 4, color: Color.fromRGBO(142, 84, 199, 1))),
                                              child: LayoutBuilder(builder: (context, lsize) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Gap(lsize.maxHeight * 0.08),
                                                    Row(
                                                      children: [
                                                        Gap(lsize.maxWidth * 0.03),
                                                        Image.asset(
                                                          'assets/images/container.png',
                                                          scale: lsize.maxHeight * 0.022,
                                                        ),
                                                        Gap(lsize.maxWidth * 0.03),
                                                        Text(
                                                          container.containerNbr!,
                                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                                        ),
                                                        Gap(lsize.maxWidth * 0.03),
                                                      ],
                                                    ),
                                                    Gap(lsize.maxWidth * 0.01),
                                                    Row(
                                                      children: [
                                                        Gap(lsize.maxWidth * 0.16),
                                                        Text(
                                                          'lot ${RegExp(r'\d+').stringMatch(container.lotNo!).toString()}',
                                                          style: TextStyle(
                                                              color: const Color.fromARGB(255, 193, 193, 193), fontWeight: FontWeight.bold, fontSize: 14),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          container.arrivalTime!.split(' ')[1].split('.')[0].substring(0, 5),
                                                          style: TextStyle(color: Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }),
                                            );
                                            return Container(
                                              height: lsize.maxHeight * 0.13,
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(5),
                                              margin: const EdgeInsets.only(bottom: 5),
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(209, 230, 255, 1),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: LayoutBuilder(builder: (context, lsize) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: lsize.maxHeight * 0.5,
                                                          decoration: BoxDecoration(
                                                              color: const Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(15)),
                                                          child: Row(
                                                            children: [
                                                              Gap(lsize.maxWidth * 0.03),
                                                              Image.asset(
                                                                'assets/images/container.png',
                                                                scale: lsize.maxHeight * 0.022,
                                                              ),
                                                              Gap(lsize.maxWidth * 0.03),
                                                              Text(
                                                                container.containerNbr!,
                                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                                              ),
                                                              Gap(lsize.maxWidth * 0.03),
                                                            ],
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Container(
                                                          height: lsize.maxHeight * 0.4,
                                                          width: lsize.maxHeight * 0.4,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(color: const Color.fromRGBO(12, 46, 87, 1), shape: BoxShape.circle),
                                                          child: Text(
                                                            'L${RegExp(r'\d+').stringMatch(container.lotNo!).toString()}',
                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Gap(lsize.maxHeight * 0.15),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/date.png',
                                                              scale: lsize.maxHeight * 0.027,
                                                            ),
                                                            Gap(lsize.maxHeight * 0.02),
                                                            Text(container.arrivalTime!.split(' ')[0])
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: lsize.maxWidth * 0.25,
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/time.png',
                                                                scale: lsize.maxHeight * 0.025,
                                                              ),
                                                              Gap(lsize.maxHeight * 0.02),
                                                              Text(container.arrivalTime!.split(' ')[1].split('.')[0])
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                );
                                              }),
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }),
              );
            },
          ),
        ]);
  }
}
