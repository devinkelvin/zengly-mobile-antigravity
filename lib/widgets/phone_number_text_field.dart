import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneNumberTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final Function? updatePhone;
  final bool? hasVerifyEnd;
  final bool isVerified;
  final VoidCallback? onVerify;

  const PhoneNumberTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.updatePhone,
    this.validator,
    this.hasVerifyEnd,
    this.isVerified = false,
    this.onVerify,
  });

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorMessage;

  List<Map<String, String>> _countries = [];
  Map<String, String>? _selectedCountry;

  Future<void> loadCountries() async {
    final String response = await rootBundle.loadString(
      'assets/countries/countries.json',
    );
    final List<dynamic> data = jsonDecode(response);
    _countries = data.map((item) => Map<String, String>.from(item)).toList();
    if (_countries.isNotEmpty) {
      _selectedCountry = _countries.firstWhere(
        (country) => country['name'] == 'Nigeria',
        orElse: () => _countries.first,
      );
    }
    if (mounted) setState(() {});
  }

  void _onNumberChanged(String value) {
    String phoneNumber = value.replaceAll(RegExp(r'\D'), '');
    if (_selectedCountry == null) return;

    String countryCode = _selectedCountry!['code']!;
    String dialCode = _selectedCountry!['dial_code']!;

    if (countryCode == "NG") {
      List<String> validPrefixes = ["070", "071", "080", "081", "090", "091"];
      bool hasValidPrefix = validPrefixes.any(
        (prefix) => phoneNumber.startsWith(prefix),
      );
      if (hasValidPrefix && phoneNumber.length >= 10) {
        if (phoneNumber.startsWith("0")) {
          phoneNumber = phoneNumber.substring(1);
        }
      }
    } else if (countryCode == "GB") {
      if (phoneNumber.length >= 10 && !phoneNumber.startsWith("07")) {
        setState(() {
          _hasError = true;
          _errorMessage = "Invalid UK phone number";
        });
        return;
      }
    } else if (countryCode == "US" || countryCode == "CA") {
      if (phoneNumber.length == 11 && phoneNumber.startsWith("1")) {
        phoneNumber = phoneNumber.substring(1);
      }
    }

    if (phoneNumber.length != 10 && phoneNumber.isNotEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = "Invalid phone number for ${_selectedCountry!['name']}";
      });
      return;
    }

    setState(() {
      _hasError = false;
      _errorMessage = null;
    });

    if (widget.updatePhone != null) {
      widget.updatePhone!("$dialCode$phoneNumber");
    }
  }

  void _validate() {
    _onNumberChanged(widget.controller.text);
  }

  @override
  void initState() {
    super.initState();
    loadCountries();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (!_isFocused) {
          _validate();
        }
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outlineVariant = Theme.of(context).colorScheme.outlineVariant;
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Country picker container
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: outlineVariant,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  width: 1,
                  color: Colors.transparent,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Map<String, String>>(
                  isExpanded: false,
                  value: _selectedCountry,
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: onSurface,
                    size: 18,
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return _countries.map((country) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            country['emoji'] ?? '🇳🇬',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            country['dial_code'] ?? '+234',
                            style: GoogleFonts.inter(
                              color: onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  onChanged: (Map<String, String>? newCountry) {
                    setState(() {
                      _selectedCountry = newCountry;
                    });
                  },
                  items: _countries.map((country) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: country,
                      child: Row(
                        children: [
                          Text(
                            country['emoji'] ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            country['dial_code'] ?? '',
                            style: GoogleFonts.inter(
                              color: onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              country['name'] ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: onSurface,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Phone input container
            Expanded(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: outlineVariant,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    width: 1,
                    color: _hasError
                        ? Theme.of(context).colorScheme.error
                        : _isFocused
                            ? primary
                            : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        focusNode: _focusNode,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: onSurface,
                        ),
                        controller: widget.controller,
                        onChanged: _onNumberChanged,
                        validator: widget.validator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '812 345 6789',
                          hintStyle: GoogleFonts.inter(
                            color: Theme.of(context).colorScheme.scrim,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                    if (widget.hasVerifyEnd == true)
                      widget.isVerified
                          ? Container(
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
                            )
                          : GestureDetector(
                              onTap: widget.onVerify,
                              child: Text(
                                "Verify",
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                            ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_hasError && _errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              _errorMessage!,
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
