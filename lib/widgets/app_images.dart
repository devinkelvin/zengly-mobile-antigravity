import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';

import '../data/data.dart';

class AppImageWidget extends StatelessWidget {
  final double? height, width, borderRadius, borderWidth;
  final ImageType? imageType;
  final bool? hasBorder;
  final bool isFullBorder;
  final Color? borderColor, imageColor;
  final BoxFit? fit;
  final Alignment? alignment;

  final String image;
  const AppImageWidget({
    super.key,
    this.height = 50,
    this.imageColor,
    this.borderRadius = 0,
    this.borderWidth = 2.0,
    this.width = 50,
    this.alignment,
    this.isFullBorder = true,
    this.borderColor = Colors.white,
    this.hasBorder = false,
    this.imageType = ImageType.network,
    required this.image,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius!),
        border:
            hasBorder!
                ? Border.all(width: borderWidth!, color: borderColor!)
                : null,
      ),
      height: height,
      width: width,
      child:
          imageType == ImageType.network
              ? ClipRRect(
                borderRadius:
                    isFullBorder
                        ? BorderRadius.circular(borderRadius!)
                        : BorderRadius.only(
                          topLeft: Radius.circular(borderRadius!),
                          topRight: Radius.circular(borderRadius!),
                        ),
                child:
                    image == ""
                        ? SizedBox(
                          height: height,
                          width: width,
                          child: Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                        : CachedNetworkImage(
                          imageUrl: image,
                          fit: fit,
                          height: height,
                          width: width,
                          color: imageColor,
                          alignment: alignment ?? Alignment.center,
                          errorWidget: (context, error, stackTrace) {
                            return Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                            );
                          },
                          progressIndicatorBuilder: (context, url, progress) {
                            return Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
                          },
                        ),
              )
              : imageType == ImageType.svg
              ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius!),
                child: SvgPicture.asset(
                  image,
                  fit: fit ?? BoxFit.contain,
                  height: height,
                  width: width,
                ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius!),
                child: Image.asset(
                  image,
                  fit: fit,
                  height: height,
                  width: width,
                ),
              ),
    );
  }
}

// class AppIconImage extends StatefulWidget {
//   final String image, firstName, lastName;
//   final BoxFit? fit;
//   final bool hasBorder, isFilePicker;
//   final Color borderColor;
//   final Function updateFile;

//   final double? height, width, borderRadius, borderWidth;
//   const AppIconImage({
//     super.key,
//     required this.image,
//     this.fit,
//     required this.lastName,
//     this.hasBorder = false,
//     this.borderColor = Colors.white,
//     this.isFilePicker = false,
//     this.height,
//     this.width,
//     this.borderRadius,
//     required this.updateFile,
//     this.borderWidth = 2.0,
//     required this.firstName,
//   });

//   @override
//   State<AppIconImage> createState() => _AppIconImageState();
// }

// class _AppIconImageState extends State<AppIconImage> {
//   File? file;
//   final picker = ImagePicker();

//   void _chooseImage() async {
//     // if (await Permission.photos.isDenied || await Permission.photos.isDenied) {
//     //   if (!mounted) {
//     //     return;
//     //   }
//     //   AppOverlays.infoDialog(
//     //     context: context,
//     //     message: "App requires access to photos to continue",
//     //     onPressed: () {
//     //       openAppSettings();
//     //     },
//     //   );
//     // } else {
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//       maxHeight: 500,
//       maxWidth: 500,
//     );
//     setState(() {
//       if (pickedFile != null) {
//         file = File(pickedFile.path);
//         widget.updateFile(file!);
//       }
//     });
//     //  }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.isFilePicker ? _chooseImage : null,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
//           border:
//               widget.hasBorder
//                   ? Border.all(
//                     width: widget.borderWidth!,
//                     color: widget.borderColor,
//                   )
//                   : null,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
//           child:
//               (file == null)
//                   ? ((widget.image == "")
//                       ? Consumer(
//                         builder: (context, ref, _) {
//                           final vm = ref.read(profileVm);
//                           final user = vm.user;
//                           final firstName = user?.firstName ?? "";
//                           final lastName = user?.lastName ?? "";
//                           return Container(
//                             width: widget.width,
//                             height: widget.height,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               color: AppColors.ash10,
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               (firstName != "" && lastName != "")
//                                   ? "${firstName.substring(0, 1).capitalizeFirst()}${lastName.substring(0, 1).capitalizeFirst()}"
//                                   : "Anonymous".substring(0, 1),
//                             ),
//                           );
//                         },
//                       )
//                       : (CachedNetworkImage(
//                         imageUrl: widget.image,
//                         fit: widget.fit,
//                         height: widget.height,
//                         width: widget.width,
//                         errorWidget: (context, error, stackTrace) {
//                           return Center(
//                             child: Container(
//                               width: widget.width,
//                               height: widget.height,
//                               color: AppColors.ash10,
//                               alignment: Alignment.center,
//                               child: Text(
//                                 "${widget.firstName.substring(0, 1)}${widget.lastName.substring(0, 1)}",
//                               ),
//                             ),
//                           );
//                         },
//                         progressIndicatorBuilder: (context, url, progress) {
//                           return AppLoader(value: progress.progress);
//                         },
//                       )))
//                   : Image.file(
//                     file!,
//                     width: widget.width,
//                     height: widget.height,
//                     fit: widget.fit,
//                   ),
//         ),
//       ),
//     );
//   }
// }

// class AppIconImagePreview extends StatefulWidget {
//   final String image, firstName, lastName;
//   final BoxFit? fit;
//   final bool hasBorder, isFilePicker;
//   final Color borderColor;
//   final VoidCallback onTap;

//   final double? height, width, borderRadius, borderWidth;
//   const AppIconImagePreview({
//     super.key,
//     required this.image,
//     this.fit,
//     required this.lastName,
//     this.hasBorder = false,
//     this.borderColor = Colors.white,
//     this.isFilePicker = false,
//     this.height,
//     this.width,
//     this.borderRadius,
//     required this.onTap,
//     this.borderWidth = 2.0,
//     required this.firstName,
//   });

//   @override
//   State<AppIconImagePreview> createState() => _AppIconImagePreviewState();
// }

// class _AppIconImagePreviewState extends State<AppIconImagePreview> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
//           border:
//               widget.hasBorder
//                   ? Border.all(
//                     width: widget.borderWidth!,
//                     color: widget.borderColor,
//                   )
//                   : null,
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
//           child:
//               ((widget.image == "")
//                   ? Consumer(
//                     builder: (context, ref, _) {
//                       return Container(
//                         width: widget.width,
//                         height: widget.height,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           color: AppColors.ash10,
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           "${widget.firstName.substring(0, 1).capitalizeFirst()}${widget.lastName.substring(0, 1).capitalizeFirst()}",
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       );
//                     },
//                   )
//                   : (CachedNetworkImage(
//                     imageUrl: widget.image,
//                     fit: widget.fit,
//                     height: widget.height,
//                     width: widget.width,
//                     errorWidget: (context, error, stackTrace) {
//                       return Center(
//                         child: Container(
//                           width: widget.width,
//                           height: widget.height,
//                           color: AppColors.ash10,
//                           alignment: Alignment.center,
//                           child: Text(
//                             "${widget.firstName.substring(0, 1)}${widget.lastName.substring(0, 1)}",
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ),
//                       );
//                     },
//                     progressIndicatorBuilder: (context, url, progress) {
//                       return AppLoader(value: progress.progress);
//                     },
//                   ))),
//         ),
//       ),
//     );
//   }
// }
