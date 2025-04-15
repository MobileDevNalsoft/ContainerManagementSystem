import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';
import 'package:warehouse_3d/bloc/area/area_bloc.dart';
import 'package:warehouse_3d/models/area_model.dart';
import 'package:warehouse_3d/pages/customs/area_dropdown.dart';
import 'package:warehouse_3d/pages/customs/custom_expansion_tile.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/customs/lot_dropdown.dart';

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
    if (_areaBloc.state.getSearchContainerStatus == SearchContainerStatus.initial) {
      _areaBloc.add(GetAreaData(area: widget.area));
    }
    _containerInteractionBloc.add(SelectedArea(selectedArea: AreaName.values.firstWhere((e) => e.name == initcapcase(widget.area))));
    _areaBloc.state.selectedCustomerIndex = 0;
    _containerInteractionBloc.state.selectedDropdownArea = 'Refrigerated';
    // you will get the searched container area data
    // find the customer index from customers in area data then animate page with selected customer then container index using the customer data
    // then animate scroll to that container index.
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Customs.DataSheet(
        context: context,
        size: size,
        title: '${widget.area} AREA',
        onExit: () {
          if (pageController.hasClients && pageController.page == 1) {
            pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.linear);
          } else {
            _containerInteractionBloc.add(DataFromJS(dataFromJS: const {"object": "null"}));
            _areaBloc.state.getAreaStatus = AreaStatus.initial;
            _containerInteractionBloc.state.webViewController!.evaluateJavascript(source: 'switchCamera("YARD")');
            _containerInteractionBloc.state.searchTextController!.clear();
            _containerInteractionBloc.add(SelectedArea(selectedArea: AreaName.Area));
          }
        },
        children: [
          BlocBuilder<AreaBloc, AreaState>(
            builder: (context, state) {
              bool isEnabled = state.getAreaStatus == AreaStatus.loading || state.getSearchContainerStatus == SearchContainerStatus.loading;
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
                                              pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                            },
                                            onHover: (value) {
                                              _areaBloc.add(AreaTileHovered(index: value ? index : null));
                                            },
                                            child: Container(
                                              height: lsize.maxHeight * 0.12,
                                              width: double.infinity,
                                              padding: EdgeInsets.only(right: lsize.maxWidth * 0.025),
                                              decoration: BoxDecoration(
                                                color: state.areaTileHoveredIndex == index
                                                    ? const Color.fromRGBO(107, 54, 160, 1)
                                                    : const Color.fromRGBO(142, 84, 199, 1),
                                                boxShadow: [const BoxShadow(color: Colors.black, blurRadius: 3, spreadRadius: 0.5)],
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
                                              color: const Color.fromRGBO(121, 65, 177, 1),
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: const Color.fromRGBO(142, 84, 199, 1), width: 2)),
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
                                                    style: const TextStyle(color: Color.fromARGB(255, 193, 193, 193), fontSize: 14),
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
                                        color: const Color.fromRGBO(164, 111, 218, 1),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(width: 3, color: const Color.fromRGBO(111, 54, 167, 1)),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/businessman.png',
                                            scale: lsize.maxHeight * 0.004,
                                            color: const Color.fromRGBO(111, 54, 167, 1),
                                          ),
                                          Gap(lsize.maxWidth * 0.05),
                                          Expanded(
                                            child: Transform.translate(
                                              offset: Offset(-size.width * 0.0065, 0),
                                              child: Text(
                                                state.customers![state.selectedCustomerIndex!].customerName!,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(111, 54, 167, 1), fontSize: 16, letterSpacing: 1.6, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: CustomExpansionTile(
                                          initialHeight: lsize.maxHeight * 0.14,
                                          initialWidth: lsize.maxWidth,
                                          dropdownHeight: lsize.maxHeight * 0.05,
                                          margin: EdgeInsets.only(bottom: lsize.maxHeight * 0.018),
                                          itemCount: state.customers![state.selectedCustomerIndex!].containers!.length,
                                          childBuilder: (height, width, index) {
                                            state.customers![state.selectedCustomerIndex!].containers!.sort(
                                              (a, b) =>
                                                  int.parse(RegExp(r'\d+').stringMatch(a.lotNo!)!).compareTo(int.parse(RegExp(r'\d+').stringMatch(b.lotNo!)!)),
                                            );
                                            ContainerData container = state.customers![state.selectedCustomerIndex!].containers![index];
                                            return Container(
                                              height: height,
                                              width: width,
                                              padding: EdgeInsets.all(lsize.maxWidth * 0.02),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(121, 65, 177, 1),
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(width: 4, color: const Color.fromRGBO(142, 84, 199, 1))),
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
                                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
                                                          style: const TextStyle(
                                                              color: Color.fromARGB(255, 193, 193, 193), fontWeight: FontWeight.bold, fontSize: 14),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          container.arrivalTime!.split('T')[1].substring(0, 5),
                                                          style: const TextStyle(color: Colors.white),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }),
                                            );
                                          },
                                          dropDownBuilder: (index) {
                                            ContainerData container = state.customers![state.selectedCustomerIndex!].containers![index];
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      _containerInteractionBloc.state.webViewController!
                                                          .evaluateJavascript(source: 'goToContainer("${container.containerNbr}","${container.lotNo}");');
                                                    },
                                                    child: Container(
                                                      height: double.infinity,
                                                      padding: EdgeInsets.only(top: lsize.maxHeight * 0.031, bottom: lsize.maxHeight * 0.007),
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromARGB(255, 89, 201, 147),
                                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15))),
                                                      child: Image.asset('assets/images/locate.png', color: const Color.fromARGB(255, 10, 114, 64)),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      _areaBloc.add(SelectedContainer(index: index));
                                                      if (widget.area == 'UNASSIGNED') {
                                                        pageController.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: double.infinity,
                                                      padding: EdgeInsets.only(top: lsize.maxHeight * 0.031, bottom: lsize.maxHeight * 0.007),
                                                      decoration: const BoxDecoration(color: Color.fromARGB(255, 102, 102, 213)),
                                                      child: Image.asset(
                                                        'assets/images/${widget.area == 'UNASSIGNED' ? 'allocate' : 'relocate'}.png',
                                                        color: const Color.fromARGB(255, 13, 13, 116),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      Customs.DeleteContainerDialog(
                                                          context: context, containerNbr: container.containerNbr!, area: container.lotNo!.split('_')[0]);
                                                    },
                                                    child: Container(
                                                      height: double.infinity,
                                                      padding: EdgeInsets.only(top: lsize.maxHeight * 0.031, bottom: lsize.maxHeight * 0.007),
                                                      decoration: const BoxDecoration(
                                                          color: Color.fromARGB(255, 216, 97, 97),
                                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(15))),
                                                      child: Image.asset(
                                                        'assets/images/delete.png',
                                                        color: const Color.fromARGB(255, 118, 14, 14),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          })),
                                ],
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
                                        color: const Color.fromRGBO(164, 111, 218, 1),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(width: 3, color: const Color.fromRGBO(111, 54, 167, 1)),
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/businessman.png',
                                            scale: lsize.maxHeight * 0.004,
                                            color: const Color.fromRGBO(111, 54, 167, 1),
                                          ),
                                          Gap(lsize.maxWidth * 0.05),
                                          Expanded(
                                            child: Transform.translate(
                                              offset: Offset(-size.width * 0.0065, 0),
                                              child: Text(
                                                state.customers![state.selectedCustomerIndex!].customerName!,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(111, 54, 167, 1), fontSize: 16, letterSpacing: 1.6, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: lsize.maxHeight * 0.5,
                                    width: lsize.maxWidth * 0.95,
                                    padding: EdgeInsets.all(lsize.maxHeight * 0.02),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 197, 164, 231),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 3)]),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: IntrinsicWidth(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  'assets/images/container.png',
                                                  scale: lsize.maxHeight * 0.0035,
                                                  color: const Color.fromRGBO(111, 54, 167, 1),
                                                ),
                                                Gap(lsize.maxWidth * 0.03),
                                                Expanded(
                                                  child: Text(
                                                    state.customers![state.selectedCustomerIndex!].containers![state.selectedContainerIndex!].containerNbr!,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Color.fromRGBO(111, 54, 167, 1), fontSize: 18, letterSpacing: 1.6, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Gap(lsize.maxHeight * 0.05),
                                        Padding(
                                          padding: EdgeInsets.only(left: lsize.maxWidth * 0.01, top: lsize.maxHeight * 0.02, bottom: lsize.maxHeight * 0.02),
                                          child: Text(
                                            'Area',
                                            style: TextStyle(
                                              color: Color.fromRGBO(111, 54, 167, 1),
                                            ),
                                          ),
                                        ),
                                        AreaDropDown(),
                                        Padding(
                                          padding: EdgeInsets.only(left: lsize.maxWidth * 0.01, top: lsize.maxHeight * 0.03),
                                          child: Text(
                                            'Lot',
                                            style: TextStyle(
                                              color: Color.fromRGBO(111, 54, 167, 1),
                                            ),
                                          ),
                                        ),
                                        BlocBuilder<ContainerInteractionBloc, ContainerInteractionState>(builder: (context, state) {
                                          print('selected Area ${state.selectedDropdownArea}');
                                          return LotDropdown(
                                            suggestionsCallback: (pattern) {
                                              print('selected Area in ${state.selectedDropdownArea}');
                                              return state.lotsData![state.selectedDropdownArea!.toUpperCase()]['lots'].keys
                                                  .where((e) =>
                                                      e.contains(pattern) && state.lotsData![state.selectedDropdownArea!.toUpperCase()]['lots'][e].length < 3)
                                                  .toList()
                                                ..sort((a, b) {
                                                  // Extract numbers from lot names
                                                  int numA = int.tryParse(RegExp(r'\d+').firstMatch(a)?.group(0) ?? '0') ?? 0;
                                                  int numB = int.tryParse(RegExp(r'\d+').firstMatch(b)?.group(0) ?? '0') ?? 0;
                                                  return numA.compareTo(numB);
                                                });
                                            },
                                          );
                                        })
                                      ],
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
