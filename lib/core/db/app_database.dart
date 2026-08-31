import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

enum AnimalType { cattle, pig, sheep, goat, rabbit, broiler, layer, roadrunner, turkey, duck, goose, tilapia, catfish, dog, horse }

class Farms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get location => text().nullable()();
}

class Animals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get farmId => integer().references(Farms, #id)();
  TextColumn get tagId => text().unique()();
  TextColumn get type => textEnum<AnimalType>()();
  TextColumn get breed => text().nullable()();
  DateTimeColumn get dob => dateTime().nullable()();
  RealColumn get weightKg => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class BreedingRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get animalId => integer().references(Animals, #id)();
  DateTimeColumn get breedingDate => dateTime()();
  DateTimeColumn get expectedBirthDate => dateTime()();
  TextColumn get notes => text().nullable()();
}

class HealthRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get animalId => integer().references(Animals, #id)();
  TextColumn get type => text()(); // vaccination, deworming
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get nextDue => dateTime().nullable()();
  TextColumn get product => text()();
}

class FinanceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get farmId => integer().references(Farms, #id)();
  TextColumn get type => text()(); // expense, sale
  TextColumn get category => text()(); // feed, seed, animal_sale
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
}

@DriftDatabase(tables: [Farms, Animals, BreedingRecords, HealthRecords, FinanceRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _open() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'smartfarmer.sqlite'));
      return NativeDatabase(file);
    });
  }
}
