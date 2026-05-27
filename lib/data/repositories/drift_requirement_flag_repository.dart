import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/requirement_flag.dart';
import '../../domain/repositories/requirement_flag_repository.dart';
import '../database/app_database.dart';
import '../database/daos/requirement_flag_dao.dart';

class DriftRequirementFlagRepository implements RequirementFlagRepository {
  DriftRequirementFlagRepository(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  RequirementFlagDao get _dao => _db.requirementFlagDao;

  @override
  Future<List<RequirementFlag>> getByChoiceIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final rows = await _dao.getByChoiceIds(ids);
    return rows.map(_rowToEntity).toList();
  }

  @override
  Stream<List<RequirementFlag>> watchByChoice(String choiceId) {
    return _dao
        .watchByChoice(choiceId)
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  @override
  Future<RequirementFlag> create(CreateRequirementFlagInput input) async {
    final id = _uuid.v4();
    final companion = RequirementFlagsTableCompanion.insert(
      id: id,
      choiceId: input.choiceId,
      flagName: input.flagName,
      requiredValue: Value(input.requiredValue),
    );
    await _dao.insert(companion);
    return RequirementFlag(
      id: id,
      choiceId: input.choiceId,
      flagName: input.flagName,
      requiredValue: input.requiredValue,
    );
  }

  @override
  Future<void> delete(String id) => _dao.deleteById(id);

  @override
  Future<void> deleteByChoiceId(String choiceId) =>
      _dao.deleteByChoiceId(choiceId);

  RequirementFlag _rowToEntity(RequirementFlagsTableData row) {
    return RequirementFlag(
      id: row.id,
      choiceId: row.choiceId,
      flagName: row.flagName,
      requiredValue: row.requiredValue,
    );
  }
}
