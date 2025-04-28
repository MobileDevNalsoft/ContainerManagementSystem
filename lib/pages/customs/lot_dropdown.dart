import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';

class LotDropdown<T> extends StatefulWidget {
  LotDropdown({super.key, required this.selectedLot, required this.suggestionsCallback});
  FutureOr<List<T>?> Function(String) suggestionsCallback;
  String selectedLot;

  @override
  State<LotDropdown> createState() => _LotDropdownState();
}

class _LotDropdownState extends State<LotDropdown> {
  FocusNode lotNoFocusNode = FocusNode();

  TextEditingController lotNoTextEditingController = TextEditingController();

  SuggestionsController suggestionsController = SuggestionsController();

  double turns = 1;

  @override
  void initState() {
    super.initState();
    lotNoTextEditingController.text = widget.selectedLot;
    lotNoFocusNode.addListener(
      () {
        if (lotNoFocusNode.hasFocus) {
          suggestionsController.refresh();
          setState(() {
            turns = 0.5;
          });
        } else {
          setState(() {
            turns = 1;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.06,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Color.fromRGBO(111, 54, 167, 1),
        ),
        color: Color.fromRGBO(242, 228, 255, 1),
      ),
      child: TypeAheadField(
        focusNode: lotNoFocusNode,
        controller: lotNoTextEditingController,
        suggestionsController: suggestionsController,
        builder: (context, controller, focusNode) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (value) {},
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: size.width * 0.009, bottom: size.height * 0.007, top: size.height * 0.015),
                hintText: 'Choose',
                hintStyle: TextStyle(fontSize: 14),
                border: InputBorder.none, // Removes all borders
                suffixIcon: AnimatedRotation(
                  turns: turns,
                  duration: Duration(milliseconds: 500),
                  child: Icon(Icons.keyboard_arrow_down_rounded),
                )),
          );
        },
        emptyBuilder: (context) => Expanded(
            child: Container(
          height: size.height * 0.06,
          width: double.infinity,
          padding: EdgeInsets.only(left: size.width * 0.01),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(164, 111, 218, 1),
          ),
          alignment: Alignment.centerLeft,
          child: Text('no data found'),
        )),
        itemBuilder: (context, value) {
          return SizedBox(
            width: size.height * 0.2,
            child: ListTile(
              style: ListTileStyle.drawer,
              tileColor: const Color.fromRGBO(164, 111, 218, 1),
              textColor: Colors.black,
              title: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
        suggestionsCallback: widget.suggestionsCallback,
        onSelected: (value) {
          context.read<ContainerInteractionBloc>().add(DropdownLotChanged(lotNo: value));
          lotNoTextEditingController.text = value;
          lotNoFocusNode.unfocus();
        },
      ),
    );
  }
}
