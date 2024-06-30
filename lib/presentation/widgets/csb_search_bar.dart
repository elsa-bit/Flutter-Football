import 'package:flutter/material.dart';
import 'package:flutter_football/config/app_colors.dart';
import 'package:flutter_football/config/app_themes.dart';

class CsbSearchBar extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final int delay;

  const CsbSearchBar({
    Key? key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.delay = 300,
  }) : super(key: key);

  @override
  State<CsbSearchBar> createState() => _CsbSearchBarState();
}

class _CsbSearchBarState extends State<CsbSearchBar> {
  //DateTime previousInput = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (e) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Icon(Icons.search),
        hintStyle: AppTextStyle.small,
        filled: true,
        fillColor: currentAppColors.primaryVariantColor1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide(color: Colors.yellow, width: 2),
        ),
      ),
      controller: widget.controller,
      enableSuggestions: false,
      autocorrect: false,
      onChanged: (v) {
        //final int millisDiff = DateTime.now().difference(previousInput).inMilliseconds;
        //if(millisDiff > widget.delay) return;
        if(this.widget.onChanged != null) this.widget.onChanged!(v);
      },
      onEditingComplete: (){
        if(this.widget.onEditingComplete != null) this.widget.onEditingComplete!();
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
