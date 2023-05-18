import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:khoroch/widgets/shimmer.dart';

class KCachedImg extends StatelessWidget {
  const KCachedImg({
    Key? key,
    required this.url,
    this.height = 150,
    this.width,
    this.fit = BoxFit.cover,
    this.color,
    this.radius = 10,
  }) : super(key: key);
  final String url;
  final double height;
  final double? width;
  final double radius;
  final BoxFit fit;
  final Color? color;

  ImageProvider get provider => CachedNetworkImageProvider(url,
      maxHeight: height.toInt(), maxWidth: width?.toInt());

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        color: color,
        height: height,
        width: width,
        imageUrl: url,
        fit: fit,
        progressIndicatorBuilder: (context, url, downloadProgress) => KShimmer(
          child: SizedBox(
            height: height,
            width: width ?? 150,
          ),
        ),
      ),
    );
  }
}
