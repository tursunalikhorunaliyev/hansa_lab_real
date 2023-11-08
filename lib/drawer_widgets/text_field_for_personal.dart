import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TextFieldForPersonal extends StatefulWidget {
  final String? text;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  const TextFieldForPersonal(
      {Key? key, required this.text, this.keyboardType, required this.controller,this.hintText})
      : super(key: key);

  @override
  State<TextFieldForPersonal> createState() => _TextFieldForPersonalState();
}

class _TextFieldForPersonalState extends State<TextFieldForPersonal> {
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    print(widget.controller);
    return Container(
      height: isTablet ? 45 : 36,
      width: isTablet ? 350 : 269,
      decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(54)),
      child: TextField(
        onTap: () {
          setState(() {
            widget.controller!.text = "";
          });
        },
        textDirection: TextDirection.rtl,
        controller: widget.controller!,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        style: GoogleFonts.montserrat(
            color: const Color(0xFFffffff), fontSize: isTablet ? 13  : 10),
        decoration: InputDecoration(
          hintText: widget.hintText ?? '',
          hintStyle: const TextStyle(color: Colors.white,fontSize: 12),
          prefixIcon: Padding(
            padding:  EdgeInsets.all( isTablet ? 15  : 10),
            child: Text(
              widget.text.toString(),
              style: GoogleFonts.montserrat(
                  fontSize: isTablet ? 13  : 10, color: const Color(0xFF767676)),
            ),
          ),
          contentPadding: const EdgeInsets.all(10),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(54)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(54)),
        ),
      ),
    );
  }
}
