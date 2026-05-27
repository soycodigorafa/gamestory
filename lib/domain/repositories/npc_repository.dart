import '../entities/npc.dart';

abstract interface class NpcRepository {
  Stream<List<Npc>> watchAll();
  Future<Npc> create(CreateNpcInput input);
  Future<void> update(UpdateNpcInput input);
  Future<void> delete(String id);
}
