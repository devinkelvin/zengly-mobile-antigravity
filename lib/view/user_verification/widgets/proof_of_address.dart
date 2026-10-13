import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:path/path.dart' as path;

import '../../../widgets/widgets.dart';

class ProofOfAddress extends StatefulWidget {
  const ProofOfAddress({super.key});

  @override
  State<ProofOfAddress> createState() => _ProofOfAddressState();
}

class _ProofOfAddressState extends State<ProofOfAddress> {
  File? _selectedFile;

  _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _selectedFile = File(result.files.single.path!);
      setState(() {});
    } else {
      if (!mounted) {
        return;
      }
      AppOverlays.showToast(
        context: context,
        message: "No file selected",
        toastType: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pickFile();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              child: Icon(Icons.add),
            ),
            SizedBox(width: 10),
            _selectedFile == null
                ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload File",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0,
                        ),
                      ),
                      Text(
                        "Utility bills, Land deed, etc.",
                        maxLines: 1,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          letterSpacing: 0,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onPrimaryFixedVariant,
                        ),
                      ),
                    ],
                  ),
                )
                : Expanded(
                  child: Text(
                    path.basename(_selectedFile!.path),
                    maxLines: 2,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                ),
            _selectedFile == null
                ? SizedBox()
                : IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedFile = null;
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

  // SizedBox(width: 10),
  //                   IconButton(onPressed: () {}, icon: Icon(Icons.close)),