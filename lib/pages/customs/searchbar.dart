import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';

class SearchBar2 extends StatefulWidget {
  SearchBar2({super.key, required this.size});
  Size size;
  @override
  _SearchBar2State createState() => _SearchBar2State();
}

class _SearchBar2State extends State<SearchBar2> {
  bool isDropdownOpen = false;

  final List<String> dropdownItems = ['Refrigerated', 'Empty', 'Dry', 'Damaged'];

  String? placeholderText;
  String? dropdownValue;
  int? hoveredIndex;
  int? selectedIndex;

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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.055,
      width: size.width * 0.26,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
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
                      child: BlocBuilder<ContainerInteractionBloc, ContainerInteractionState>(
                          // buildWhen: (previous, current) => current.searchText == '',
                          builder: (context, state) {
                        return TextField(
                          controller: TextEditingController(),
                          onSubmitted: (value) {},
                          onChanged: (value) {},
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
                        );
                      }),
                    ),
                  ),
                  Container(
                    height: size.height * 0.046,
                    decoration: const BoxDecoration(color: Color.fromRGBO(121, 65, 177, 1), shape: BoxShape.circle),
                    child: Transform.translate(
                      offset: Offset(0, -size.height * 0.0055),
                      child: IconButton(
                          hoverColor: Colors.transparent,
                          onPressed: () {},
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
    );
  }
}
