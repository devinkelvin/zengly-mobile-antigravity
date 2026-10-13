import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final bool? hasVerifyEnd;
  final bool isVerified;
  final VoidCallback? onVerify;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final String? icon;
  final bool isCalendar;
  final bool isReadOnly;
  final List<TextInputFormatter>? inputFormatters;
  final Color? labelColor;
  final bool showValidation;
  final Widget? prefixIcon;
  final BoxConstraints? prefixContraints, suffixIconConstraints;
  const AppTextField({
    super.key,
    required this.controller,
    this.isPassword = false,
    this.isCalendar = false,
    this.isReadOnly = false,
    this.showValidation = true,
    this.icon,
    this.labelText,
    this.hasVerifyEnd,
    this.isVerified = false,
    this.onVerify,
    this.keyboardType,
    this.validator,
    this.autofillHints,
    this.inputFormatters,
    this.labelColor,
    this.prefixIcon,
    this.prefixContraints,
    this.suffixIconConstraints,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasError = false;
  bool _isObscure = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.addListener(() {
        setState(() {
          _isFocused = _focusNode.hasFocus;
          if (!_isFocused) {
            _triggerValidate();
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _triggerValidate() {
    String? validationMessage = widget.validator?.call(widget.controller.text);
    if (_hasError != (validationMessage != null) ||
        _errorMessage != validationMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _hasError = validationMessage != null;
          _errorMessage = validationMessage;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              width: 1,
              color:
                  _hasError
                      ? Theme.of(context).colorScheme.error
                      : _isFocused
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onTap: () {
                    if (widget.isCalendar) {}
                  },
                  readOnly: widget.isReadOnly,
                  focusNode: _focusNode,
                  controller: widget.controller,
                  validator: (val) {
                    _triggerValidate();
                    return widget.validator?.call(
                      val,
                    ); // Remove the null check (!)
                  },
                  obscureText: widget.isPassword ? _isObscure : false,
                  inputFormatters: widget.inputFormatters,
                  autofillHints: widget.autofillHints,
                  style: const TextStyle(fontSize: 14),
                  onChanged: (_) => _triggerValidate(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: widget.keyboardType,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: TextStyle(
                      color:
                          widget.labelColor ??
                          Theme.of(context).colorScheme.scrim,
                      fontSize: 14,
                    ),
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.scrim,
                      fontSize: 14,
                    ),
                    errorMaxLines: 1,
                    suffixIconConstraints:
                        widget.suffixIconConstraints ??
                        BoxConstraints(
                          maxHeight: 24,
                          maxWidth: 32,
                          minHeight: 24,
                          minWidth: 32,
                        ),
                    prefixIcon: widget.prefixIcon,
                    prefixIconConstraints: widget.prefixContraints,
                    suffixIcon:
                        (widget.icon != null)
                            ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SvgPicture.asset(
                                widget.icon!,
                                height: 24,
                                width: 24,
                              ),
                            )
                            : null,
                    errorStyle: TextStyle(fontSize: 0),
                    border: InputBorder.none, // Remove default border
                    errorText: null, // Prevent default Flutter error message
                  ),
                ),
              ),
              if (widget.isPassword)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              else if (widget.hasVerifyEnd == true)
                widget.isVerified
                    ? Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : TextButton(
                      onPressed: widget.onVerify,
                      child: Text(
                        "Verify",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
            ],
          ),
        ),

        if (_hasError &&
            _errorMessage != null) // Show error only when validation fails
          widget.showValidation == false
              ? SizedBox()
              : Padding(
                padding: const EdgeInsets.only(top: 4, left: 8),
                child: Text(
                  _errorMessage ?? "",
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
      ],
    );
  }
}

class AppDropdownTextField extends StatefulWidget {
  final List<DropdownMenuItem<Object>>? items;
  final Function onChanged;
  final String? labelText;
  const AppDropdownTextField({
    super.key,
    required this.items,
    required this.onChanged,
    this.labelText,
  });

  @override
  State<AppDropdownTextField> createState() => _AppDropdownTextFieldState();
}

class _AppDropdownTextFieldState extends State<AppDropdownTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.only(left: 20, top: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: DropdownButtonFormField(
        items: widget.items,
        icon: Padding(
          padding: EdgeInsets.only(right: 12, bottom: 12),
          child: Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,

          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.scrim,
            fontSize: 14,
          ),
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.scrim,
            fontSize: 14,
          ),
          errorMaxLines: 1,

          errorStyle: TextStyle(fontSize: 0),
          border: InputBorder.none,
          errorText: null,
        ),

        onChanged: (val) {
          setState(() {
            widget.onChanged(val);
          });
        },
      ),
    );
  }
}
