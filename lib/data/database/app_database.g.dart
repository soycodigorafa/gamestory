// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTableTable extends ProjectsTable
    with TableInfo<$ProjectsTableTable, ProjectsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    filePath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTableTable createAlias(String alias) {
    return $ProjectsTableTable(attachedDatabase, alias);
  }
}

class ProjectsTableData extends DataClass
    implements Insertable<ProjectsTableData> {
  final String id;
  final String name;
  final String description;
  final String? filePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProjectsTableData({
    required this.id,
    required this.name,
    required this.description,
    this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsTableCompanion toCompanion(bool nullToAbsent) {
    return ProjectsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProjectsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'filePath': serializer.toJson<String?>(filePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProjectsTableData copyWith({
    String? id,
    String? name,
    String? description,
    Value<String?> filePath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProjectsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    filePath: filePath.present ? filePath.value : this.filePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProjectsTableData copyWithCompanion(ProjectsTableCompanion data) {
    return ProjectsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, filePath, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.filePath == this.filePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsTableCompanion extends UpdateCompanion<ProjectsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> filePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProjectsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.filePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.filePath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProjectsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? filePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (filePath != null) 'file_path': filePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String?>? filePath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProjectsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NpcsTableTable extends NpcsTable
    with TableInfo<$NpcsTableTable, NpcsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NpcsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _canvasXMeta = const VerificationMeta(
    'canvasX',
  );
  @override
  late final GeneratedColumn<double> canvasX = GeneratedColumn<double>(
    'canvas_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _canvasYMeta = const VerificationMeta(
    'canvasY',
  );
  @override
  late final GeneratedColumn<double> canvasY = GeneratedColumn<double>(
    'canvas_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#7B61FF'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    description,
    canvasX,
    canvasY,
    colorHex,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'npcs';
  @override
  VerificationContext validateIntegrity(
    Insertable<NpcsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('canvas_x')) {
      context.handle(
        _canvasXMeta,
        canvasX.isAcceptableOrUnknown(data['canvas_x']!, _canvasXMeta),
      );
    }
    if (data.containsKey('canvas_y')) {
      context.handle(
        _canvasYMeta,
        canvasY.isAcceptableOrUnknown(data['canvas_y']!, _canvasYMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NpcsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NpcsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      canvasX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}canvas_x'],
      )!,
      canvasY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}canvas_y'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NpcsTableTable createAlias(String alias) {
    return $NpcsTableTable(attachedDatabase, alias);
  }
}

class NpcsTableData extends DataClass implements Insertable<NpcsTableData> {
  final String id;
  final String projectId;
  final String name;
  final String description;
  final double canvasX;
  final double canvasY;
  final String colorHex;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NpcsTableData({
    required this.id,
    required this.projectId,
    required this.name,
    required this.description,
    required this.canvasX,
    required this.canvasY,
    required this.colorHex,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['canvas_x'] = Variable<double>(canvasX);
    map['canvas_y'] = Variable<double>(canvasY);
    map['color_hex'] = Variable<String>(colorHex);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NpcsTableCompanion toCompanion(bool nullToAbsent) {
    return NpcsTableCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      description: Value(description),
      canvasX: Value(canvasX),
      canvasY: Value(canvasY),
      colorHex: Value(colorHex),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NpcsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NpcsTableData(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      canvasX: serializer.fromJson<double>(json['canvasX']),
      canvasY: serializer.fromJson<double>(json['canvasY']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'canvasX': serializer.toJson<double>(canvasX),
      'canvasY': serializer.toJson<double>(canvasY),
      'colorHex': serializer.toJson<String>(colorHex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NpcsTableData copyWith({
    String? id,
    String? projectId,
    String? name,
    String? description,
    double? canvasX,
    double? canvasY,
    String? colorHex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NpcsTableData(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    description: description ?? this.description,
    canvasX: canvasX ?? this.canvasX,
    canvasY: canvasY ?? this.canvasY,
    colorHex: colorHex ?? this.colorHex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NpcsTableData copyWithCompanion(NpcsTableCompanion data) {
    return NpcsTableData(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      canvasX: data.canvasX.present ? data.canvasX.value : this.canvasX,
      canvasY: data.canvasY.present ? data.canvasY.value : this.canvasY,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NpcsTableData(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('canvasX: $canvasX, ')
          ..write('canvasY: $canvasY, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    name,
    description,
    canvasX,
    canvasY,
    colorHex,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NpcsTableData &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.description == this.description &&
          other.canvasX == this.canvasX &&
          other.canvasY == this.canvasY &&
          other.colorHex == this.colorHex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NpcsTableCompanion extends UpdateCompanion<NpcsTableData> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<String> description;
  final Value<double> canvasX;
  final Value<double> canvasY;
  final Value<String> colorHex;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NpcsTableCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.canvasX = const Value.absent(),
    this.canvasY = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NpcsTableCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.canvasX = const Value.absent(),
    this.canvasY = const Value.absent(),
    this.colorHex = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<NpcsTableData> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? canvasX,
    Expression<double>? canvasY,
    Expression<String>? colorHex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (canvasX != null) 'canvas_x': canvasX,
      if (canvasY != null) 'canvas_y': canvasY,
      if (colorHex != null) 'color_hex': colorHex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NpcsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? name,
    Value<String>? description,
    Value<double>? canvasX,
    Value<double>? canvasY,
    Value<String>? colorHex,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NpcsTableCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      canvasX: canvasX ?? this.canvasX,
      canvasY: canvasY ?? this.canvasY,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (canvasX.present) {
      map['canvas_x'] = Variable<double>(canvasX.value);
    }
    if (canvasY.present) {
      map['canvas_y'] = Variable<double>(canvasY.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NpcsTableCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('canvasX: $canvasX, ')
          ..write('canvasY: $canvasY, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DialogueNodesTableTable extends DialogueNodesTable
    with TableInfo<$DialogueNodesTableTable, DialogueNodesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DialogueNodesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _npcIdMeta = const VerificationMeta('npcId');
  @override
  late final GeneratedColumn<String> npcId = GeneratedColumn<String>(
    'npc_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speakerNameMeta = const VerificationMeta(
    'speakerName',
  );
  @override
  late final GeneratedColumn<String> speakerName = GeneratedColumn<String>(
    'speaker_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dialogueTextMeta = const VerificationMeta(
    'dialogueText',
  );
  @override
  late final GeneratedColumn<String> dialogueText = GeneratedColumn<String>(
    'dialogue_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isStartMeta = const VerificationMeta(
    'isStart',
  );
  @override
  late final GeneratedColumn<bool> isStart = GeneratedColumn<bool>(
    'is_start',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_start" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _layoutXMeta = const VerificationMeta(
    'layoutX',
  );
  @override
  late final GeneratedColumn<double> layoutX = GeneratedColumn<double>(
    'layout_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _layoutYMeta = const VerificationMeta(
    'layoutY',
  );
  @override
  late final GeneratedColumn<double> layoutY = GeneratedColumn<double>(
    'layout_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    npcId,
    speakerName,
    dialogueText,
    isStart,
    layoutX,
    layoutY,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dialogue_nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<DialogueNodesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('npc_id')) {
      context.handle(
        _npcIdMeta,
        npcId.isAcceptableOrUnknown(data['npc_id']!, _npcIdMeta),
      );
    } else if (isInserting) {
      context.missing(_npcIdMeta);
    }
    if (data.containsKey('speaker_name')) {
      context.handle(
        _speakerNameMeta,
        speakerName.isAcceptableOrUnknown(
          data['speaker_name']!,
          _speakerNameMeta,
        ),
      );
    }
    if (data.containsKey('dialogue_text')) {
      context.handle(
        _dialogueTextMeta,
        dialogueText.isAcceptableOrUnknown(
          data['dialogue_text']!,
          _dialogueTextMeta,
        ),
      );
    }
    if (data.containsKey('is_start')) {
      context.handle(
        _isStartMeta,
        isStart.isAcceptableOrUnknown(data['is_start']!, _isStartMeta),
      );
    }
    if (data.containsKey('layout_x')) {
      context.handle(
        _layoutXMeta,
        layoutX.isAcceptableOrUnknown(data['layout_x']!, _layoutXMeta),
      );
    }
    if (data.containsKey('layout_y')) {
      context.handle(
        _layoutYMeta,
        layoutY.isAcceptableOrUnknown(data['layout_y']!, _layoutYMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DialogueNodesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DialogueNodesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      npcId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}npc_id'],
      )!,
      speakerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speaker_name'],
      )!,
      dialogueText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dialogue_text'],
      )!,
      isStart: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_start'],
      )!,
      layoutX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}layout_x'],
      )!,
      layoutY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}layout_y'],
      )!,
    );
  }

  @override
  $DialogueNodesTableTable createAlias(String alias) {
    return $DialogueNodesTableTable(attachedDatabase, alias);
  }
}

class DialogueNodesTableData extends DataClass
    implements Insertable<DialogueNodesTableData> {
  final String id;
  final String projectId;
  final String npcId;
  final String speakerName;
  final String dialogueText;
  final bool isStart;
  final double layoutX;
  final double layoutY;
  const DialogueNodesTableData({
    required this.id,
    required this.projectId,
    required this.npcId,
    required this.speakerName,
    required this.dialogueText,
    required this.isStart,
    required this.layoutX,
    required this.layoutY,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['npc_id'] = Variable<String>(npcId);
    map['speaker_name'] = Variable<String>(speakerName);
    map['dialogue_text'] = Variable<String>(dialogueText);
    map['is_start'] = Variable<bool>(isStart);
    map['layout_x'] = Variable<double>(layoutX);
    map['layout_y'] = Variable<double>(layoutY);
    return map;
  }

  DialogueNodesTableCompanion toCompanion(bool nullToAbsent) {
    return DialogueNodesTableCompanion(
      id: Value(id),
      projectId: Value(projectId),
      npcId: Value(npcId),
      speakerName: Value(speakerName),
      dialogueText: Value(dialogueText),
      isStart: Value(isStart),
      layoutX: Value(layoutX),
      layoutY: Value(layoutY),
    );
  }

  factory DialogueNodesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DialogueNodesTableData(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      npcId: serializer.fromJson<String>(json['npcId']),
      speakerName: serializer.fromJson<String>(json['speakerName']),
      dialogueText: serializer.fromJson<String>(json['dialogueText']),
      isStart: serializer.fromJson<bool>(json['isStart']),
      layoutX: serializer.fromJson<double>(json['layoutX']),
      layoutY: serializer.fromJson<double>(json['layoutY']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'npcId': serializer.toJson<String>(npcId),
      'speakerName': serializer.toJson<String>(speakerName),
      'dialogueText': serializer.toJson<String>(dialogueText),
      'isStart': serializer.toJson<bool>(isStart),
      'layoutX': serializer.toJson<double>(layoutX),
      'layoutY': serializer.toJson<double>(layoutY),
    };
  }

  DialogueNodesTableData copyWith({
    String? id,
    String? projectId,
    String? npcId,
    String? speakerName,
    String? dialogueText,
    bool? isStart,
    double? layoutX,
    double? layoutY,
  }) => DialogueNodesTableData(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    npcId: npcId ?? this.npcId,
    speakerName: speakerName ?? this.speakerName,
    dialogueText: dialogueText ?? this.dialogueText,
    isStart: isStart ?? this.isStart,
    layoutX: layoutX ?? this.layoutX,
    layoutY: layoutY ?? this.layoutY,
  );
  DialogueNodesTableData copyWithCompanion(DialogueNodesTableCompanion data) {
    return DialogueNodesTableData(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      npcId: data.npcId.present ? data.npcId.value : this.npcId,
      speakerName: data.speakerName.present
          ? data.speakerName.value
          : this.speakerName,
      dialogueText: data.dialogueText.present
          ? data.dialogueText.value
          : this.dialogueText,
      isStart: data.isStart.present ? data.isStart.value : this.isStart,
      layoutX: data.layoutX.present ? data.layoutX.value : this.layoutX,
      layoutY: data.layoutY.present ? data.layoutY.value : this.layoutY,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DialogueNodesTableData(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('npcId: $npcId, ')
          ..write('speakerName: $speakerName, ')
          ..write('dialogueText: $dialogueText, ')
          ..write('isStart: $isStart, ')
          ..write('layoutX: $layoutX, ')
          ..write('layoutY: $layoutY')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    npcId,
    speakerName,
    dialogueText,
    isStart,
    layoutX,
    layoutY,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DialogueNodesTableData &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.npcId == this.npcId &&
          other.speakerName == this.speakerName &&
          other.dialogueText == this.dialogueText &&
          other.isStart == this.isStart &&
          other.layoutX == this.layoutX &&
          other.layoutY == this.layoutY);
}

class DialogueNodesTableCompanion
    extends UpdateCompanion<DialogueNodesTableData> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> npcId;
  final Value<String> speakerName;
  final Value<String> dialogueText;
  final Value<bool> isStart;
  final Value<double> layoutX;
  final Value<double> layoutY;
  final Value<int> rowid;
  const DialogueNodesTableCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.npcId = const Value.absent(),
    this.speakerName = const Value.absent(),
    this.dialogueText = const Value.absent(),
    this.isStart = const Value.absent(),
    this.layoutX = const Value.absent(),
    this.layoutY = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DialogueNodesTableCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String npcId,
    this.speakerName = const Value.absent(),
    this.dialogueText = const Value.absent(),
    this.isStart = const Value.absent(),
    this.layoutX = const Value.absent(),
    this.layoutY = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       npcId = Value(npcId);
  static Insertable<DialogueNodesTableData> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? npcId,
    Expression<String>? speakerName,
    Expression<String>? dialogueText,
    Expression<bool>? isStart,
    Expression<double>? layoutX,
    Expression<double>? layoutY,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (npcId != null) 'npc_id': npcId,
      if (speakerName != null) 'speaker_name': speakerName,
      if (dialogueText != null) 'dialogue_text': dialogueText,
      if (isStart != null) 'is_start': isStart,
      if (layoutX != null) 'layout_x': layoutX,
      if (layoutY != null) 'layout_y': layoutY,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DialogueNodesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? npcId,
    Value<String>? speakerName,
    Value<String>? dialogueText,
    Value<bool>? isStart,
    Value<double>? layoutX,
    Value<double>? layoutY,
    Value<int>? rowid,
  }) {
    return DialogueNodesTableCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      npcId: npcId ?? this.npcId,
      speakerName: speakerName ?? this.speakerName,
      dialogueText: dialogueText ?? this.dialogueText,
      isStart: isStart ?? this.isStart,
      layoutX: layoutX ?? this.layoutX,
      layoutY: layoutY ?? this.layoutY,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (npcId.present) {
      map['npc_id'] = Variable<String>(npcId.value);
    }
    if (speakerName.present) {
      map['speaker_name'] = Variable<String>(speakerName.value);
    }
    if (dialogueText.present) {
      map['dialogue_text'] = Variable<String>(dialogueText.value);
    }
    if (isStart.present) {
      map['is_start'] = Variable<bool>(isStart.value);
    }
    if (layoutX.present) {
      map['layout_x'] = Variable<double>(layoutX.value);
    }
    if (layoutY.present) {
      map['layout_y'] = Variable<double>(layoutY.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DialogueNodesTableCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('npcId: $npcId, ')
          ..write('speakerName: $speakerName, ')
          ..write('dialogueText: $dialogueText, ')
          ..write('isStart: $isStart, ')
          ..write('layoutX: $layoutX, ')
          ..write('layoutY: $layoutY, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DialogueChoicesTableTable extends DialogueChoicesTable
    with TableInfo<$DialogueChoicesTableTable, DialogueChoicesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DialogueChoicesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fromNodeIdMeta = const VerificationMeta(
    'fromNodeId',
  );
  @override
  late final GeneratedColumn<String> fromNodeId = GeneratedColumn<String>(
    'from_node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toNodeIdMeta = const VerificationMeta(
    'toNodeId',
  );
  @override
  late final GeneratedColumn<String> toNodeId = GeneratedColumn<String>(
    'to_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _choiceTextMeta = const VerificationMeta(
    'choiceText',
  );
  @override
  late final GeneratedColumn<String> choiceText = GeneratedColumn<String>(
    'choice_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    fromNodeId,
    toNodeId,
    choiceText,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dialogue_choices';
  @override
  VerificationContext validateIntegrity(
    Insertable<DialogueChoicesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('from_node_id')) {
      context.handle(
        _fromNodeIdMeta,
        fromNodeId.isAcceptableOrUnknown(
          data['from_node_id']!,
          _fromNodeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromNodeIdMeta);
    }
    if (data.containsKey('to_node_id')) {
      context.handle(
        _toNodeIdMeta,
        toNodeId.isAcceptableOrUnknown(data['to_node_id']!, _toNodeIdMeta),
      );
    }
    if (data.containsKey('choice_text')) {
      context.handle(
        _choiceTextMeta,
        choiceText.isAcceptableOrUnknown(data['choice_text']!, _choiceTextMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DialogueChoicesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DialogueChoicesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      fromNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_node_id'],
      )!,
      toNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_node_id'],
      ),
      choiceText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choice_text'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DialogueChoicesTableTable createAlias(String alias) {
    return $DialogueChoicesTableTable(attachedDatabase, alias);
  }
}

class DialogueChoicesTableData extends DataClass
    implements Insertable<DialogueChoicesTableData> {
  final String id;
  final String projectId;
  final String fromNodeId;
  final String? toNodeId;
  final String choiceText;
  final int sortOrder;
  const DialogueChoicesTableData({
    required this.id,
    required this.projectId,
    required this.fromNodeId,
    this.toNodeId,
    required this.choiceText,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['from_node_id'] = Variable<String>(fromNodeId);
    if (!nullToAbsent || toNodeId != null) {
      map['to_node_id'] = Variable<String>(toNodeId);
    }
    map['choice_text'] = Variable<String>(choiceText);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DialogueChoicesTableCompanion toCompanion(bool nullToAbsent) {
    return DialogueChoicesTableCompanion(
      id: Value(id),
      projectId: Value(projectId),
      fromNodeId: Value(fromNodeId),
      toNodeId: toNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(toNodeId),
      choiceText: Value(choiceText),
      sortOrder: Value(sortOrder),
    );
  }

  factory DialogueChoicesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DialogueChoicesTableData(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      fromNodeId: serializer.fromJson<String>(json['fromNodeId']),
      toNodeId: serializer.fromJson<String?>(json['toNodeId']),
      choiceText: serializer.fromJson<String>(json['choiceText']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'fromNodeId': serializer.toJson<String>(fromNodeId),
      'toNodeId': serializer.toJson<String?>(toNodeId),
      'choiceText': serializer.toJson<String>(choiceText),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DialogueChoicesTableData copyWith({
    String? id,
    String? projectId,
    String? fromNodeId,
    Value<String?> toNodeId = const Value.absent(),
    String? choiceText,
    int? sortOrder,
  }) => DialogueChoicesTableData(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    fromNodeId: fromNodeId ?? this.fromNodeId,
    toNodeId: toNodeId.present ? toNodeId.value : this.toNodeId,
    choiceText: choiceText ?? this.choiceText,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  DialogueChoicesTableData copyWithCompanion(
    DialogueChoicesTableCompanion data,
  ) {
    return DialogueChoicesTableData(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      fromNodeId: data.fromNodeId.present
          ? data.fromNodeId.value
          : this.fromNodeId,
      toNodeId: data.toNodeId.present ? data.toNodeId.value : this.toNodeId,
      choiceText: data.choiceText.present
          ? data.choiceText.value
          : this.choiceText,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DialogueChoicesTableData(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('fromNodeId: $fromNodeId, ')
          ..write('toNodeId: $toNodeId, ')
          ..write('choiceText: $choiceText, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, fromNodeId, toNodeId, choiceText, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DialogueChoicesTableData &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.fromNodeId == this.fromNodeId &&
          other.toNodeId == this.toNodeId &&
          other.choiceText == this.choiceText &&
          other.sortOrder == this.sortOrder);
}

class DialogueChoicesTableCompanion
    extends UpdateCompanion<DialogueChoicesTableData> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> fromNodeId;
  final Value<String?> toNodeId;
  final Value<String> choiceText;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DialogueChoicesTableCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.fromNodeId = const Value.absent(),
    this.toNodeId = const Value.absent(),
    this.choiceText = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DialogueChoicesTableCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String fromNodeId,
    this.toNodeId = const Value.absent(),
    this.choiceText = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fromNodeId = Value(fromNodeId);
  static Insertable<DialogueChoicesTableData> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? fromNodeId,
    Expression<String>? toNodeId,
    Expression<String>? choiceText,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (fromNodeId != null) 'from_node_id': fromNodeId,
      if (toNodeId != null) 'to_node_id': toNodeId,
      if (choiceText != null) 'choice_text': choiceText,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DialogueChoicesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? fromNodeId,
    Value<String?>? toNodeId,
    Value<String>? choiceText,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DialogueChoicesTableCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      fromNodeId: fromNodeId ?? this.fromNodeId,
      toNodeId: toNodeId ?? this.toNodeId,
      choiceText: choiceText ?? this.choiceText,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (fromNodeId.present) {
      map['from_node_id'] = Variable<String>(fromNodeId.value);
    }
    if (toNodeId.present) {
      map['to_node_id'] = Variable<String>(toNodeId.value);
    }
    if (choiceText.present) {
      map['choice_text'] = Variable<String>(choiceText.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DialogueChoicesTableCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('fromNodeId: $fromNodeId, ')
          ..write('toNodeId: $toNodeId, ')
          ..write('choiceText: $choiceText, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RequirementFlagsTableTable extends RequirementFlagsTable
    with TableInfo<$RequirementFlagsTableTable, RequirementFlagsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequirementFlagsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _choiceIdMeta = const VerificationMeta(
    'choiceId',
  );
  @override
  late final GeneratedColumn<String> choiceId = GeneratedColumn<String>(
    'choice_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flagNameMeta = const VerificationMeta(
    'flagName',
  );
  @override
  late final GeneratedColumn<String> flagName = GeneratedColumn<String>(
    'flag_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiredValueMeta = const VerificationMeta(
    'requiredValue',
  );
  @override
  late final GeneratedColumn<bool> requiredValue = GeneratedColumn<bool>(
    'required_value',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("required_value" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    choiceId,
    flagName,
    requiredValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'requirement_flags';
  @override
  VerificationContext validateIntegrity(
    Insertable<RequirementFlagsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('choice_id')) {
      context.handle(
        _choiceIdMeta,
        choiceId.isAcceptableOrUnknown(data['choice_id']!, _choiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_choiceIdMeta);
    }
    if (data.containsKey('flag_name')) {
      context.handle(
        _flagNameMeta,
        flagName.isAcceptableOrUnknown(data['flag_name']!, _flagNameMeta),
      );
    } else if (isInserting) {
      context.missing(_flagNameMeta);
    }
    if (data.containsKey('required_value')) {
      context.handle(
        _requiredValueMeta,
        requiredValue.isAcceptableOrUnknown(
          data['required_value']!,
          _requiredValueMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RequirementFlagsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequirementFlagsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      choiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choice_id'],
      )!,
      flagName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag_name'],
      )!,
      requiredValue: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}required_value'],
      )!,
    );
  }

  @override
  $RequirementFlagsTableTable createAlias(String alias) {
    return $RequirementFlagsTableTable(attachedDatabase, alias);
  }
}

class RequirementFlagsTableData extends DataClass
    implements Insertable<RequirementFlagsTableData> {
  final String id;
  final String projectId;
  final String choiceId;
  final String flagName;
  final bool requiredValue;
  const RequirementFlagsTableData({
    required this.id,
    required this.projectId,
    required this.choiceId,
    required this.flagName,
    required this.requiredValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['choice_id'] = Variable<String>(choiceId);
    map['flag_name'] = Variable<String>(flagName);
    map['required_value'] = Variable<bool>(requiredValue);
    return map;
  }

  RequirementFlagsTableCompanion toCompanion(bool nullToAbsent) {
    return RequirementFlagsTableCompanion(
      id: Value(id),
      projectId: Value(projectId),
      choiceId: Value(choiceId),
      flagName: Value(flagName),
      requiredValue: Value(requiredValue),
    );
  }

  factory RequirementFlagsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequirementFlagsTableData(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      choiceId: serializer.fromJson<String>(json['choiceId']),
      flagName: serializer.fromJson<String>(json['flagName']),
      requiredValue: serializer.fromJson<bool>(json['requiredValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'choiceId': serializer.toJson<String>(choiceId),
      'flagName': serializer.toJson<String>(flagName),
      'requiredValue': serializer.toJson<bool>(requiredValue),
    };
  }

  RequirementFlagsTableData copyWith({
    String? id,
    String? projectId,
    String? choiceId,
    String? flagName,
    bool? requiredValue,
  }) => RequirementFlagsTableData(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    choiceId: choiceId ?? this.choiceId,
    flagName: flagName ?? this.flagName,
    requiredValue: requiredValue ?? this.requiredValue,
  );
  RequirementFlagsTableData copyWithCompanion(
    RequirementFlagsTableCompanion data,
  ) {
    return RequirementFlagsTableData(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      choiceId: data.choiceId.present ? data.choiceId.value : this.choiceId,
      flagName: data.flagName.present ? data.flagName.value : this.flagName,
      requiredValue: data.requiredValue.present
          ? data.requiredValue.value
          : this.requiredValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequirementFlagsTableData(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('choiceId: $choiceId, ')
          ..write('flagName: $flagName, ')
          ..write('requiredValue: $requiredValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, choiceId, flagName, requiredValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequirementFlagsTableData &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.choiceId == this.choiceId &&
          other.flagName == this.flagName &&
          other.requiredValue == this.requiredValue);
}

class RequirementFlagsTableCompanion
    extends UpdateCompanion<RequirementFlagsTableData> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> choiceId;
  final Value<String> flagName;
  final Value<bool> requiredValue;
  final Value<int> rowid;
  const RequirementFlagsTableCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.choiceId = const Value.absent(),
    this.flagName = const Value.absent(),
    this.requiredValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RequirementFlagsTableCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String choiceId,
    required String flagName,
    this.requiredValue = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       choiceId = Value(choiceId),
       flagName = Value(flagName);
  static Insertable<RequirementFlagsTableData> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? choiceId,
    Expression<String>? flagName,
    Expression<bool>? requiredValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (choiceId != null) 'choice_id': choiceId,
      if (flagName != null) 'flag_name': flagName,
      if (requiredValue != null) 'required_value': requiredValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RequirementFlagsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? choiceId,
    Value<String>? flagName,
    Value<bool>? requiredValue,
    Value<int>? rowid,
  }) {
    return RequirementFlagsTableCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      choiceId: choiceId ?? this.choiceId,
      flagName: flagName ?? this.flagName,
      requiredValue: requiredValue ?? this.requiredValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (choiceId.present) {
      map['choice_id'] = Variable<String>(choiceId.value);
    }
    if (flagName.present) {
      map['flag_name'] = Variable<String>(flagName.value);
    }
    if (requiredValue.present) {
      map['required_value'] = Variable<bool>(requiredValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequirementFlagsTableCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('choiceId: $choiceId, ')
          ..write('flagName: $flagName, ')
          ..write('requiredValue: $requiredValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardFlagsTableTable extends RewardFlagsTable
    with TableInfo<$RewardFlagsTableTable, RewardFlagsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardFlagsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _nodeIdMeta = const VerificationMeta('nodeId');
  @override
  late final GeneratedColumn<String> nodeId = GeneratedColumn<String>(
    'node_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flagNameMeta = const VerificationMeta(
    'flagName',
  );
  @override
  late final GeneratedColumn<String> flagName = GeneratedColumn<String>(
    'flag_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setValueMeta = const VerificationMeta(
    'setValue',
  );
  @override
  late final GeneratedColumn<bool> setValue = GeneratedColumn<bool>(
    'set_value',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("set_value" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    nodeId,
    flagName,
    setValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_flags';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardFlagsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('node_id')) {
      context.handle(
        _nodeIdMeta,
        nodeId.isAcceptableOrUnknown(data['node_id']!, _nodeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nodeIdMeta);
    }
    if (data.containsKey('flag_name')) {
      context.handle(
        _flagNameMeta,
        flagName.isAcceptableOrUnknown(data['flag_name']!, _flagNameMeta),
      );
    } else if (isInserting) {
      context.missing(_flagNameMeta);
    }
    if (data.containsKey('set_value')) {
      context.handle(
        _setValueMeta,
        setValue.isAcceptableOrUnknown(data['set_value']!, _setValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RewardFlagsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardFlagsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      nodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}node_id'],
      )!,
      flagName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag_name'],
      )!,
      setValue: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}set_value'],
      )!,
    );
  }

  @override
  $RewardFlagsTableTable createAlias(String alias) {
    return $RewardFlagsTableTable(attachedDatabase, alias);
  }
}

class RewardFlagsTableData extends DataClass
    implements Insertable<RewardFlagsTableData> {
  final String id;
  final String projectId;
  final String nodeId;
  final String flagName;
  final bool setValue;
  const RewardFlagsTableData({
    required this.id,
    required this.projectId,
    required this.nodeId,
    required this.flagName,
    required this.setValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['node_id'] = Variable<String>(nodeId);
    map['flag_name'] = Variable<String>(flagName);
    map['set_value'] = Variable<bool>(setValue);
    return map;
  }

  RewardFlagsTableCompanion toCompanion(bool nullToAbsent) {
    return RewardFlagsTableCompanion(
      id: Value(id),
      projectId: Value(projectId),
      nodeId: Value(nodeId),
      flagName: Value(flagName),
      setValue: Value(setValue),
    );
  }

  factory RewardFlagsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardFlagsTableData(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      nodeId: serializer.fromJson<String>(json['nodeId']),
      flagName: serializer.fromJson<String>(json['flagName']),
      setValue: serializer.fromJson<bool>(json['setValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'nodeId': serializer.toJson<String>(nodeId),
      'flagName': serializer.toJson<String>(flagName),
      'setValue': serializer.toJson<bool>(setValue),
    };
  }

  RewardFlagsTableData copyWith({
    String? id,
    String? projectId,
    String? nodeId,
    String? flagName,
    bool? setValue,
  }) => RewardFlagsTableData(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    nodeId: nodeId ?? this.nodeId,
    flagName: flagName ?? this.flagName,
    setValue: setValue ?? this.setValue,
  );
  RewardFlagsTableData copyWithCompanion(RewardFlagsTableCompanion data) {
    return RewardFlagsTableData(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      nodeId: data.nodeId.present ? data.nodeId.value : this.nodeId,
      flagName: data.flagName.present ? data.flagName.value : this.flagName,
      setValue: data.setValue.present ? data.setValue.value : this.setValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardFlagsTableData(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('nodeId: $nodeId, ')
          ..write('flagName: $flagName, ')
          ..write('setValue: $setValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, nodeId, flagName, setValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardFlagsTableData &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.nodeId == this.nodeId &&
          other.flagName == this.flagName &&
          other.setValue == this.setValue);
}

class RewardFlagsTableCompanion extends UpdateCompanion<RewardFlagsTableData> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> nodeId;
  final Value<String> flagName;
  final Value<bool> setValue;
  final Value<int> rowid;
  const RewardFlagsTableCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.nodeId = const Value.absent(),
    this.flagName = const Value.absent(),
    this.setValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardFlagsTableCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String nodeId,
    required String flagName,
    this.setValue = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nodeId = Value(nodeId),
       flagName = Value(flagName);
  static Insertable<RewardFlagsTableData> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? nodeId,
    Expression<String>? flagName,
    Expression<bool>? setValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (nodeId != null) 'node_id': nodeId,
      if (flagName != null) 'flag_name': flagName,
      if (setValue != null) 'set_value': setValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardFlagsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? nodeId,
    Value<String>? flagName,
    Value<bool>? setValue,
    Value<int>? rowid,
  }) {
    return RewardFlagsTableCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      nodeId: nodeId ?? this.nodeId,
      flagName: flagName ?? this.flagName,
      setValue: setValue ?? this.setValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (nodeId.present) {
      map['node_id'] = Variable<String>(nodeId.value);
    }
    if (flagName.present) {
      map['flag_name'] = Variable<String>(flagName.value);
    }
    if (setValue.present) {
      map['set_value'] = Variable<bool>(setValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardFlagsTableCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('nodeId: $nodeId, ')
          ..write('flagName: $flagName, ')
          ..write('setValue: $setValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTableTable projectsTable = $ProjectsTableTable(this);
  late final $NpcsTableTable npcsTable = $NpcsTableTable(this);
  late final $DialogueNodesTableTable dialogueNodesTable =
      $DialogueNodesTableTable(this);
  late final $DialogueChoicesTableTable dialogueChoicesTable =
      $DialogueChoicesTableTable(this);
  late final $RequirementFlagsTableTable requirementFlagsTable =
      $RequirementFlagsTableTable(this);
  late final $RewardFlagsTableTable rewardFlagsTable = $RewardFlagsTableTable(
    this,
  );
  late final ProjectDao projectDao = ProjectDao(this as AppDatabase);
  late final NpcDao npcDao = NpcDao(this as AppDatabase);
  late final DialogueNodeDao dialogueNodeDao = DialogueNodeDao(
    this as AppDatabase,
  );
  late final DialogueChoiceDao dialogueChoiceDao = DialogueChoiceDao(
    this as AppDatabase,
  );
  late final RequirementFlagDao requirementFlagDao = RequirementFlagDao(
    this as AppDatabase,
  );
  late final RewardFlagDao rewardFlagDao = RewardFlagDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projectsTable,
    npcsTable,
    dialogueNodesTable,
    dialogueChoicesTable,
    requirementFlagsTable,
    rewardFlagsTable,
  ];
}

typedef $$ProjectsTableTableCreateCompanionBuilder =
    ProjectsTableCompanion Function({
      required String id,
      required String name,
      Value<String> description,
      Value<String?> filePath,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableTableUpdateCompanionBuilder =
    ProjectsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String?> filePath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ProjectsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTableTable> {
  $$ProjectsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProjectsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTableTable,
          ProjectsTableData,
          $$ProjectsTableTableFilterComposer,
          $$ProjectsTableTableOrderingComposer,
          $$ProjectsTableTableAnnotationComposer,
          $$ProjectsTableTableCreateCompanionBuilder,
          $$ProjectsTableTableUpdateCompanionBuilder,
          (
            ProjectsTableData,
            BaseReferences<
              _$AppDatabase,
              $ProjectsTableTable,
              ProjectsTableData
            >,
          ),
          ProjectsTableData,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableTableManager(_$AppDatabase db, $ProjectsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsTableCompanion(
                id: id,
                name: name,
                description: description,
                filePath: filePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> description = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProjectsTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                filePath: filePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTableTable,
      ProjectsTableData,
      $$ProjectsTableTableFilterComposer,
      $$ProjectsTableTableOrderingComposer,
      $$ProjectsTableTableAnnotationComposer,
      $$ProjectsTableTableCreateCompanionBuilder,
      $$ProjectsTableTableUpdateCompanionBuilder,
      (
        ProjectsTableData,
        BaseReferences<_$AppDatabase, $ProjectsTableTable, ProjectsTableData>,
      ),
      ProjectsTableData,
      PrefetchHooks Function()
    >;
typedef $$NpcsTableTableCreateCompanionBuilder =
    NpcsTableCompanion Function({
      required String id,
      Value<String> projectId,
      required String name,
      Value<String> description,
      Value<double> canvasX,
      Value<double> canvasY,
      Value<String> colorHex,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$NpcsTableTableUpdateCompanionBuilder =
    NpcsTableCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> name,
      Value<String> description,
      Value<double> canvasX,
      Value<double> canvasY,
      Value<String> colorHex,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$NpcsTableTableFilterComposer
    extends Composer<_$AppDatabase, $NpcsTableTable> {
  $$NpcsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get canvasX => $composableBuilder(
    column: $table.canvasX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get canvasY => $composableBuilder(
    column: $table.canvasY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NpcsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NpcsTableTable> {
  $$NpcsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get canvasX => $composableBuilder(
    column: $table.canvasX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get canvasY => $composableBuilder(
    column: $table.canvasY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NpcsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NpcsTableTable> {
  $$NpcsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get canvasX =>
      $composableBuilder(column: $table.canvasX, builder: (column) => column);

  GeneratedColumn<double> get canvasY =>
      $composableBuilder(column: $table.canvasY, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NpcsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NpcsTableTable,
          NpcsTableData,
          $$NpcsTableTableFilterComposer,
          $$NpcsTableTableOrderingComposer,
          $$NpcsTableTableAnnotationComposer,
          $$NpcsTableTableCreateCompanionBuilder,
          $$NpcsTableTableUpdateCompanionBuilder,
          (
            NpcsTableData,
            BaseReferences<_$AppDatabase, $NpcsTableTable, NpcsTableData>,
          ),
          NpcsTableData,
          PrefetchHooks Function()
        > {
  $$NpcsTableTableTableManager(_$AppDatabase db, $NpcsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NpcsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NpcsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NpcsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> canvasX = const Value.absent(),
                Value<double> canvasY = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NpcsTableCompanion(
                id: id,
                projectId: projectId,
                name: name,
                description: description,
                canvasX: canvasX,
                canvasY: canvasY,
                colorHex: colorHex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> projectId = const Value.absent(),
                required String name,
                Value<String> description = const Value.absent(),
                Value<double> canvasX = const Value.absent(),
                Value<double> canvasY = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => NpcsTableCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                description: description,
                canvasX: canvasX,
                canvasY: canvasY,
                colorHex: colorHex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NpcsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NpcsTableTable,
      NpcsTableData,
      $$NpcsTableTableFilterComposer,
      $$NpcsTableTableOrderingComposer,
      $$NpcsTableTableAnnotationComposer,
      $$NpcsTableTableCreateCompanionBuilder,
      $$NpcsTableTableUpdateCompanionBuilder,
      (
        NpcsTableData,
        BaseReferences<_$AppDatabase, $NpcsTableTable, NpcsTableData>,
      ),
      NpcsTableData,
      PrefetchHooks Function()
    >;
typedef $$DialogueNodesTableTableCreateCompanionBuilder =
    DialogueNodesTableCompanion Function({
      required String id,
      Value<String> projectId,
      required String npcId,
      Value<String> speakerName,
      Value<String> dialogueText,
      Value<bool> isStart,
      Value<double> layoutX,
      Value<double> layoutY,
      Value<int> rowid,
    });
typedef $$DialogueNodesTableTableUpdateCompanionBuilder =
    DialogueNodesTableCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> npcId,
      Value<String> speakerName,
      Value<String> dialogueText,
      Value<bool> isStart,
      Value<double> layoutX,
      Value<double> layoutY,
      Value<int> rowid,
    });

class $$DialogueNodesTableTableFilterComposer
    extends Composer<_$AppDatabase, $DialogueNodesTableTable> {
  $$DialogueNodesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get npcId => $composableBuilder(
    column: $table.npcId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speakerName => $composableBuilder(
    column: $table.speakerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dialogueText => $composableBuilder(
    column: $table.dialogueText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStart => $composableBuilder(
    column: $table.isStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get layoutX => $composableBuilder(
    column: $table.layoutX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get layoutY => $composableBuilder(
    column: $table.layoutY,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DialogueNodesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DialogueNodesTableTable> {
  $$DialogueNodesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get npcId => $composableBuilder(
    column: $table.npcId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speakerName => $composableBuilder(
    column: $table.speakerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dialogueText => $composableBuilder(
    column: $table.dialogueText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStart => $composableBuilder(
    column: $table.isStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get layoutX => $composableBuilder(
    column: $table.layoutX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get layoutY => $composableBuilder(
    column: $table.layoutY,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DialogueNodesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DialogueNodesTableTable> {
  $$DialogueNodesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get npcId =>
      $composableBuilder(column: $table.npcId, builder: (column) => column);

  GeneratedColumn<String> get speakerName => $composableBuilder(
    column: $table.speakerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dialogueText => $composableBuilder(
    column: $table.dialogueText,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStart =>
      $composableBuilder(column: $table.isStart, builder: (column) => column);

  GeneratedColumn<double> get layoutX =>
      $composableBuilder(column: $table.layoutX, builder: (column) => column);

  GeneratedColumn<double> get layoutY =>
      $composableBuilder(column: $table.layoutY, builder: (column) => column);
}

class $$DialogueNodesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DialogueNodesTableTable,
          DialogueNodesTableData,
          $$DialogueNodesTableTableFilterComposer,
          $$DialogueNodesTableTableOrderingComposer,
          $$DialogueNodesTableTableAnnotationComposer,
          $$DialogueNodesTableTableCreateCompanionBuilder,
          $$DialogueNodesTableTableUpdateCompanionBuilder,
          (
            DialogueNodesTableData,
            BaseReferences<
              _$AppDatabase,
              $DialogueNodesTableTable,
              DialogueNodesTableData
            >,
          ),
          DialogueNodesTableData,
          PrefetchHooks Function()
        > {
  $$DialogueNodesTableTableTableManager(
    _$AppDatabase db,
    $DialogueNodesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DialogueNodesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DialogueNodesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DialogueNodesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> npcId = const Value.absent(),
                Value<String> speakerName = const Value.absent(),
                Value<String> dialogueText = const Value.absent(),
                Value<bool> isStart = const Value.absent(),
                Value<double> layoutX = const Value.absent(),
                Value<double> layoutY = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DialogueNodesTableCompanion(
                id: id,
                projectId: projectId,
                npcId: npcId,
                speakerName: speakerName,
                dialogueText: dialogueText,
                isStart: isStart,
                layoutX: layoutX,
                layoutY: layoutY,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> projectId = const Value.absent(),
                required String npcId,
                Value<String> speakerName = const Value.absent(),
                Value<String> dialogueText = const Value.absent(),
                Value<bool> isStart = const Value.absent(),
                Value<double> layoutX = const Value.absent(),
                Value<double> layoutY = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DialogueNodesTableCompanion.insert(
                id: id,
                projectId: projectId,
                npcId: npcId,
                speakerName: speakerName,
                dialogueText: dialogueText,
                isStart: isStart,
                layoutX: layoutX,
                layoutY: layoutY,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DialogueNodesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DialogueNodesTableTable,
      DialogueNodesTableData,
      $$DialogueNodesTableTableFilterComposer,
      $$DialogueNodesTableTableOrderingComposer,
      $$DialogueNodesTableTableAnnotationComposer,
      $$DialogueNodesTableTableCreateCompanionBuilder,
      $$DialogueNodesTableTableUpdateCompanionBuilder,
      (
        DialogueNodesTableData,
        BaseReferences<
          _$AppDatabase,
          $DialogueNodesTableTable,
          DialogueNodesTableData
        >,
      ),
      DialogueNodesTableData,
      PrefetchHooks Function()
    >;
typedef $$DialogueChoicesTableTableCreateCompanionBuilder =
    DialogueChoicesTableCompanion Function({
      required String id,
      Value<String> projectId,
      required String fromNodeId,
      Value<String?> toNodeId,
      Value<String> choiceText,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$DialogueChoicesTableTableUpdateCompanionBuilder =
    DialogueChoicesTableCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> fromNodeId,
      Value<String?> toNodeId,
      Value<String> choiceText,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$DialogueChoicesTableTableFilterComposer
    extends Composer<_$AppDatabase, $DialogueChoicesTableTable> {
  $$DialogueChoicesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromNodeId => $composableBuilder(
    column: $table.fromNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toNodeId => $composableBuilder(
    column: $table.toNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choiceText => $composableBuilder(
    column: $table.choiceText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DialogueChoicesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DialogueChoicesTableTable> {
  $$DialogueChoicesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromNodeId => $composableBuilder(
    column: $table.fromNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toNodeId => $composableBuilder(
    column: $table.toNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choiceText => $composableBuilder(
    column: $table.choiceText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DialogueChoicesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DialogueChoicesTableTable> {
  $$DialogueChoicesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get fromNodeId => $composableBuilder(
    column: $table.fromNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toNodeId =>
      $composableBuilder(column: $table.toNodeId, builder: (column) => column);

  GeneratedColumn<String> get choiceText => $composableBuilder(
    column: $table.choiceText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DialogueChoicesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DialogueChoicesTableTable,
          DialogueChoicesTableData,
          $$DialogueChoicesTableTableFilterComposer,
          $$DialogueChoicesTableTableOrderingComposer,
          $$DialogueChoicesTableTableAnnotationComposer,
          $$DialogueChoicesTableTableCreateCompanionBuilder,
          $$DialogueChoicesTableTableUpdateCompanionBuilder,
          (
            DialogueChoicesTableData,
            BaseReferences<
              _$AppDatabase,
              $DialogueChoicesTableTable,
              DialogueChoicesTableData
            >,
          ),
          DialogueChoicesTableData,
          PrefetchHooks Function()
        > {
  $$DialogueChoicesTableTableTableManager(
    _$AppDatabase db,
    $DialogueChoicesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DialogueChoicesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DialogueChoicesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DialogueChoicesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> fromNodeId = const Value.absent(),
                Value<String?> toNodeId = const Value.absent(),
                Value<String> choiceText = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DialogueChoicesTableCompanion(
                id: id,
                projectId: projectId,
                fromNodeId: fromNodeId,
                toNodeId: toNodeId,
                choiceText: choiceText,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> projectId = const Value.absent(),
                required String fromNodeId,
                Value<String?> toNodeId = const Value.absent(),
                Value<String> choiceText = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DialogueChoicesTableCompanion.insert(
                id: id,
                projectId: projectId,
                fromNodeId: fromNodeId,
                toNodeId: toNodeId,
                choiceText: choiceText,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DialogueChoicesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DialogueChoicesTableTable,
      DialogueChoicesTableData,
      $$DialogueChoicesTableTableFilterComposer,
      $$DialogueChoicesTableTableOrderingComposer,
      $$DialogueChoicesTableTableAnnotationComposer,
      $$DialogueChoicesTableTableCreateCompanionBuilder,
      $$DialogueChoicesTableTableUpdateCompanionBuilder,
      (
        DialogueChoicesTableData,
        BaseReferences<
          _$AppDatabase,
          $DialogueChoicesTableTable,
          DialogueChoicesTableData
        >,
      ),
      DialogueChoicesTableData,
      PrefetchHooks Function()
    >;
typedef $$RequirementFlagsTableTableCreateCompanionBuilder =
    RequirementFlagsTableCompanion Function({
      required String id,
      Value<String> projectId,
      required String choiceId,
      required String flagName,
      Value<bool> requiredValue,
      Value<int> rowid,
    });
typedef $$RequirementFlagsTableTableUpdateCompanionBuilder =
    RequirementFlagsTableCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> choiceId,
      Value<String> flagName,
      Value<bool> requiredValue,
      Value<int> rowid,
    });

class $$RequirementFlagsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RequirementFlagsTableTable> {
  $$RequirementFlagsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choiceId => $composableBuilder(
    column: $table.choiceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flagName => $composableBuilder(
    column: $table.flagName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiredValue => $composableBuilder(
    column: $table.requiredValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RequirementFlagsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RequirementFlagsTableTable> {
  $$RequirementFlagsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choiceId => $composableBuilder(
    column: $table.choiceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flagName => $composableBuilder(
    column: $table.flagName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiredValue => $composableBuilder(
    column: $table.requiredValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RequirementFlagsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequirementFlagsTableTable> {
  $$RequirementFlagsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get choiceId =>
      $composableBuilder(column: $table.choiceId, builder: (column) => column);

  GeneratedColumn<String> get flagName =>
      $composableBuilder(column: $table.flagName, builder: (column) => column);

  GeneratedColumn<bool> get requiredValue => $composableBuilder(
    column: $table.requiredValue,
    builder: (column) => column,
  );
}

class $$RequirementFlagsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RequirementFlagsTableTable,
          RequirementFlagsTableData,
          $$RequirementFlagsTableTableFilterComposer,
          $$RequirementFlagsTableTableOrderingComposer,
          $$RequirementFlagsTableTableAnnotationComposer,
          $$RequirementFlagsTableTableCreateCompanionBuilder,
          $$RequirementFlagsTableTableUpdateCompanionBuilder,
          (
            RequirementFlagsTableData,
            BaseReferences<
              _$AppDatabase,
              $RequirementFlagsTableTable,
              RequirementFlagsTableData
            >,
          ),
          RequirementFlagsTableData,
          PrefetchHooks Function()
        > {
  $$RequirementFlagsTableTableTableManager(
    _$AppDatabase db,
    $RequirementFlagsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequirementFlagsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RequirementFlagsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RequirementFlagsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> choiceId = const Value.absent(),
                Value<String> flagName = const Value.absent(),
                Value<bool> requiredValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequirementFlagsTableCompanion(
                id: id,
                projectId: projectId,
                choiceId: choiceId,
                flagName: flagName,
                requiredValue: requiredValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> projectId = const Value.absent(),
                required String choiceId,
                required String flagName,
                Value<bool> requiredValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequirementFlagsTableCompanion.insert(
                id: id,
                projectId: projectId,
                choiceId: choiceId,
                flagName: flagName,
                requiredValue: requiredValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RequirementFlagsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RequirementFlagsTableTable,
      RequirementFlagsTableData,
      $$RequirementFlagsTableTableFilterComposer,
      $$RequirementFlagsTableTableOrderingComposer,
      $$RequirementFlagsTableTableAnnotationComposer,
      $$RequirementFlagsTableTableCreateCompanionBuilder,
      $$RequirementFlagsTableTableUpdateCompanionBuilder,
      (
        RequirementFlagsTableData,
        BaseReferences<
          _$AppDatabase,
          $RequirementFlagsTableTable,
          RequirementFlagsTableData
        >,
      ),
      RequirementFlagsTableData,
      PrefetchHooks Function()
    >;
typedef $$RewardFlagsTableTableCreateCompanionBuilder =
    RewardFlagsTableCompanion Function({
      required String id,
      Value<String> projectId,
      required String nodeId,
      required String flagName,
      Value<bool> setValue,
      Value<int> rowid,
    });
typedef $$RewardFlagsTableTableUpdateCompanionBuilder =
    RewardFlagsTableCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> nodeId,
      Value<String> flagName,
      Value<bool> setValue,
      Value<int> rowid,
    });

class $$RewardFlagsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RewardFlagsTableTable> {
  $$RewardFlagsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flagName => $composableBuilder(
    column: $table.flagName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get setValue => $composableBuilder(
    column: $table.setValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RewardFlagsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardFlagsTableTable> {
  $$RewardFlagsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nodeId => $composableBuilder(
    column: $table.nodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flagName => $composableBuilder(
    column: $table.flagName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get setValue => $composableBuilder(
    column: $table.setValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardFlagsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardFlagsTableTable> {
  $$RewardFlagsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get nodeId =>
      $composableBuilder(column: $table.nodeId, builder: (column) => column);

  GeneratedColumn<String> get flagName =>
      $composableBuilder(column: $table.flagName, builder: (column) => column);

  GeneratedColumn<bool> get setValue =>
      $composableBuilder(column: $table.setValue, builder: (column) => column);
}

class $$RewardFlagsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardFlagsTableTable,
          RewardFlagsTableData,
          $$RewardFlagsTableTableFilterComposer,
          $$RewardFlagsTableTableOrderingComposer,
          $$RewardFlagsTableTableAnnotationComposer,
          $$RewardFlagsTableTableCreateCompanionBuilder,
          $$RewardFlagsTableTableUpdateCompanionBuilder,
          (
            RewardFlagsTableData,
            BaseReferences<
              _$AppDatabase,
              $RewardFlagsTableTable,
              RewardFlagsTableData
            >,
          ),
          RewardFlagsTableData,
          PrefetchHooks Function()
        > {
  $$RewardFlagsTableTableTableManager(
    _$AppDatabase db,
    $RewardFlagsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardFlagsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardFlagsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardFlagsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> nodeId = const Value.absent(),
                Value<String> flagName = const Value.absent(),
                Value<bool> setValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardFlagsTableCompanion(
                id: id,
                projectId: projectId,
                nodeId: nodeId,
                flagName: flagName,
                setValue: setValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> projectId = const Value.absent(),
                required String nodeId,
                required String flagName,
                Value<bool> setValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardFlagsTableCompanion.insert(
                id: id,
                projectId: projectId,
                nodeId: nodeId,
                flagName: flagName,
                setValue: setValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RewardFlagsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardFlagsTableTable,
      RewardFlagsTableData,
      $$RewardFlagsTableTableFilterComposer,
      $$RewardFlagsTableTableOrderingComposer,
      $$RewardFlagsTableTableAnnotationComposer,
      $$RewardFlagsTableTableCreateCompanionBuilder,
      $$RewardFlagsTableTableUpdateCompanionBuilder,
      (
        RewardFlagsTableData,
        BaseReferences<
          _$AppDatabase,
          $RewardFlagsTableTable,
          RewardFlagsTableData
        >,
      ),
      RewardFlagsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableTableManager get projectsTable =>
      $$ProjectsTableTableTableManager(_db, _db.projectsTable);
  $$NpcsTableTableTableManager get npcsTable =>
      $$NpcsTableTableTableManager(_db, _db.npcsTable);
  $$DialogueNodesTableTableTableManager get dialogueNodesTable =>
      $$DialogueNodesTableTableTableManager(_db, _db.dialogueNodesTable);
  $$DialogueChoicesTableTableTableManager get dialogueChoicesTable =>
      $$DialogueChoicesTableTableTableManager(_db, _db.dialogueChoicesTable);
  $$RequirementFlagsTableTableTableManager get requirementFlagsTable =>
      $$RequirementFlagsTableTableTableManager(_db, _db.requirementFlagsTable);
  $$RewardFlagsTableTableTableManager get rewardFlagsTable =>
      $$RewardFlagsTableTableTableManager(_db, _db.rewardFlagsTable);
}
