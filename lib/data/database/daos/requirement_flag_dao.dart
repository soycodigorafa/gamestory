import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/requirement_flags_table.dart';

part 'requirement_flag_dao.g.dart';

@DriftAccessor(tables: [RequirementFlagsTable])
class RequirementFlagDao extends DatabaseAccessor<AppDatabase>
    with _$RequirementFlagDaoMixin {
  RequirementFlagDao(super.db);

  Stream<List<RequirementFlagsTableData>> watchByChoice(String choiceId) =>
      (select(requirementFlagsTable)
            ..where((t) => t.choiceId.equals(choiceId)))
          .watch();

  Future<void> insert(RequirementFlagsTableCompanion companion) =>
      into(requirementFlagsTable).insertOnConflictUpdate(companion);

  Future<void> deleteById(String id) =>
      (delete(requirementFlagsTable)..where((t) => t.id.equals(id))).go();

  Future<void> deleteByChoiceId(String choiceId) =>
      (delete(requirementFlagsTable)
            ..where((t) => t.choiceId.equals(choiceId)))
          .go();
}
