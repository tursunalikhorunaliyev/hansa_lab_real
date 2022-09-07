import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
class TextIcon extends StatefulWidget {
 final String? text;
 final String? iconUrl;
 final Color rang;
 final Color colorIcon;
 final double size;
  final double widthSize;

  const TextIcon(
      {Key? key,
      required this.text,
      required this.iconUrl,
      this.rang = const Color(0xFFffffff), this.colorIcon = const Color(0xFFffffff), this.size = 20, this.widthSize = 22})
      : super(key: key);

  @override
  State<TextIcon> createState() => _TextIconState();
}

class _TextIconState extends State<TextIcon> {
  @override
  Widget build(BuildContext context) {
    final isTablet = Provider.of<bool>(context);
    return Row(
      children: [
        Image.asset(
          widget.iconUrl.toString(),
          height: widget.size,
          width:  widget.size,
          color: widget.colorIcon,
        
        ),
         SizedBox(
          width: widget.widthSize,
        ),
        Text(
          widget.text.toString(),
          style: GoogleFonts.montserrat(fontSize: isTablet ? 20  : 13, color: widget.rang),
        )
      ],
    );
  }
}
