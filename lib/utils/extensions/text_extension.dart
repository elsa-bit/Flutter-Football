import 'package:flutter/widgets.dart';

extension TextExtension on Text {
  Text copyWith({
    String? data,
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) =>
      Text(
        (data != null) ? data: ((this.data != null) ? this.data! : ""),
        style: (style != null) ? style: this.style,
        strutStyle: (strutStyle != null) ? strutStyle: this.strutStyle,
        textAlign: (textAlign != null) ? textAlign: this.textAlign,
        textDirection: (textDirection != null) ? textDirection: this.textDirection,
        maxLines: (maxLines != null) ? maxLines: this.maxLines,
        selectionColor: (selectionColor != null) ? selectionColor: this.selectionColor,
      );
}
