import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:uct_chat/helper/utils/constant.dart';

class CustomDropdownSearch extends StatefulWidget {
  final String title;
  final List<SelectedListItem> listdata;
  final TextEditingController dropdownSelectedName;
  final TextEditingController dropdownSelectedPushToken;
  final TextEditingController dropdownSelectedId;
  const CustomDropdownSearch({
    super.key,
    required this.title,
    required this.listdata,
    required this.dropdownSelectedName,
    required this.dropdownSelectedPushToken, 
    required this.dropdownSelectedId,
  });

  @override
  State<CustomDropdownSearch> createState() => _CustomDropdownSearchState();
}

class _CustomDropdownSearchState extends State<CustomDropdownSearch> {
  void showdropdownsearch() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            fontFamily: 'Unna',
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Unna',
          ),
        ),
        data: widget.listdata,
        selectedItems: (List<dynamic> selectedList) {
          SelectedListItem selectedListItem = selectedList[0];
          widget.dropdownSelectedName.text = selectedListItem.name;
          widget.dropdownSelectedPushToken.text = selectedListItem.value!;
          widget.dropdownSelectedId.text = selectedListItem.id!;
        },
      ),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        setState(() {});
      },
      
      controller: widget.dropdownSelectedName,
      cursorColor: whiteColor,
      style: const TextStyle(color: whiteColor, fontFamily: 'Unna'),
      onTap: () {
        FocusScope.of(context).unfocus();
        showdropdownsearch();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: primaryLightColor,
        hintStyle: const TextStyle(
          color: whiteColor,
          fontSize: 20,
          fontFamily: 'Unna',
        ),
        suffixIcon: const Icon(
          Icons.arrow_drop_down,
          color: whiteColor,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        hintText: widget.dropdownSelectedName.text == ""
            ? widget.title
            : widget.dropdownSelectedName.text,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
