// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectRepositoryHash() => r'6001bd006a4c5209799557184253d7f2335e9496';

/// See also [projectRepository].
@ProviderFor(projectRepository)
final projectRepositoryProvider = Provider<ProjectRepository>.internal(
  projectRepository,
  name: r'projectRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectRepositoryRef = ProviderRef<ProjectRepository>;
String _$projectListHash() => r'a9851a699914df2ad1a901b5263eebb380379caf';

/// See also [ProjectList].
@ProviderFor(ProjectList)
final projectListProvider =
    AutoDisposeStreamNotifierProvider<ProjectList, List<Project>>.internal(
      ProjectList.new,
      name: r'projectListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projectListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProjectList = AutoDisposeStreamNotifier<List<Project>>;
String _$currentProjectHash() => r'e5fd06226bc439c1966ad37d8058f62b47599a4b';

/// See also [CurrentProject].
@ProviderFor(CurrentProject)
final currentProjectProvider =
    NotifierProvider<CurrentProject, Project?>.internal(
      CurrentProject.new,
      name: r'currentProjectProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentProjectHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentProject = Notifier<Project?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
