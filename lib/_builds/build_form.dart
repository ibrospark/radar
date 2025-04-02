// buildMultipleChipField Method
import 'package:flutter/material.dart';
import 'package:radar/_builds/build_all_elements.dart';
import 'package:radar/utils/constants.dart';

// TextFormField ----------------------------------------------------------------------
buildTextFormField({
  labelText,
  hintText,
  validator,
  TextEditingController? controller,
  bool obscureText = false,
  int? maxLines = 1,
  int? minLines = 1,
  String? initialValue,
  TextInputAction? textInputAction = TextInputAction.next,
  TextInputType? keyboardType = TextInputType.text,
  Widget? suffix,
  Widget? prefix,
  void Function(String)? onChanged,
  bool disableLabel = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      disableLabel
          ? Container()
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: buildText(
                text: labelText,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.left,
              ),
            ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          minLines: minLines,
          maxLines: maxLines,
          initialValue: initialValue,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
              fillColor: white,
              filled: true,
              suffix: suffix,
              prefix: prefix,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: labelText,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              labelStyle: buildTextStyle(
                color: thirdColor,
              ),
              hintStyle: buildTextStyle(
                color: thirdColor,
              )),
          style: buildTextStyle(
            color: thirdColor,
          ),
          validator: validator,
        ),
      ),
    ],
  );
}

buildElevatedButtonIcon({
  TextStyle? textStyle,
  Size? fixedSize,
  void Function()? onPressed,
  Widget? icon,
  required String? label,
  required Color backgroundColor,
  Color color = Colors.black,
  double? fontSize = 12,
}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      elevation: 1,
      backgroundColor: backgroundColor,
      textStyle: textStyle,
      fixedSize: fixedSize,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    onPressed: onPressed,
    icon: icon,
    label: buildText(
      text: label!.toUpperCase(),
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: color,
    ),
  );
}

buildWrapTextFormField({required Widget? child}) {
  return Container(
    margin: const EdgeInsets.all(10),
    height: 50,
    decoration: BoxDecoration(
      color: white,
      border: Border.all(
        width: 1,
        color: Colors.transparent,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(15)),
    ),
    child: child,
  );
}

buildMultipleSelection({
  required List<String> optionsList,
  required List<String> selectedOptions,
  required ValueChanged<List<String>> onChanged,
}) {
  return Wrap(
    spacing: 8.0, // Espace entre les chips
    children: optionsList.map((option) {
      return ChoiceChip(
        shadowColor: Colors.transparent,
        selectedShadowColor: Colors.transparent,
        side: BorderSide.none,
        selectedColor: primaryColor,
        disabledColor: primaryColor.shade100,
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(option),
        selected: selectedOptions.contains(option),
        onSelected: (bool selected) {
          List<String> updatedSelectedOptions = List.from(selectedOptions);
          if (selected) {
            updatedSelectedOptions.add(option);
          } else {
            updatedSelectedOptions.remove(option);
          }
          onChanged(updatedSelectedOptions);
        },
      );
    }).toList(),
  );
}

Widget buildDropdownButton({
  required List<String> items,
  required String selectedItem,
  required ValueChanged<String?> onChanged,
  String hint = 'Sélectionnez un élément',
  Widget? icon = const Icon(Icons.arrow_drop_down),
  bool isExpanded = true,
  int elevation = 16,
}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        focusColor: Colors.transparent,
        value: selectedItem.isEmpty ? items.first : selectedItem,
        // Couleur du texte du hint
        icon: icon,
        isExpanded: isExpanded,
        elevation: elevation,
        onChanged: onChanged,
        dropdownColor: white, // Couleur du fond du dropdown
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: buildTextStyle(
                color: thirdColor,
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}

Widget buildRadioButton({
  required String title,
  required String value,
  required String? selectedGroupValue,
  required Function(String?)? onChanged,
  double borderRadius = 10,
}) {
  bool isSelected = selectedGroupValue == value;

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
        color: isSelected
            ? primaryColor
            : Colors.white, // Couleur de fond selon l'état sélectionné
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isSelected
              ? primaryColor
              : Colors.grey, // Bordure optionnelle pour délimiter
        ),
      ),
      child: RadioListTile<String>(
        tileColor: Colors
            .transparent, // Définir transparent ici pour que Container gère le background
        title: Text(title),
        value: value,
        groupValue: selectedGroupValue,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.all(0.0),
        dense: true,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
  );
}
