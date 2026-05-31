import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_dirty_provider.g.dart';

@Riverpod(keepAlive: true)
class ProjectDirty extends _$ProjectDirty {
  @override
  int build() => 0;

  void markDirty() => state++;
}
