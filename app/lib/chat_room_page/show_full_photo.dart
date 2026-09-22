import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showFullImageUrl(BuildContext context, String url) {
  showDialog(
    context: context,
    builder: (_) => _FullscreenImageViewer(url: url),
  );
}

class _FullscreenImageViewer extends StatelessWidget {
  final String url;

  const _FullscreenImageViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: InteractiveViewer(
            child: CachedNetworkImage(
              imageUrl: url,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade300,
                child: const CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
