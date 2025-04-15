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

  @override
  void initState() {
    super.initState();
    lotNoFocusNode.addListener(
      () {
        if (lotNoFocusNode.hasFocus) {
          suggestionsController.refresh();
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
          print('Focus Node : ${focusNode.hasFocus}');
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            onChanged: (value) {},
            style: TextStyle(fontSize: 14, color: Color.fromRGBO(111, 54, 167, 1)),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: size.width * 0.008, bottom: size.height * 0.008),

              hintText: focusNode.hasFocus ? 'Choose' : widget.selectedLot,
              hintStyle: TextStyle(fontSize: 14, color: Color.fromRGBO(111, 54, 167, 1)),
              border: InputBorder.none, // Removes all borders
            ),
          );
        },
        itemBuilder: (context, value) {
          return SizedBox(
            width: size.height * 0.2,
            child: ListTile(
              style: ListTileStyle.drawer,
              tileColor: const Color.fromRGBO(164, 111, 218, 1),
              textColor: Color.fromRGBO(111, 54, 167, 1),
              title: Text(
                value.toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          );
        },
        suggestionsCallback: widget.suggestionsCallback,
        onSelected: (value) {
          context.read<ContainerInteractionBloc>().add(DropdownLotChanged(lotNo: value));
          lotNoFocusNode.unfocus();
        },
      ),
    );
  }
}
