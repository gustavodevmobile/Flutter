import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedCachedImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final BoxFit fit;
  final BorderRadius? borderRadius;


  const AnimatedCachedImage({
    required this.imageUrl,
    this.size = 96,
    this.fit = BoxFit.cover,
    this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: fit,
      placeholder: (context, url) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        ),
      ).animate().shimmer(duration: 1200.ms),
      errorWidget: (context, url, error) => Icon(Icons.error, size: size / 2),
      fadeInDuration: 600.ms,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        child: image,
      );
    } else {
      return ClipOval(child: image);
    }
  }
}