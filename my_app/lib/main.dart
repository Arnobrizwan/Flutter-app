import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/home/view_model/home_view_model.dart';
import 'ui/home/widgets/home_screen.dart';
import 'ui/home/widgets/search_screen.dart';
import 'ui/home/widgets/trip_detail_screen.dart';
import 'data/services/trip_service.dart';
import 'data/repositories/trip_repository.dart';
import 'domain/models/trip.dart';

void main() {
  runApp(const CompassApp());
}

class CompassApp extends StatelessWidget {
  const CompassApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide TripService
        Provider<TripService>(
          create: (_) => TripService(),
        ),

        // Provide TripRepository with access to TripService
        ProxyProvider<TripService, TripRepository>(
          update: (_, tripService, __) => TripRepository(tripService),
        ),

        // Provide HomeViewModel and load trips when TripRepository is injected
        ChangeNotifierProxyProvider<TripRepository, HomeViewModel>(
          create: (_) => HomeViewModel(),
          update: (_, tripRepo, viewModel) {
            viewModel!..setRepository(tripRepo);
            viewModel.loadTrips(); // ✅ Load trips here
            return viewModel;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Compass Travel App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const HomeScreen(),
          '/search': (_) => const SearchScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/trip_detail') {
            final trip = settings.arguments as Trip;
            return MaterialPageRoute(
              builder: (_) => TripDetailScreen(trip: trip),
            );
          }
          return null;
        },
      ),
    );
  }
}