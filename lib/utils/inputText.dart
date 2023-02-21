import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_colors.dart';

class InputText extends StatefulWidget {
  InputText(
      {Key? key,
      this.controller,
      this.minLines = 1,
      this.maxLines = 1,
      this.inputFormatters,
      this.labelText = null,
      this.hintText = null,
      this.prefixIcon,
      this.validator,
      this.keyboardType,
      this.onChanged,
      this.enabled = true,
      this.readOnly = false,
      this.margin = const EdgeInsets.symmetric(vertical: 12),
      this.suffixIcon,
      this.onTap,
      this.textStyle,
      this.title,
      this.filled = false,
      this.labelColor,
      this.errorMaxLines,
      this.textAlign = TextAlign.start,
      this.activateCounter = false,
      this.maxLength = null,
      this.helperText = null,
      this.autoFocus = false,
      this.initialValue})
      : super(key: key);

  final TextEditingController? controller;
  final int minLines;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool enabled;
  final bool readOnly;
  final EdgeInsetsGeometry margin;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final TextStyle? textStyle;
  final String? title;
  final bool filled;
  final Color? labelColor;
  final int? errorMaxLines;
  final TextAlign textAlign;
  final bool activateCounter;
  final int? maxLength;
  final String? helperText;
  final bool autoFocus;
  final String? initialValue;

  @override
  _InputText createState() => _InputText();
}

class _InputText extends State<InputText> {
  String? counterTextString = '0/100';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            elevation: 0.0,
            child: TextFormField(
              onChanged: (value) {
                if (widget.activateCounter) {
                  setState(() {
                    counterTextString = '${value.length.toString()}/100';
                  });
                }
                if (widget.onChanged != null) {
                  widget.onChanged!.call(value);
                }
              },
              key: widget.key,
              maxLength: widget.maxLength,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              readOnly: widget.readOnly,
              controller: widget.controller,
              onTap: widget.onTap,
              inputFormatters: widget.inputFormatters,
              enabled: widget.enabled,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                letterSpacing: 0,
              ),
              textAlign: widget.textAlign,
              autofocus: widget.autoFocus,
              initialValue: widget.initialValue,
              decoration: InputDecoration(
                helperText: widget.helperText,
                counterText: widget.activateCounter ? counterTextString : null,
                contentPadding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                errorMaxLines: widget.errorMaxLines,
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                alignLabelWithHint: true,
                hintStyle: TextStyle(
                  color: Color(0xFF4E5462).withOpacity(0.64),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                labelStyle: TextStyle(
                  color: Color(0xFF4E5462).withOpacity(0.64),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                ),
                labelText: widget.labelText,
                hintText: widget.hintText,
                filled: true,
                fillColor: Color(0xff263956).withOpacity(0.04),
                focusColor: Color(0xff263956),
                hoverColor: Color(0xFFFFFFFF),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(width: 0, color: Color(0x26395629).withOpacity(0.16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(width: 1, color: Color(0x26395629).withOpacity(0.16)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
              ),
              validator: widget.validator,
              cursorColor: Theme.of(context).primaryColor,
              keyboardType: widget.keyboardType,
            ),
          ),
        ],
      ),
    );
  }
}

class InputTextV2 extends StatefulWidget {
  InputTextV2({
    Key? key,
    this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputFormatters,
    this.labelText = null,
    this.hintText = null,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onEditingComplete,
    this.enabled = true,
    this.readOnly = false,
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.suffixIcon,
    this.onTap,
    this.textStyle,
    this.title,
    this.filled = false,
    this.labelColor,
    this.errorMaxLines,
    this.textAlign = TextAlign.start,
    this.activateCounter = false,
    this.maxLength = null,
    this.helperText = null,
    this.autoFocus = false,
    this.fontSize = 26,
    this.helperFontSize = 12,
    this.scrollController,
    this.paddingContent = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.focusNode,
    this.onFieldSubmitted,
  }) : super(key: key);

  final TextEditingController? controller;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final bool enabled;
  final bool readOnly;
  final EdgeInsetsGeometry margin;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final TextStyle? textStyle;
  final String? title;
  final bool filled;
  final Color? labelColor;
  final int? errorMaxLines;
  final TextAlign textAlign;
  final bool activateCounter;
  final int? maxLength;
  final String? helperText;
  final bool autoFocus;
  final double fontSize;
  final double helperFontSize;
  final ScrollController? scrollController;
  final EdgeInsets? paddingContent;
  final BorderRadius borderRadius;
  final FocusNode? focusNode;
  final void Function(dynamic)? onFieldSubmitted;

  @override
  _InputTextV2 createState() => _InputTextV2();
}

class _InputTextV2 extends State<InputTextV2> {
  late String? counterTextString = null;

