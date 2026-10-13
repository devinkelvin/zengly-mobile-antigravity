import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import '../../core/network/api_response.dart';
import '../../data/data.dart';
import '../../features/kyc/providers/kyc_provider.dart';
import '../../widgets/widgets.dart';

class SelfieCapturePage extends ConsumerStatefulWidget {
  final String nin;
  const SelfieCapturePage({super.key, required this.nin});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelfieCapturePageState();
}

class _SelfieCapturePageState extends ConsumerState<SelfieCapturePage> {
  late CameraController _controller;
  late Future<void>? _initializeControllerFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (!mounted) return;

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    _isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _imageToBase64(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _takeSelfie() async {
    try {
      await _initializeControllerFuture;
      if (!mounted) return;

      final directory = await getTemporaryDirectory();
      final imagePath = join(directory.path, '${DateTime.now()}.png');

      final picture = await _controller.takePicture();
      await picture.saveTo(imagePath);
      if (!mounted) return;

      AppOverlays.showLoadingDialog(context: context);
      final selfie = await _imageToBase64(imagePath);
      if (!mounted) return;

      final response = await ref
          .read(kycNotifierProvider.notifier)
          .verifyNin(nin: widget.nin, selfieBase64: selfie);
      if (!mounted) return;
      context.pop();

      switch (response) {
        case ApiSuccess():
          AppOverlays.bottomSheet(
            context: context,
            isSuccess: true,
            action: () => context.pop(),
            title: 'Awesome!',
            content: 'Nin verification successful',
          );
        case ApiError(message: final message):
          AppOverlays.infoDialog(
            context: context,
            message: message,
            overlayType: OverlayType.failure,
          );
      }
    } catch (e) {
      if (!mounted) return;
      AppOverlays.infoDialog(
        context: context,
        message: e.toString(),
        overlayType: OverlayType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Selfie')),
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
              : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller);
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takeSelfie,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
