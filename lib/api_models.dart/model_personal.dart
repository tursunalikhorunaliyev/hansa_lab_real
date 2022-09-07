
class ModelPersonalMain {
  bool status;
  ModelPersonal1 modelPersonal1;

  ModelPersonalMain({
    required this.status,
    required this.modelPersonal1,
  });

  factory ModelPersonalMain.fromMap(Map<String, dynamic> map) {
    return ModelPersonalMain(
      status: map['status'],
      modelPersonal1: ModelPersonal1.fromMap(map['data']),
    );
  }
}

class ModelPersonal1 {
  String firstname;
  String lastname;
  String bornedAt;
  String email;
  String phone;
  CountryType countryType;
  CityId cityId;
  Job job;
  Store store;
  String shopAddress;
  ModelPersonal1({
    required this.firstname,
    required this.lastname,
    required this.bornedAt,
    required this.email,
    required this.phone,
    required this.countryType,
    required this.cityId,
    required this.job,
    required this.store,
    required this.shopAddress,
  });

  factory ModelPersonal1.fromMap(Map<String, dynamic> map) {
    return ModelPersonal1(
      firstname: map['firstname'],
      lastname: map['lastname'],
      bornedAt: map['borned_at'],
      email: map['email'],
      phone: map['phone'],
      countryType: CountryType.fromMap(map['country_type']),
      cityId: CityId.fromMap(map['city']),
      job: Job.fromMap(map['job']),
      store: Store.fromMap(map['store']),
      shopAddress: map['shop_address'],
    );
  }
}

class CountryType {
  int id;
  String name;
  CountryType({
    required this.id,
    required this.name,
  });

  factory CountryType.fromMap(Map<String, dynamic> map) {
    return CountryType(
      id: map['id'],
      name: map['name'],
    );
  }
}

class CityId {
  int id;
  String name;
  CityId({
    required this.id,
    required this.name,
  });

  factory CityId.fromMap(Map<String, dynamic> map) {
    return CityId(
      id: map['id'],
      name: map['name'],
    );
  }
}

class Job {
  int id;
  String name;
  Job({
    required this.id,
    required this.name,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      name: map['name'],
    );
  }
}

class Store {
  int id;
  String name;
  Store({
    required this.id,
    required this.name,
  });

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'] ?? 1,
      name: map['name'] ?? "Пустой",
    );
  }
}
