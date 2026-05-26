// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_playback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dialoguePlaybackHash() => r'f8a1f16b7d53185309fb65cccdbb6c5517293452';

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

abstract class _$DialoguePlayback
    extends BuildlessAutoDisposeNotifier<PlaybackState> {
  late final String projectId;
  late final String startNodeId;

  PlaybackState build(String projectId, String startNodeId);
}

/// See also [DialoguePlayback].
@ProviderFor(DialoguePlayback)
const dialoguePlaybackProvider = DialoguePlaybackFamily();

/// See also [DialoguePlayback].
class DialoguePlaybackFamily extends Family<PlaybackState> {
  /// See also [DialoguePlayback].
  const DialoguePlaybackFamily();

  /// See also [DialoguePlayback].
  DialoguePlaybackProvider call(String projectId, String startNodeId) {
    return DialoguePlaybackProvider(projectId, startNodeId);
  }

  @override
  DialoguePlaybackProvider getProviderOverride(
    covariant DialoguePlaybackProvider provider,
  ) {
    return call(provider.projectId, provider.startNodeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dialoguePlaybackProvider';
}

/// See also [DialoguePlayback].
class DialoguePlaybackProvider
    extends AutoDisposeNotifierProviderImpl<DialoguePlayback, PlaybackState> {
  /// See also [DialoguePlayback].
  DialoguePlaybackProvider(String projectId, String startNodeId)
    : this._internal(
        () => DialoguePlayback()
          ..projectId = projectId
          ..startNodeId = startNodeId,
        from: dialoguePlaybackProvider,
        name: r'dialoguePlaybackProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dialoguePlaybackHash,
        dependencies: DialoguePlaybackFamily._dependencies,
        allTransitiveDependencies:
            DialoguePlaybackFamily._allTransitiveDependencies,
        projectId: projectId,
        startNodeId: startNodeId,
      );

  DialoguePlaybackProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
    required this.startNodeId,
  }) : super.internal();

  final String projectId;
  final String startNodeId;

  @override
  PlaybackState runNotifierBuild(covariant DialoguePlayback notifier) {
    return notifier.build(projectId, startNodeId);
  }

  @override
  Override overrideWith(DialoguePlayback Function() create) {
    return ProviderOverride(
      origin: this,
      override: DialoguePlaybackProvider._internal(
        () => create()
          ..projectId = projectId
          ..startNodeId = startNodeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
        startNodeId: startNodeId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<DialoguePlayback, PlaybackState>
  createElement() {
    return _DialoguePlaybackProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DialoguePlaybackProvider &&
        other.projectId == projectId &&
        other.startNodeId == startNodeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, startNodeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DialoguePlaybackRef on AutoDisposeNotifierProviderRef<PlaybackState> {
  /// The parameter `projectId` of this provider.
  String get projectId;

  /// The parameter `startNodeId` of this provider.
  String get startNodeId;
}

class _DialoguePlaybackProviderElement
    extends AutoDisposeNotifierProviderElement<DialoguePlayback, PlaybackState>
    with DialoguePlaybackRef {
  _DialoguePlaybackProviderElement(super.provider);

  @override
  String get projectId => (origin as DialoguePlaybackProvider).projectId;
  @override
  String get startNodeId => (origin as DialoguePlaybackProvider).startNodeId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
