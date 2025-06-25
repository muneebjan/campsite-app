import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:go_router/go_router.dart';

class CampsiteCard extends StatelessWidget {
  final Campsite campsite;

  const CampsiteCard({super.key, required this.campsite});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: campsite.photo,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.broken_image),
          ),
        ),
        title: Text(campsite.label),
        subtitle: Text('€${campsite.pricePerNight.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.push('/detail/${campsite.id}');
        },
      ),
    );
  }
}
