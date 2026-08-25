import '../data/network/network_client.dart';
import '../data/repositories/earthquakes_repository.dart';
import '../data/services/earthquakes_remote_service.dart';
import '../domain/usecases/get_earthquakes_usecase.dart';

/// Mirrors Quake/Coordinator.swift's object graph wiring, minus the
/// SwiftUI-specific view factories — in Flutter, screens are built and
/// navigated to directly, so this class only owns the shared use cases.
class AppDependencies {
  late final NetworkClient networkClient;
  late final EarthquakesRemoteService earthquakesRemoteService;
  late final EarthquakesRepository earthquakesRepository;
  late final GetEarthquakesUseCase getEarthquakesUseCase;

  AppDependencies() {
    networkClient = HttpNetworkClient();
    earthquakesRemoteService = EarthquakesRemoteService(networkClient: networkClient);
    earthquakesRepository = EarthquakesRepository(remoteService: earthquakesRemoteService);
    getEarthquakesUseCase = GetEarthquakesUseCase(earthquakesRepository: earthquakesRepository);
  }
}
