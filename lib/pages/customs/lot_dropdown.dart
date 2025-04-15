import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:warehouse_3d/bloc/container/container_interaction_bloc.dart';

class LotDropdown<T> extends StatefulWidget {
  LotDropdown({super.key, required this.suggestionsCallback});
  FutureOr<List<T>?> Function(String) suggestionsCallback;

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

    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Color.fromRGBO(111, 54, 167, 1),
        ),
        color: const Color.fromRGBO(164, 111, 218, 1),
      ),
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
                    focusedBorder: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder())),
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
        suggestionsCallback: widget.suggestionsCallback,
        onSelected: (value) {
          lotNoTextEditingController.text = value;
          lotNoFocusNode.unfocus();
        },
      ),
    ));
  }
}
