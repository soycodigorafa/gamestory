// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playbackHash() => r'3c5376c134edcdc916c914df4bf3a14475d41adb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Playback
    extends BuildlessAutoDisposeAsyncNotifier<PlaybackState> {
  late final String npcId;

  FutureOr<PlaybackState> build(String npcId);
}

/// See also [Playback].
@ProviderFor(Playback)
const playbackProvider = PlaybackFamily();

/// See also [Playback].
class PlaybackFamily extends Family<AsyncValue<PlaybackState>> {
  /// See also [Playback].
  const PlaybackFamily();

  /// See also [Playback].
  PlaybackProvider call(String npcId) {
    return PlaybackProvider(npcId);
  }

  @override
  PlaybackProvider getProviderOverride(covariant PlaybackProvider provider) {
    return call(provider.npcId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playbackProvider';
}

/// See also [Playback].
class PlaybackProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Playback, PlaybackState> {
  /// See also [Playback].
  PlaybackProvider(String npcId)
    : this._internal(
        () => Playback()..npcId = npcId,
        from: playbackProvider,
        name: r'playbackProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$playbackHash,
        dependencies: PlaybackFamily._dependencies,
        allTransitiveDependencies: PlaybackFamily._allTransitiveDependencies,
        npcId: npcId,
      );

  PlaybackProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.npcId,
  }) : super.internal();

  final String npcId;

  @override
  FutureOr<PlaybackState> runNotifierBuild(covariant Playback notifier) {
    return notifier.build(npcId);
  }

  @override
  Override overrideWith(Playback Function() create) {
    return ProviderOverride(
      origin: this,
      override: PlaybackProvider._internal(
        () => create()..npcId = npcId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        npcId: npcId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Playback, PlaybackState>
  createElement() {
    return _PlaybackProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaybackProvider && other.npcId == npcId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, npcId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaybackRef on AutoDisposeAsyncNotifierProviderRef<PlaybackState> {
  /// The parameter `npcId` of this provider.
  String get npcId;
}

class _PlaybackProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Playback, PlaybackState>
    with PlaybackRef {
  _PlaybackProviderElement(super.provider);

  @override
  String get npcId => (origin as PlaybackProvider).npcId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
