import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_3d/bloc/area/area_bloc.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class SearchBarDropdown extends StatefulWidget {
  SearchBarDropdown({super.key, required this.size});
  Size size;
  @override
  _SearchBarDropdownState createState() => _SearchBarDropdownState();
}

class _SearchBarDropdownState extends State<SearchBarDropdown> {
  bool isDropdownOpen = false;

  final List<String> dropdownItems = ['Refrigerated', 'Empty', 'Dry', 'Damaged', 'Unassigned'];

  String? placeholderText;
  String? dropdownValue;
  int? hoveredIndex;
  TextEditingController searchFieldController = TextEditingController();
  late final AreaBloc _areaBloc;
  late final ContainerInteractionBloc _containerInteractionBloc;
  bool searchTextIsEmpty = true;

  double? height;
  double? bottomHeight;
  double turns = 1;
  @override
  void initState() {
    super.initState();
    height = widget.size.height * 0.08;
    bottomHeight = widget.size.height * 0.06;
    placeholderText = 'What are you looking for?';
    dropdownValue = "Area";
    _areaBloc = context.read<AreaBloc>();
    _containerInteractionBloc = context.read<ContainerInteractionBloc>();
    _containerInteractionBloc.state.searchTextController = searchFieldController;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MouseRegion(
      onExit: (event) {
        context.read<ContainerInteractionBloc>().add(Intercepting(intercepting: false));
        setState(() {
          height = size.height * 0.08;
          bottomHeight = size.height * 0.06;
          turns = 1;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        width: size.width * 0.26,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: bottomHeight,
              width: size.width * 0.1,
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(top: size.height * 0.07),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(242, 228, 255, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: MouseRegion(
                    onExit: (event) {
                      setState(() {
                        height = size.height * 0.08;
                        bottomHeight = size.height * 0.06;
                        turns = 1;
                      });
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        if (height == size.height * 0.08) {
                          context.read<ContainerInteractionBloc>().add(Intercepting(intercepting: false));
                        }
                      });
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dropdownItems.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              placeholderText = 'What are you looking for?';
                              _areaBloc.state.getSearchContainerStatus = SearchContainerStatus.initial;
                              _containerInteractionBloc.state.searchTextController!.clear();
                              _containerInteractionBloc.add(SelectedArea(selectedArea: AreaName.values.sublist(1)[index]));
                              _containerInteractionBloc.state.webViewController!
                                  .evaluateJavascript(source: 'switchCamera("${AreaName.values.sublist(1)[index].name.toUpperCase()}_AREA")');
                              _containerInteractionBloc.add(DataFromJS(dataFromJS: {"area": AreaName.values.sublist(1)[index].name.toUpperCase()}));
                              height = height == size.height * 0.3
                                  ? size.height * 0.08
                                  : size.height * 0.3; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                              bottomHeight = bottomHeight == size.height * 0.3 ? size.height * 0.06 : size.height * 0.3;
                              turns = turns == 1 ? 0.5 : 1; // when icon is click and move down it change to opposit direction otherwise as it is
                            });
                          },
                          onHover: (value) {
                            setState(() {
                              hoveredIndex = value ? index : null;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              AreaName.values.sublist(1)[index].name,
                              style: TextStyle(
                                color: index == hoveredIndex ? Color.fromRGBO(121, 65, 177, 1) : null,
                                fontWeight: FontWeight.w500,
                                fontSize: size.height * 0.022,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: size.height * 0.055,
              width: size.width * 0.26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
                    onHover: (value) {
                      hoveredIndex = null;
                      context.read<ContainerInteractionBloc>().add(Intercepting(intercepting: true));
                      setState(() {
                        height = size.height * 0.3; // it means when we click on this icon it height is expand from 150 to 400 otherwise it is 150
                        bottomHeight = size.height * 0.3;
                        turns = 0.5; // when icon is click and move down it change to opposit direction otherwise as it is
                      });
                    },
                    child: Container(
                      height: size.height * 0.055,
                      padding: EdgeInsets.only(left: size.width * 0.01, top: size.height * 0.008, bottom: size.height * 0.008, right: size.width * 0.005),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(121, 65, 177, 1), // Purple background
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), bottomLeft: Radius.circular(50)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<ContainerInteractionBloc, ContainerInteractionState>(builder: (context, state) {
                            return Text(
                              state.selectedAreaName!.name.toString(),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: size.height * 0.022),
                            );
                          }),
                          Gap(size.width * 0.005),
                          BlocListener<AreaBloc, AreaState>(
                            listener: (context, state) {
                              if (state.getSearchContainerStatus == SearchContainerStatus.success && searchFieldController.text.isNotEmpty) {
                                String area = state.customers!.first.containers!.first.lotNo!.split('_')[0];
                                _containerInteractionBloc.add(DataFromJS(dataFromJS: {"area": area}));
                                _containerInteractionBloc.state.webViewController!.evaluateJavascript(source: 'switchCamera("${area}_AREA")');
                              } else if (state.getSearchContainerStatus == SearchContainerStatus.noDataFound) {
                                _containerInteractionBloc.add(DataFromJS(dataFromJS: const {"object": "null"}));
                                Customs.CMSFlushbar(size, context, icon: Icon(Icons.error), message: 'container does not exist');
                              }
                            },
                            child: AnimatedRotation(
                              turns: turns,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: size.height * 0.025,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Search Box
                  Expanded(
                    flex: 10,
                    child: MouseRegion(
                      onEnter: (event) {
                        setState(() {
                          height = size.height * 0.08;
                          bottomHeight = size.height * 0.06;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Transform.translate(
                              offset: Offset(0, -size.height * 0.005),
                              child: TextField(
                                controller: searchFieldController,
                                inputFormatters: [UpperCaseTextFormatter()],
                                onSubmitted: (value) {
                                  search(size);
                                },
                                textAlignVertical: TextAlignVertical.center,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: placeholderText,
                                  contentPadding: EdgeInsets.only(left: size.width * 0.008, top: size.height * 0.012),
                                  isCollapsed: true,
                                  hintStyle: TextStyle(
                                    color: Colors.black54, // Purple
                                    fontSize: size.height * 0.022,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                ),
                                cursorHeight: size.height * 0.03,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          if (searchFieldController.text.isNotEmpty)
                            Transform.translate(
                              offset: Offset(size.width * 0.006, 0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchFieldController.clear();
                                  });
                                  if (_areaBloc.state.getSearchContainerStatus == SearchContainerStatus.success) {
                                    _areaBloc.add(GetAreaData(area: _areaBloc.state.customers!.first.containers!.first.lotNo!.split('_')[0]));
                                  }
                                  _areaBloc.state.getSearchContainerStatus = SearchContainerStatus.initial;
                                },
                                style: IconButton.styleFrom(overlayColor: Colors.transparent),
                                icon: Icon(
                                  Icons.clear_rounded,
                                  size: size.height * 0.03,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          Container(
                            height: size.height * 0.046,
                            decoration: const BoxDecoration(color: Color.fromRGBO(121, 65, 177, 1), shape: BoxShape.circle),
                            child: Transform.translate(
                              offset: Offset(0, -size.height * 0.0055),
                              child: IconButton(
                                  hoverColor: Colors.transparent,
                                  onPressed: () async {
                                    search(size);
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: size.height * 0.035,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void search(size) {
    String? message = containerNbrValidator(searchFieldController.text);
    if (message != null) {
      Customs.CMSFlushbar(size, context, message: message);
    } else {
      _areaBloc.state.getSearchContainerStatus = SearchContainerStatus.initial;
      _areaBloc.state.selectedCustomerIndex = 0;
      _areaBloc.add(SearchContainer(containerNbr: searchFieldController.text));
      // hit api with container number and if found get area and customer name
      // call areadata sheet with area name it will hit the api and get the data
    }
  }
}
