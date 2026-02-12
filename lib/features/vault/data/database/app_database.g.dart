// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('folder'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    iconName,
    colorValue,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
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
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
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
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
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
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final String iconName;
  final int colorValue;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon_name'] = Variable<String>(iconName);
    map['color_value'] = Variable<int>(colorValue);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      iconName: Value(iconName),
      colorValue: Value(colorValue),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
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
      'iconName': serializer.toJson<String>(iconName),
      'colorValue': serializer.toJson<int>(colorValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? iconName,
    int? colorValue,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    iconName: iconName ?? this.iconName,
    colorValue: colorValue ?? this.colorValue,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    iconName,
    colorValue,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconName == this.iconName &&
          other.colorValue == this.colorValue &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> iconName;
  final Value<int> colorValue;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.iconName = const Value.absent(),
    required int colorValue,
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorValue = Value(colorValue),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? iconName,
    Expression<int>? colorValue,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconName != null) 'icon_name': iconName,
      if (colorValue != null) 'color_value': colorValue,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? iconName,
    Value<int>? colorValue,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
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
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PasswordEntriesTable extends PasswordEntries
    with TableInfo<$PasswordEntriesTable, PasswordEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PasswordEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedPasswordMeta = const VerificationMeta(
    'encryptedPassword',
  );
  @override
  late final GeneratedColumn<String> encryptedPassword =
      GeneratedColumn<String>(
        'encrypted_password',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _encryptedNotesMeta = const VerificationMeta(
    'encryptedNotes',
  );
  @override
  late final GeneratedColumn<String> encryptedNotes = GeneratedColumn<String>(
    'encrypted_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _faviconUrlMeta = const VerificationMeta(
    'faviconUrl',
  );
  @override
  late final GeneratedColumn<String> faviconUrl = GeneratedColumn<String>(
    'favicon_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customFieldsMeta = const VerificationMeta(
    'customFields',
  );
  @override
  late final GeneratedColumn<String> customFields = GeneratedColumn<String>(
    'custom_fields',
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
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    username,
    encryptedPassword,
    url,
    encryptedNotes,
    categoryId,
    isFavorite,
    faviconUrl,
    customFields,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'password_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PasswordEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('encrypted_password')) {
      context.handle(
        _encryptedPasswordMeta,
        encryptedPassword.isAcceptableOrUnknown(
          data['encrypted_password']!,
          _encryptedPasswordMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedPasswordMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('encrypted_notes')) {
      context.handle(
        _encryptedNotesMeta,
        encryptedNotes.isAcceptableOrUnknown(
          data['encrypted_notes']!,
          _encryptedNotesMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('favicon_url')) {
      context.handle(
        _faviconUrlMeta,
        faviconUrl.isAcceptableOrUnknown(data['favicon_url']!, _faviconUrlMeta),
      );
    }
    if (data.containsKey('custom_fields')) {
      context.handle(
        _customFieldsMeta,
        customFields.isAcceptableOrUnknown(
          data['custom_fields']!,
          _customFieldsMeta,
        ),
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
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PasswordEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PasswordEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      encryptedPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_password'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      encryptedNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_notes'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      faviconUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favicon_url'],
      ),
      customFields: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_fields'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PasswordEntriesTable createAlias(String alias) {
    return $PasswordEntriesTable(attachedDatabase, alias);
  }
}

class PasswordEntry extends DataClass implements Insertable<PasswordEntry> {
  final String id;
  final String title;
  final String username;
  final String encryptedPassword;
  final String? url;
  final String? encryptedNotes;
  final String categoryId;
  final bool isFavorite;
  final String? faviconUrl;
  final String? customFields;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const PasswordEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.encryptedPassword,
    this.url,
    this.encryptedNotes,
    required this.categoryId,
    required this.isFavorite,
    this.faviconUrl,
    this.customFields,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['username'] = Variable<String>(username);
    map['encrypted_password'] = Variable<String>(encryptedPassword);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || encryptedNotes != null) {
      map['encrypted_notes'] = Variable<String>(encryptedNotes);
    }
    map['category_id'] = Variable<String>(categoryId);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || faviconUrl != null) {
      map['favicon_url'] = Variable<String>(faviconUrl);
    }
    if (!nullToAbsent || customFields != null) {
      map['custom_fields'] = Variable<String>(customFields);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PasswordEntriesCompanion toCompanion(bool nullToAbsent) {
    return PasswordEntriesCompanion(
      id: Value(id),
      title: Value(title),
      username: Value(username),
      encryptedPassword: Value(encryptedPassword),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      encryptedNotes: encryptedNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedNotes),
      categoryId: Value(categoryId),
      isFavorite: Value(isFavorite),
      faviconUrl: faviconUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(faviconUrl),
      customFields: customFields == null && nullToAbsent
          ? const Value.absent()
          : Value(customFields),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory PasswordEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PasswordEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      username: serializer.fromJson<String>(json['username']),
      encryptedPassword: serializer.fromJson<String>(json['encryptedPassword']),
      url: serializer.fromJson<String?>(json['url']),
      encryptedNotes: serializer.fromJson<String?>(json['encryptedNotes']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      faviconUrl: serializer.fromJson<String?>(json['faviconUrl']),
      customFields: serializer.fromJson<String?>(json['customFields']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'username': serializer.toJson<String>(username),
      'encryptedPassword': serializer.toJson<String>(encryptedPassword),
      'url': serializer.toJson<String?>(url),
      'encryptedNotes': serializer.toJson<String?>(encryptedNotes),
      'categoryId': serializer.toJson<String>(categoryId),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'faviconUrl': serializer.toJson<String?>(faviconUrl),
      'customFields': serializer.toJson<String?>(customFields),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  PasswordEntry copyWith({
    String? id,
    String? title,
    String? username,
    String? encryptedPassword,
    Value<String?> url = const Value.absent(),
    Value<String?> encryptedNotes = const Value.absent(),
    String? categoryId,
    bool? isFavorite,
    Value<String?> faviconUrl = const Value.absent(),
    Value<String?> customFields = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => PasswordEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    username: username ?? this.username,
    encryptedPassword: encryptedPassword ?? this.encryptedPassword,
    url: url.present ? url.value : this.url,
    encryptedNotes: encryptedNotes.present
        ? encryptedNotes.value
        : this.encryptedNotes,
    categoryId: categoryId ?? this.categoryId,
    isFavorite: isFavorite ?? this.isFavorite,
    faviconUrl: faviconUrl.present ? faviconUrl.value : this.faviconUrl,
    customFields: customFields.present ? customFields.value : this.customFields,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  PasswordEntry copyWithCompanion(PasswordEntriesCompanion data) {
    return PasswordEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      username: data.username.present ? data.username.value : this.username,
      encryptedPassword: data.encryptedPassword.present
          ? data.encryptedPassword.value
          : this.encryptedPassword,
      url: data.url.present ? data.url.value : this.url,
      encryptedNotes: data.encryptedNotes.present
          ? data.encryptedNotes.value
          : this.encryptedNotes,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      faviconUrl: data.faviconUrl.present
          ? data.faviconUrl.value
          : this.faviconUrl,
      customFields: data.customFields.present
          ? data.customFields.value
          : this.customFields,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PasswordEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('username: $username, ')
          ..write('encryptedPassword: $encryptedPassword, ')
          ..write('url: $url, ')
          ..write('encryptedNotes: $encryptedNotes, ')
          ..write('categoryId: $categoryId, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('faviconUrl: $faviconUrl, ')
          ..write('customFields: $customFields, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    username,
    encryptedPassword,
    url,
    encryptedNotes,
    categoryId,
    isFavorite,
    faviconUrl,
    customFields,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PasswordEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.username == this.username &&
          other.encryptedPassword == this.encryptedPassword &&
          other.url == this.url &&
          other.encryptedNotes == this.encryptedNotes &&
          other.categoryId == this.categoryId &&
          other.isFavorite == this.isFavorite &&
          other.faviconUrl == this.faviconUrl &&
          other.customFields == this.customFields &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class PasswordEntriesCompanion extends UpdateCompanion<PasswordEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> username;
  final Value<String> encryptedPassword;
  final Value<String?> url;
  final Value<String?> encryptedNotes;
  final Value<String> categoryId;
  final Value<bool> isFavorite;
  final Value<String?> faviconUrl;
  final Value<String?> customFields;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PasswordEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.username = const Value.absent(),
    this.encryptedPassword = const Value.absent(),
    this.url = const Value.absent(),
    this.encryptedNotes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.faviconUrl = const Value.absent(),
    this.customFields = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PasswordEntriesCompanion.insert({
    required String id,
    required String title,
    required String username,
    required String encryptedPassword,
    this.url = const Value.absent(),
    this.encryptedNotes = const Value.absent(),
    required String categoryId,
    this.isFavorite = const Value.absent(),
    this.faviconUrl = const Value.absent(),
    this.customFields = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       username = Value(username),
       encryptedPassword = Value(encryptedPassword),
       categoryId = Value(categoryId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PasswordEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? username,
    Expression<String>? encryptedPassword,
    Expression<String>? url,
    Expression<String>? encryptedNotes,
    Expression<String>? categoryId,
    Expression<bool>? isFavorite,
    Expression<String>? faviconUrl,
    Expression<String>? customFields,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (username != null) 'username': username,
      if (encryptedPassword != null) 'encrypted_password': encryptedPassword,
      if (url != null) 'url': url,
      if (encryptedNotes != null) 'encrypted_notes': encryptedNotes,
      if (categoryId != null) 'category_id': categoryId,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (faviconUrl != null) 'favicon_url': faviconUrl,
      if (customFields != null) 'custom_fields': customFields,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PasswordEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? username,
    Value<String>? encryptedPassword,
    Value<String?>? url,
    Value<String?>? encryptedNotes,
    Value<String>? categoryId,
    Value<bool>? isFavorite,
    Value<String?>? faviconUrl,
    Value<String?>? customFields,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PasswordEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      encryptedPassword: encryptedPassword ?? this.encryptedPassword,
      url: url ?? this.url,
      encryptedNotes: encryptedNotes ?? this.encryptedNotes,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      customFields: customFields ?? this.customFields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (encryptedPassword.present) {
      map['encrypted_password'] = Variable<String>(encryptedPassword.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (encryptedNotes.present) {
      map['encrypted_notes'] = Variable<String>(encryptedNotes.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (faviconUrl.present) {
      map['favicon_url'] = Variable<String>(faviconUrl.value);
    }
    if (customFields.present) {
      map['custom_fields'] = Variable<String>(customFields.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PasswordEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('username: $username, ')
          ..write('encryptedPassword: $encryptedPassword, ')
          ..write('url: $url, ')
          ..write('encryptedNotes: $encryptedNotes, ')
          ..write('categoryId: $categoryId, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('faviconUrl: $faviconUrl, ')
          ..write('customFields: $customFields, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PasswordHistoryEntriesTable extends PasswordHistoryEntries
    with TableInfo<$PasswordHistoryEntriesTable, PasswordHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PasswordHistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES password_entries (id)',
    ),
  );
  static const VerificationMeta _encryptedOldPasswordMeta =
      const VerificationMeta('encryptedOldPassword');
  @override
  late final GeneratedColumn<String> encryptedOldPassword =
      GeneratedColumn<String>(
        'encrypted_old_password',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _changedByMeta = const VerificationMeta(
    'changedBy',
  );
  @override
  late final GeneratedColumn<String> changedBy = GeneratedColumn<String>(
    'changed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user'),
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entryId,
    encryptedOldPassword,
    changedBy,
    changedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'password_history_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PasswordHistoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('encrypted_old_password')) {
      context.handle(
        _encryptedOldPasswordMeta,
        encryptedOldPassword.isAcceptableOrUnknown(
          data['encrypted_old_password']!,
          _encryptedOldPasswordMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedOldPasswordMeta);
    }
    if (data.containsKey('changed_by')) {
      context.handle(
        _changedByMeta,
        changedBy.isAcceptableOrUnknown(data['changed_by']!, _changedByMeta),
      );
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PasswordHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PasswordHistoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      encryptedOldPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_old_password'],
      )!,
      changedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changed_by'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
    );
  }

  @override
  $PasswordHistoryEntriesTable createAlias(String alias) {
    return $PasswordHistoryEntriesTable(attachedDatabase, alias);
  }
}

class PasswordHistoryEntry extends DataClass
    implements Insertable<PasswordHistoryEntry> {
  final String id;
  final String entryId;
  final String encryptedOldPassword;
  final String changedBy;
  final DateTime changedAt;
  const PasswordHistoryEntry({
    required this.id,
    required this.entryId,
    required this.encryptedOldPassword,
    required this.changedBy,
    required this.changedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_id'] = Variable<String>(entryId);
    map['encrypted_old_password'] = Variable<String>(encryptedOldPassword);
    map['changed_by'] = Variable<String>(changedBy);
    map['changed_at'] = Variable<DateTime>(changedAt);
    return map;
  }

  PasswordHistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return PasswordHistoryEntriesCompanion(
      id: Value(id),
      entryId: Value(entryId),
      encryptedOldPassword: Value(encryptedOldPassword),
      changedBy: Value(changedBy),
      changedAt: Value(changedAt),
    );
  }

  factory PasswordHistoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PasswordHistoryEntry(
      id: serializer.fromJson<String>(json['id']),
      entryId: serializer.fromJson<String>(json['entryId']),
      encryptedOldPassword: serializer.fromJson<String>(
        json['encryptedOldPassword'],
      ),
      changedBy: serializer.fromJson<String>(json['changedBy']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryId': serializer.toJson<String>(entryId),
      'encryptedOldPassword': serializer.toJson<String>(encryptedOldPassword),
      'changedBy': serializer.toJson<String>(changedBy),
      'changedAt': serializer.toJson<DateTime>(changedAt),
    };
  }

  PasswordHistoryEntry copyWith({
    String? id,
    String? entryId,
    String? encryptedOldPassword,
    String? changedBy,
    DateTime? changedAt,
  }) => PasswordHistoryEntry(
    id: id ?? this.id,
    entryId: entryId ?? this.entryId,
    encryptedOldPassword: encryptedOldPassword ?? this.encryptedOldPassword,
    changedBy: changedBy ?? this.changedBy,
    changedAt: changedAt ?? this.changedAt,
  );
  PasswordHistoryEntry copyWithCompanion(PasswordHistoryEntriesCompanion data) {
    return PasswordHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      encryptedOldPassword: data.encryptedOldPassword.present
          ? data.encryptedOldPassword.value
          : this.encryptedOldPassword,
      changedBy: data.changedBy.present ? data.changedBy.value : this.changedBy,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PasswordHistoryEntry(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('encryptedOldPassword: $encryptedOldPassword, ')
          ..write('changedBy: $changedBy, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entryId, encryptedOldPassword, changedBy, changedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PasswordHistoryEntry &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.encryptedOldPassword == this.encryptedOldPassword &&
          other.changedBy == this.changedBy &&
          other.changedAt == this.changedAt);
}

class PasswordHistoryEntriesCompanion
    extends UpdateCompanion<PasswordHistoryEntry> {
  final Value<String> id;
  final Value<String> entryId;
  final Value<String> encryptedOldPassword;
  final Value<String> changedBy;
  final Value<DateTime> changedAt;
  final Value<int> rowid;
  const PasswordHistoryEntriesCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.encryptedOldPassword = const Value.absent(),
    this.changedBy = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PasswordHistoryEntriesCompanion.insert({
    required String id,
    required String entryId,
    required String encryptedOldPassword,
    this.changedBy = const Value.absent(),
    required DateTime changedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryId = Value(entryId),
       encryptedOldPassword = Value(encryptedOldPassword),
       changedAt = Value(changedAt);
  static Insertable<PasswordHistoryEntry> custom({
    Expression<String>? id,
    Expression<String>? entryId,
    Expression<String>? encryptedOldPassword,
    Expression<String>? changedBy,
    Expression<DateTime>? changedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (encryptedOldPassword != null)
        'encrypted_old_password': encryptedOldPassword,
      if (changedBy != null) 'changed_by': changedBy,
      if (changedAt != null) 'changed_at': changedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PasswordHistoryEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? entryId,
    Value<String>? encryptedOldPassword,
    Value<String>? changedBy,
    Value<DateTime>? changedAt,
    Value<int>? rowid,
  }) {
    return PasswordHistoryEntriesCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      encryptedOldPassword: encryptedOldPassword ?? this.encryptedOldPassword,
      changedBy: changedBy ?? this.changedBy,
      changedAt: changedAt ?? this.changedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (encryptedOldPassword.present) {
      map['encrypted_old_password'] = Variable<String>(
        encryptedOldPassword.value,
      );
    }
    if (changedBy.present) {
      map['changed_by'] = Variable<String>(changedBy.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PasswordHistoryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('encryptedOldPassword: $encryptedOldPassword, ')
          ..write('changedBy: $changedBy, ')
          ..write('changedAt: $changedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $PasswordEntriesTable passwordEntries = $PasswordEntriesTable(
    this,
  );
  late final $PasswordHistoryEntriesTable passwordHistoryEntries =
      $PasswordHistoryEntriesTable(this);
  late final PasswordEntryDao passwordEntryDao = PasswordEntryDao(
    this as AppDatabase,
  );
  late final CategoryDao categoryDao = CategoryDao(this as AppDatabase);
  late final PasswordHistoryDao passwordHistoryDao = PasswordHistoryDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    passwordEntries,
    passwordHistoryEntries,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<String> iconName,
      required int colorValue,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> iconName,
      Value<int> colorValue,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PasswordEntriesTable, List<PasswordEntry>>
  _passwordEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.passwordEntries,
    aliasName: $_aliasNameGenerator(
      db.categories.id,
      db.passwordEntries.categoryId,
    ),
  );

  $$PasswordEntriesTableProcessedTableManager get passwordEntriesRefs {
    final manager = $$PasswordEntriesTableTableManager(
      $_db,
      $_db.passwordEntries,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _passwordEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

  Expression<bool> passwordEntriesRefs(
    Expression<bool> Function($$PasswordEntriesTableFilterComposer f) f,
  ) {
    final $$PasswordEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passwordEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PasswordEntriesTableFilterComposer(
            $db: $db,
            $table: $db.passwordEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
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

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> passwordEntriesRefs<T extends Object>(
    Expression<T> Function($$PasswordEntriesTableAnnotationComposer a) f,
  ) {
    final $$PasswordEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.passwordEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PasswordEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.passwordEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool passwordEntriesRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                iconName: iconName,
                colorValue: colorValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> iconName = const Value.absent(),
                required int colorValue,
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                iconName: iconName,
                colorValue: colorValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({passwordEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (passwordEntriesRefs) db.passwordEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (passwordEntriesRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      PasswordEntry
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._passwordEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).passwordEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool passwordEntriesRefs})
    >;
typedef $$PasswordEntriesTableCreateCompanionBuilder =
    PasswordEntriesCompanion Function({
      required String id,
      required String title,
      required String username,
      required String encryptedPassword,
      Value<String?> url,
      Value<String?> encryptedNotes,
      required String categoryId,
      Value<bool> isFavorite,
      Value<String?> faviconUrl,
      Value<String?> customFields,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$PasswordEntriesTableUpdateCompanionBuilder =
    PasswordEntriesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> username,
      Value<String> encryptedPassword,
      Value<String?> url,
      Value<String?> encryptedNotes,
      Value<String> categoryId,
      Value<bool> isFavorite,
      Value<String?> faviconUrl,
      Value<String?> customFields,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$PasswordEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $PasswordEntriesTable, PasswordEntry> {
  $$PasswordEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.passwordEntries.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $PasswordHistoryEntriesTable,
    List<PasswordHistoryEntry>
  >
  _passwordHistoryEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.passwordHistoryEntries,
        aliasName: $_aliasNameGenerator(
          db.passwordEntries.id,
          db.passwordHistoryEntries.entryId,
        ),
      );

  $$PasswordHistoryEntriesTableProcessedTableManager
  get passwordHistoryEntriesRefs {
    final manager = $$PasswordHistoryEntriesTableTableManager(
      $_db,
      $_db.passwordHistoryEntries,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _passwordHistoryEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PasswordEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PasswordEntriesTable> {
  $$PasswordEntriesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedPassword => $composableBuilder(
    column: $table.encryptedPassword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedNotes => $composableBuilder(
    column: $table.encryptedNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get faviconUrl => $composableBuilder(
    column: $table.faviconUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customFields => $composableBuilder(
    column: $table.customFields,
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

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> passwordHistoryEntriesRefs(
    Expression<bool> Function($$PasswordHistoryEntriesTableFilterComposer f) f,
  ) {
    final $$PasswordHistoryEntriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.passwordHistoryEntries,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PasswordHistoryEntriesTableFilterComposer(
                $db: $db,
                $table: $db.passwordHistoryEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PasswordEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PasswordEntriesTable> {
  $$PasswordEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedPassword => $composableBuilder(
    column: $table.encryptedPassword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedNotes => $composableBuilder(
    column: $table.encryptedNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get faviconUrl => $composableBuilder(
    column: $table.faviconUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFields => $composableBuilder(
    column: $table.customFields,
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

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PasswordEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PasswordEntriesTable> {
  $$PasswordEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get encryptedPassword => $composableBuilder(
    column: $table.encryptedPassword,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get encryptedNotes => $composableBuilder(
    column: $table.encryptedNotes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get faviconUrl => $composableBuilder(
    column: $table.faviconUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customFields => $composableBuilder(
    column: $table.customFields,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> passwordHistoryEntriesRefs<T extends Object>(
    Expression<T> Function($$PasswordHistoryEntriesTableAnnotationComposer a) f,
  ) {
    final $$PasswordHistoryEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.passwordHistoryEntries,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PasswordHistoryEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.passwordHistoryEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PasswordEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PasswordEntriesTable,
          PasswordEntry,
          $$PasswordEntriesTableFilterComposer,
          $$PasswordEntriesTableOrderingComposer,
          $$PasswordEntriesTableAnnotationComposer,
          $$PasswordEntriesTableCreateCompanionBuilder,
          $$PasswordEntriesTableUpdateCompanionBuilder,
          (PasswordEntry, $$PasswordEntriesTableReferences),
          PasswordEntry,
          PrefetchHooks Function({
            bool categoryId,
            bool passwordHistoryEntriesRefs,
          })
        > {
  $$PasswordEntriesTableTableManager(
    _$AppDatabase db,
    $PasswordEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PasswordEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PasswordEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PasswordEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> encryptedPassword = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> encryptedNotes = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> faviconUrl = const Value.absent(),
                Value<String?> customFields = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PasswordEntriesCompanion(
                id: id,
                title: title,
                username: username,
                encryptedPassword: encryptedPassword,
                url: url,
                encryptedNotes: encryptedNotes,
                categoryId: categoryId,
                isFavorite: isFavorite,
                faviconUrl: faviconUrl,
                customFields: customFields,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String username,
                required String encryptedPassword,
                Value<String?> url = const Value.absent(),
                Value<String?> encryptedNotes = const Value.absent(),
                required String categoryId,
                Value<bool> isFavorite = const Value.absent(),
                Value<String?> faviconUrl = const Value.absent(),
                Value<String?> customFields = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PasswordEntriesCompanion.insert(
                id: id,
                title: title,
                username: username,
                encryptedPassword: encryptedPassword,
                url: url,
                encryptedNotes: encryptedNotes,
                categoryId: categoryId,
                isFavorite: isFavorite,
                faviconUrl: faviconUrl,
                customFields: customFields,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PasswordEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, passwordHistoryEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (passwordHistoryEntriesRefs) db.passwordHistoryEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$PasswordEntriesTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$PasswordEntriesTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (passwordHistoryEntriesRefs)
                        await $_getPrefetchedData<
                          PasswordEntry,
                          $PasswordEntriesTable,
                          PasswordHistoryEntry
                        >(
                          currentTable: table,
                          referencedTable: $$PasswordEntriesTableReferences
                              ._passwordHistoryEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PasswordEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).passwordHistoryEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.entryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PasswordEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PasswordEntriesTable,
      PasswordEntry,
      $$PasswordEntriesTableFilterComposer,
      $$PasswordEntriesTableOrderingComposer,
      $$PasswordEntriesTableAnnotationComposer,
      $$PasswordEntriesTableCreateCompanionBuilder,
      $$PasswordEntriesTableUpdateCompanionBuilder,
      (PasswordEntry, $$PasswordEntriesTableReferences),
      PasswordEntry,
      PrefetchHooks Function({bool categoryId, bool passwordHistoryEntriesRefs})
    >;
typedef $$PasswordHistoryEntriesTableCreateCompanionBuilder =
    PasswordHistoryEntriesCompanion Function({
      required String id,
      required String entryId,
      required String encryptedOldPassword,
      Value<String> changedBy,
      required DateTime changedAt,
      Value<int> rowid,
    });
typedef $$PasswordHistoryEntriesTableUpdateCompanionBuilder =
    PasswordHistoryEntriesCompanion Function({
      Value<String> id,
      Value<String> entryId,
      Value<String> encryptedOldPassword,
      Value<String> changedBy,
      Value<DateTime> changedAt,
      Value<int> rowid,
    });

final class $$PasswordHistoryEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PasswordHistoryEntriesTable,
          PasswordHistoryEntry
        > {
  $$PasswordHistoryEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PasswordEntriesTable _entryIdTable(_$AppDatabase db) =>
      db.passwordEntries.createAlias(
        $_aliasNameGenerator(
          db.passwordHistoryEntries.entryId,
          db.passwordEntries.id,
        ),
      );

  $$PasswordEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$PasswordEntriesTableTableManager(
      $_db,
      $_db.passwordEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PasswordHistoryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PasswordHistoryEntriesTable> {
  $$PasswordHistoryEntriesTableFilterComposer({
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

  ColumnFilters<String> get encryptedOldPassword => $composableBuilder(
    column: $table.encryptedOldPassword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changedBy => $composableBuilder(
    column: $table.changedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PasswordEntriesTableFilterComposer get entryId {
    final $$PasswordEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.passwordEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PasswordEntriesTableFilterComposer(
            $db: $db,
            $table: $db.passwordEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PasswordHistoryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PasswordHistoryEntriesTable> {
  $$PasswordHistoryEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get encryptedOldPassword => $composableBuilder(
    column: $table.encryptedOldPassword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changedBy => $composableBuilder(
    column: $table.changedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PasswordEntriesTableOrderingComposer get entryId {
    final $$PasswordEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.passwordEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PasswordEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.passwordEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PasswordHistoryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PasswordHistoryEntriesTable> {
  $$PasswordHistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get encryptedOldPassword => $composableBuilder(
    column: $table.encryptedOldPassword,
    builder: (column) => column,
  );

  GeneratedColumn<String> get changedBy =>
      $composableBuilder(column: $table.changedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  $$PasswordEntriesTableAnnotationComposer get entryId {
    final $$PasswordEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.passwordEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PasswordEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.passwordEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PasswordHistoryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PasswordHistoryEntriesTable,
          PasswordHistoryEntry,
          $$PasswordHistoryEntriesTableFilterComposer,
          $$PasswordHistoryEntriesTableOrderingComposer,
          $$PasswordHistoryEntriesTableAnnotationComposer,
          $$PasswordHistoryEntriesTableCreateCompanionBuilder,
          $$PasswordHistoryEntriesTableUpdateCompanionBuilder,
          (PasswordHistoryEntry, $$PasswordHistoryEntriesTableReferences),
          PasswordHistoryEntry,
          PrefetchHooks Function({bool entryId})
        > {
  $$PasswordHistoryEntriesTableTableManager(
    _$AppDatabase db,
    $PasswordHistoryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PasswordHistoryEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PasswordHistoryEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PasswordHistoryEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<String> encryptedOldPassword = const Value.absent(),
                Value<String> changedBy = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PasswordHistoryEntriesCompanion(
                id: id,
                entryId: entryId,
                encryptedOldPassword: encryptedOldPassword,
                changedBy: changedBy,
                changedAt: changedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entryId,
                required String encryptedOldPassword,
                Value<String> changedBy = const Value.absent(),
                required DateTime changedAt,
                Value<int> rowid = const Value.absent(),
              }) => PasswordHistoryEntriesCompanion.insert(
                id: id,
                entryId: entryId,
                encryptedOldPassword: encryptedOldPassword,
                changedBy: changedBy,
                changedAt: changedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PasswordHistoryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (entryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.entryId,
                                referencedTable:
                                    $$PasswordHistoryEntriesTableReferences
                                        ._entryIdTable(db),
                                referencedColumn:
                                    $$PasswordHistoryEntriesTableReferences
                                        ._entryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PasswordHistoryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PasswordHistoryEntriesTable,
      PasswordHistoryEntry,
      $$PasswordHistoryEntriesTableFilterComposer,
      $$PasswordHistoryEntriesTableOrderingComposer,
      $$PasswordHistoryEntriesTableAnnotationComposer,
      $$PasswordHistoryEntriesTableCreateCompanionBuilder,
      $$PasswordHistoryEntriesTableUpdateCompanionBuilder,
      (PasswordHistoryEntry, $$PasswordHistoryEntriesTableReferences),
      PasswordHistoryEntry,
      PrefetchHooks Function({bool entryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$PasswordEntriesTableTableManager get passwordEntries =>
      $$PasswordEntriesTableTableManager(_db, _db.passwordEntries);
  $$PasswordHistoryEntriesTableTableManager get passwordHistoryEntries =>
      $$PasswordHistoryEntriesTableTableManager(
        _db,
        _db.passwordHistoryEntries,
      );
}
