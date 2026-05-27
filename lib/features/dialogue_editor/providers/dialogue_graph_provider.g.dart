// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_graph_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dialogueNodeRepositoryHash() =>
    r'a90f8f989e99ae4bd8583c6a318cb6e8f62958fb';

/// See also [dialogueNodeRepository].
@ProviderFor(dialogueNodeRepository)
final dialogueNodeRepositoryProvider =
    Provider<DialogueNodeRepository>.internal(
      dialogueNodeRepository,
      name: r'dialogueNodeRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dialogueNodeRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DialogueNodeRepositoryRef = ProviderRef<DialogueNodeRepository>;
String _$dialogueChoiceRepositoryHash() =>
    r'6a8c1c3d6969efb4059ab9db984e28409187ea3e';

/// See also [dialogueChoiceRepository].
@ProviderFor(dialogueChoiceRepository)
final dialogueChoiceRepositoryProvider =
    Provider<DialogueChoiceRepository>.internal(
      dialogueChoiceRepository,
      name: r'dialogueChoiceRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dialogueChoiceRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DialogueChoiceRepositoryRef = ProviderRef<DialogueChoiceRepository>;
String _$dialogueNodesListHash() => r'9394ef8d60941626581e0591801f87c24ab8e20b';

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

/// See also [dialogueNodesList].
@ProviderFor(dialogueNodesList)
const dialogueNodesListProvider = DialogueNodesListFamily();

/// See also [dialogueNodesList].
class DialogueNodesListFamily extends Family<AsyncValue<List<DialogueNode>>> {
  /// See also [dialogueNodesList].
  const DialogueNodesListFamily();

  /// See also [dialogueNodesList].
  DialogueNodesListProvider call(String npcId) {
    return DialogueNodesListProvider(npcId);
  }

  @override
  DialogueNodesListProvider getProviderOverride(
    covariant DialogueNodesListProvider provider,
  ) {
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
  String? get name => r'dialogueNodesListProvider';
}

/// See also [dialogueNodesList].
class DialogueNodesListProvider
    extends AutoDisposeStreamProvider<List<DialogueNode>> {
  /// See also [dialogueNodesList].
  DialogueNodesListProvider(String npcId)
    : this._internal(
        (ref) => dialogueNodesList(ref as DialogueNodesListRef, npcId),
        from: dialogueNodesListProvider,
        name: r'dialogueNodesListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dialogueNodesListHash,
        dependencies: DialogueNodesListFamily._dependencies,
        allTransitiveDependencies:
            DialogueNodesListFamily._allTransitiveDependencies,
        npcId: npcId,
      );

  DialogueNodesListProvider._internal(
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
  Override overrideWith(
    Stream<List<DialogueNode>> Function(DialogueNodesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DialogueNodesListProvider._internal(
        (ref) => create(ref as DialogueNodesListRef),
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
  AutoDisposeStreamProviderElement<List<DialogueNode>> createElement() {
    return _DialogueNodesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DialogueNodesListProvider && other.npcId == npcId;
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
mixin DialogueNodesListRef on AutoDisposeStreamProviderRef<List<DialogueNode>> {
  /// The parameter `npcId` of this provider.
  String get npcId;
}

class _DialogueNodesListProviderElement
    extends AutoDisposeStreamProviderElement<List<DialogueNode>>
    with DialogueNodesListRef {
  _DialogueNodesListProviderElement(super.provider);

  @override
  String get npcId => (origin as DialogueNodesListProvider).npcId;
}

String _$dialogueChoicesListHash() =>
    r'08113fd743a28bbcced92e44ee41111c9ac2e219';

/// See also [dialogueChoicesList].
@ProviderFor(dialogueChoicesList)
const dialogueChoicesListProvider = DialogueChoicesListFamily();

/// See also [dialogueChoicesList].
class DialogueChoicesListFamily
    extends Family<AsyncValue<List<DialogueChoice>>> {
  /// See also [dialogueChoicesList].
  const DialogueChoicesListFamily();

  /// See also [dialogueChoicesList].
  DialogueChoicesListProvider call(String npcId) {
    return DialogueChoicesListProvider(npcId);
  }

  @override
  DialogueChoicesListProvider getProviderOverride(
    covariant DialogueChoicesListProvider provider,
  ) {
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
  String? get name => r'dialogueChoicesListProvider';
}

/// See also [dialogueChoicesList].
class DialogueChoicesListProvider
    extends AutoDisposeStreamProvider<List<DialogueChoice>> {
  /// See also [dialogueChoicesList].
  DialogueChoicesListProvider(String npcId)
    : this._internal(
        (ref) => dialogueChoicesList(ref as DialogueChoicesListRef, npcId),
        from: dialogueChoicesListProvider,
        name: r'dialogueChoicesListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dialogueChoicesListHash,
        dependencies: DialogueChoicesListFamily._dependencies,
        allTransitiveDependencies:
            DialogueChoicesListFamily._allTransitiveDependencies,
        npcId: npcId,
      );

  DialogueChoicesListProvider._internal(
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
  Override overrideWith(
    Stream<List<DialogueChoice>> Function(DialogueChoicesListRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DialogueChoicesListProvider._internal(
        (ref) => create(ref as DialogueChoicesListRef),
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
  AutoDisposeStreamProviderElement<List<DialogueChoice>> createElement() {
    return _DialogueChoicesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DialogueChoicesListProvider && other.npcId == npcId;
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
mixin DialogueChoicesListRef
    on AutoDisposeStreamProviderRef<List<DialogueChoice>> {
  /// The parameter `npcId` of this provider.
  String get npcId;
}

class _DialogueChoicesListProviderElement
    extends AutoDisposeStreamProviderElement<List<DialogueChoice>>
    with DialogueChoicesListRef {
  _DialogueChoicesListProviderElement(super.provider);

  @override
  String get npcId => (origin as DialogueChoicesListProvider).npcId;
}

String _$dialogueGraphHash() => r'1ba549d6d6ce3e6ca929fa76e36c3eb826551cb0';

abstract class _$DialogueGraph
    extends BuildlessAutoDisposeAsyncNotifier<DialogueGraphState> {
  late final String npcId;

  FutureOr<DialogueGraphState> build(String npcId);
}

/// See also [DialogueGraph].
@ProviderFor(DialogueGraph)
const dialogueGraphProvider = DialogueGraphFamily();

/// See also [DialogueGraph].
class DialogueGraphFamily extends Family<AsyncValue<DialogueGraphState>> {
  /// See also [DialogueGraph].
  const DialogueGraphFamily();

  /// See also [DialogueGraph].
  DialogueGraphProvider call(String npcId) {
    return DialogueGraphProvider(npcId);
  }

  @override
  DialogueGraphProvider getProviderOverride(
    covariant DialogueGraphProvider provider,
  ) {
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
  String? get name => r'dialogueGraphProvider';
}

/// See also [DialogueGraph].
class DialogueGraphProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          DialogueGraph,
          DialogueGraphState
        > {
  /// See also [DialogueGraph].
  DialogueGraphProvider(String npcId)
    : this._internal(
        () => DialogueGraph()..npcId = npcId,
        from: dialogueGraphProvider,
        name: r'dialogueGraphProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dialogueGraphHash,
        dependencies: DialogueGraphFamily._dependencies,
        allTransitiveDependencies:
            DialogueGraphFamily._allTransitiveDependencies,
        npcId: npcId,
      );

  DialogueGraphProvider._internal(
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
  FutureOr<DialogueGraphState> runNotifierBuild(
    covariant DialogueGraph notifier,
  ) {
    return notifier.build(npcId);
  }

  @override
  Override overrideWith(DialogueGraph Function() create) {
    return ProviderOverride(
      origin: this,
      override: DialogueGraphProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<DialogueGraph, DialogueGraphState>
  createElement() {
    return _DialogueGraphProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DialogueGraphProvider && other.npcId == npcId;
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
mixin DialogueGraphRef
    on AutoDisposeAsyncNotifierProviderRef<DialogueGraphState> {
  /// The parameter `npcId` of this provider.
  String get npcId;
}

class _DialogueGraphProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          DialogueGraph,
          DialogueGraphState
        >
    with DialogueGraphRef {
  _DialogueGraphProviderElement(super.provider);

  @override
  String get npcId => (origin as DialogueGraphProvider).npcId;
}

String _$layoutDirectionHash() => r'ecbd2d502306e673bac430ea910253df0c084adc';

/// See also [LayoutDirection].
@ProviderFor(LayoutDirection)
final layoutDirectionProvider =
    AutoDisposeNotifierProvider<LayoutDirection, Axis>.internal(
      LayoutDirection.new,
      name: r'layoutDirectionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$layoutDirectionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LayoutDirection = AutoDisposeNotifier<Axis>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
