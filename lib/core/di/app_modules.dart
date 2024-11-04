import 'package:get_it/get_it.dart';
import 'package:quake_flutter/data/earthquake/earthquakes_data_impl.dart';
import 'package:quake_flutter/data/earthquake/remote/earthquakes_remote_impl.dart';
import 'package:quake_flutter/data/remote/network_client.dart';
import 'package:quake_flutter/domain/earthquakes_repository.dart';
import 'package:quake_flutter/presentation/view/earthquake/viewmodel/earthquakes_view_model.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupEarthquakeModule();
  }

  _setupMainModule() {
    inject.registerSingleton(NetworkClient());
  }

  _setupEarthquakeModule() {
    inject.registerFactory(
        () => EarthquakesRemoteImpl(networkClient: inject.get()));
    inject.registerFactory<EarthquakesRepository>(() => EarthquakesDataImpl(
        remoteImpl: inject.get()));
    inject.registerFactory(
        () => EarthquakesViewModel(earthquakesRepository: inject.get()));
  }
}
