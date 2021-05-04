import 'package:flutter/material.dart';
import 'package:grocery_client_reboot/styles/textfields.dart';

class AppTextFieldEmail extends StatefulWidget {
  final bool isIOS;
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChanged;
  final String errorText;
  final String initialText;
  final int maxLines;
  final bool enabled;

  AppTextFieldEmail({
    @required this.isIOS,
    @required this.hintText,
    @required this.cupertinoIcon,
    @required this.materialIcon,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.errorText,
    this.initialText,
    this.maxLines = 1,
    this.enabled,
  });

  @override
  _AppTextFieldEmailState createState() => _AppTextFieldEmailState();
}

class _AppTextFieldEmailState extends State<AppTextFieldEmail> {
  FocusNode _node;
  bool displayCupertinoErrorBorder;
  TextEditingController _controller;

  @override
  void initState() {
    _node = FocusNode();
    _controller = TextEditingController();
    if (widget.initialText != null) _controller.text = widget.initialText;
    _node.addListener(_handleFocusChange);
    displayCupertinoErrorBorder = false;
    super.initState();
  }

  void _handleFocusChange() {
    if (_node.hasFocus == false && widget.errorText != null) {
      displayCupertinoErrorBorder = true;
    } else {
      displayCupertinoErrorBorder = false;
    }

    widget.onChanged(_controller.text);
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: TextFieldStyles.textBoxHorizontal,
          vertical: TextFieldStyles.textBoxVertical),
      child: TextField(
        keyboardType: widget.textInputType,
        cursorColor: TextFieldStyles.cursorColor,
        style: TextFieldStyles.text,
        textAlign: TextFieldStyles.textAlign,
        decoration: TextFieldStyles.materialDecoration(
            widget.hintText, widget.materialIcon, widget.errorText),
        obscureText: widget.obscureText,
        controller: _controller,
        onChanged: widget.onChanged,
        maxLines: widget.maxLines,
        enabled: false,
      ),
    );
  }
}