  @override
  void initState() {
    super.initState();
    counterTextString = '0/' + widget.maxLength.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        children: [
          Material(
            elevation: 0.0,
            color: Colors.transparent,
            child: TextFormField(
              focusNode: widget.focusNode,
              textInputAction: TextInputAction.next,
              scrollController: widget.scrollController != null ? widget.scrollController : null,
              onChanged: (value) {
                if (widget.activateCounter) {
                  setState(() {
                    counterTextString = '${value.length.toString()}/${widget.maxLength.toString()}';
                  });
                }
                if (widget.onChanged != null) {
                  widget.onChanged!.call(value);
                }
              },
              key: widget.key,
              maxLength: widget.maxLength,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              readOnly: widget.readOnly,
              controller: widget.controller,
              onTap: widget.onTap,
              onEditingComplete: widget.onEditingComplete,
              inputFormatters: widget.inputFormatters,
              enabled: widget.enabled,
              style: widget.textStyle,
              textAlign: widget.textAlign,
              textAlignVertical: TextAlignVertical.center,
              autofocus: widget.autoFocus,
              onFieldSubmitted: widget.onFieldSubmitted,
              decoration: InputDecoration(
                helperText: widget.helperText,
                helperStyle: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: widget.helperFontSize,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                counterText: widget.activateCounter ? counterTextString : null,
                contentPadding: widget.paddingContent,
                errorMaxLines: widget.errorMaxLines,
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                alignLabelWithHint: true,
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                labelStyle: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
                labelText: widget.labelText,
                hintText: widget.hintText,
                filled: true,
                fillColor: CustomColors.muggleGray_3,
                focusColor: CustomColors.muggleGray_3,
                hoverColor: CustomColors.muggleGray_3,
                enabledBorder: OutlineInputBorder(
                  borderRadius: widget.borderRadius,
                  borderSide: BorderSide(width: 0, color: Color(0x26395629).withOpacity(0.16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: widget.borderRadius,
                  borderSide: BorderSide(width: 1, color: Color(0x26395629).withOpacity(0.16)),
                ),
                border: OutlineInputBorder(
                  borderRadius: widget.borderRadius,
                  borderSide: BorderSide.none,
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
              ),
              validator: widget.validator,
              cursorColor: Theme.of(context).primaryColor,
              keyboardType: widget.keyboardType,
            ),
          ),
        ],
      ),
    );
  }
}

class FormatterIfZeroEmptyReplaceByOne extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (newValue.text.isEmpty) {
      newText.write('1');
    }
    // Dump the rest.
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newValue.selection.end + 1),
    );
  }
}

class InputTextV3 extends StatefulWidget {
  InputTextV3({
    Key? key,
    this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputFormatters,
    this.labelText = null,
    this.hintText = null,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onEditingComplete,
    this.enabled = true,
    this.readOnly = false,
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.suffixIcon,
    this.onTap,
    this.textStyle,
    this.title,
    this.filled = false,
    this.labelColor,
    this.errorMaxLines,
    this.textAlign = TextAlign.start,
    this.activateCounter = false,
    this.maxLength = null,
    this.helperText = null,
    this.autoFocus = false,
    this.fontSize = 26,
    this.helperFontSize = 12,
    this.scrollController,
    this.paddingContent = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    this.focusNode,
    this.onFieldSubmitted,
  }) : super(key: key);

  final TextEditingController? controller;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final bool enabled;
  final bool readOnly;
  final EdgeInsetsGeometry margin;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final TextStyle? textStyle;
  final String? title;
  final bool filled;
  final Color? labelColor;
  final int? errorMaxLines;
  final TextAlign textAlign;
  final bool activateCounter;
  final int? maxLength;
  final String? helperText;
  final bool autoFocus;
  final double fontSize;
  final double helperFontSize;
  final ScrollController? scrollController;
  final EdgeInsets? paddingContent;
  final BorderRadius borderRadius;
  final FocusNode? focusNode;
  final void Function(dynamic)? onFieldSubmitted;

  @override
  _InputTextV3 createState() => _InputTextV3();
}

class _InputTextV3 extends State<InputTextV3> {
  late String? counterTextString = null;

  @override
  void initState() {
    super.initState();
    counterTextString = '0/' + widget.maxLength.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: 60,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Material(
            elevation: 0.0,
            color: Colors.transparent,
            child: TextFormField(
              focusNode: widget.focusNode,
              textInputAction: TextInputAction.next,
              scrollController: widget.scrollController != null ? widget.scrollController : null,
              onChanged: (value) {
                if (widget.activateCounter) {
                  setState(() {
                    counterTextString = '${value.length.toString()}/${widget.maxLength.toString()}';
                  });
                }
                if (widget.onChanged != null) {
                  widget.onChanged!.call(value);
                }
              },
              key: widget.key,
              maxLength: widget.maxLength,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              readOnly: widget.readOnly,
              controller: widget.controller,
              onTap: widget.onTap,
              onEditingComplete: widget.onEditingComplete,
              inputFormatters: widget.inputFormatters,
              enabled: widget.enabled,
              style: widget.textStyle,
              textAlign: widget.textAlign,
              textAlignVertical: TextAlignVertical.center,
              autofocus: widget.autoFocus,
              onFieldSubmitted: widget.onFieldSubmitted,
              decoration: InputDecoration(
                helperText: widget.helperText,
                helperStyle: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: widget.helperFontSize,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
                counterText: widget.activateCounter ? counterTextString : null,
                contentPadding: widget.paddingContent,
                errorMaxLines: widget.errorMaxLines,
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                alignLabelWithHint: true,
                hintStyle: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
                labelStyle: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                ),
                labelText: widget.labelText,
                hintText: widget.hintText,
                filled: false,
                fillColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    color: Colors.transparent,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: widget.borderRadius,
                  borderSide: BorderSide.none,
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
              ),
              validator: widget.validator,
              cursorColor: Theme.of(context).primaryColor,
              keyboardType: widget.keyboardType,
            ),
          ),
        ],
      ),
    );
  }
}
