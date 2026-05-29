// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'npc_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'96b544ff7ce456f0fc1edbdafdf332306a9affed';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$npcRepositoryHash() => r'18d668bceda3a93db30c4c86d426cf0f641b550e';

/// See also [npcRepository].
@ProviderFor(npcRepository)
final npcRepositoryProvider = Provider<NpcRepository>.internal(
  npcRepository,
  name: r'npcRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$npcRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NpcRepositoryRef = ProviderRef<NpcRepository>;
String _$npcListHash() => r'ffb8ec9e197788913100b3cd192b0cc8a6abd19e';

/// See also [NpcList].
@ProviderFor(NpcList)
final npcListProvider =
    AutoDisposeStreamNotifierProvider<NpcList, List<Npc>>.internal(
      NpcList.new,
      name: r'npcListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$npcListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NpcList = AutoDisposeStreamNotifier<List<Npc>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
