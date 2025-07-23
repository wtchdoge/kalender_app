// Provider-Namen
final Map<int, String> providerMap = {
  1: 'Lan',
  7: 'Raquel',
  8: 'Saron',
};

// Service-Infos
final Map<int, Map<String, String>> serviceMap = {
  23: {'dienstleistung': 'Basisreinigung', 'kategorie': 'Haushalt- und Büroreinigung'},
  14: {'dienstleistung': 'Bodentiefe Fenster / Glastür', 'kategorie': 'Normalreinigung'},
  20: {'dienstleistung': 'Bodentiefe Fenster / Glastür', 'kategorie': 'Tiefeinreinigung'},
  11: {'dienstleistung': 'Doppelfensterflügel / Kastenfenster', 'kategorie': 'Normalreinigung'},
  17: {'dienstleistung': 'Doppelfensterflügel / Kastenfenster', 'kategorie': 'Tiefeinreinigung'},
  15: {'dienstleistung': 'Einzelnes Dachfenster', 'kategorie': 'Normalreinigung'},
  21: {'dienstleistung': 'Einzelnes Dachfenster', 'kategorie': 'Tiefeinreinigung'},
  12: {'dienstleistung': 'Kleiner Fensterflügel', 'kategorie': 'Normalreinigung'},
  18: {'dienstleistung': 'Kleiner Fensterflügel', 'kategorie': 'Tiefeinreinigung'},
  9:  {'dienstleistung': 'Normale Fensterreinigung', 'kategorie': 'Normalreinigung'},
  22: {'dienstleistung': 'Seniorenbetreuung', 'kategorie': 'Seniorenbetreuung'},
  13: {'dienstleistung': 'Sprossenfensterflügel', 'kategorie': 'Normalreinigung'},
  19: {'dienstleistung': 'Sprossenfensterflügel', 'kategorie': 'Tiefeinreinigung'},
  10: {'dienstleistung': 'Standard-Fensterflügel', 'kategorie': 'Normalreinigung'},
  16: {'dienstleistung': 'Standard-Fensterflügel', 'kategorie': 'Tiefeinreinigung'},
};

// Status-Liste zentral für das Projekt
const List<String> statusList = [
  'gebucht',
  'storniert',
  'abgeschlossen',
  'offen',
  'bestätigt',
];

final Map<int, String> mitarbeiter = {};