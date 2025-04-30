import 'package:flutter/material.dart';
import '../../../domain/models/trip.dart';

class TripDetailScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailScreen({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Header Image
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.network(
                'https://images.unsplash.com/photo-1543340713-8cf9a3c6b53c?auto=format&fit=crop&w=1000&q=80',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Failed to load image'));
                },
              ),
            ),

            // ✅ Trip Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.dateRange,
                      style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 10),
                  Text(
                    trip.description,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    children: trip.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.blue.shade50,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 30),
                  const Text("Planned Activities",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  ...trip.activities.map(
                    (activity) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline,
                              color: Colors.green),
                          const SizedBox(width: 10),
                          Expanded(child: Text(activity)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}