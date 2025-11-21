# Bali Calendar Algorithm Documentation

## Overview

This documentation describes the complete implementation of the Balinese calendar system, including Pawukon (210-day cycle), Saka (lunar calendar), and all Wewaran cycles.

## Calendar Systems

### 1. Pawukon Calendar (210-Day Cycle)

The Pawukon calendar is a unique 210-day cycle that doesn't depend on astronomical observations.

**Key Concepts:**
- **Wuku**: 30 weeks, each lasting 7 days (30 × 7 = 210 days)
- **Wewaran**: Complete cycle system from Eka Wara to Dasa Wara
- **Urip/Neptu**: Spiritual energy values for each cycle

**Main Algorithm:**

```
1. Choose pivot date based on target date:
   - For dates >= 2000-01-01: Use pivot 2000-01-01 (angkaWuku 70)
   - For dates < 2000-01-01: Use pivot 1970-01-01 (angkaWuku 33)

2. Calculate day difference from pivot:
   dayDiff = targetDate - pivotDate

3. Calculate angkaWuku (position in 210-day cycle):
   if dayDiff >= 0:
     angkaWuku = (pivotAngkaWuku + dayDiff) mod 210
   else:
     angkaWuku = 210 - (-(pivotAngkaWuku + dayDiff) mod 210)
   if angkaWuku == 0: angkaWuku = 210

4. Calculate Wuku (0-29):
   noWuku = ceil(angkaWuku / 7)
   if noWuku > 30: noWuku = noWuku mod 30
   if noWuku == 0: noWuku = 30

5. Calculate all Wewaran (see detailed formulas below)

6. Calculate total Urip:
   totalUrip = wukuUrip + saptawaraUrip + pancawaraUrip + triwaraUrip
```

**Pivot Points:**
- **2000-01-01**: Wuku Sungsang (10), angkaWuku 70
- **1970-01-01**: Wuku Tolu (5), angkaWuku 33

### 2. Wewaran (Complete Cycle System)

The Wewaran system consists of 10 different cycles, from Eka Wara (1-day) to Dasa Wara (10-day).

#### 2.1 Eka Wara (1-Day Cycle)

**Concept**: Determines if a day is "Luang" (void/empty) or not.

**Algorithm:**
```
uripSum = uripPancawara + uripSaptawara
if uripSum is odd:
  ekaWara = Luang (id: 1)
else:
  ekaWara = Not Luang (id: 0, empty name)
```

**Values:**
| ID | Name | Urip |
|----|------|------|
| 0 | (empty) | 0 |
| 1 | Luang | 1 |

#### 2.2 Dwi Wara (2-Day Cycle)

**Concept**: Two-day cycle alternating between Menga and Pepet.

**Algorithm:**
```
uripSum = uripPancawara + uripSaptawara
if uripSum is even:
  dwiWara = Menga (id: 0)
else:
  dwiWara = Pepet (id: 1)
```

**Values:**
| ID | Name | Urip |
|----|------|------|
| 0 | Menga | 5 |
| 1 | Pepet | 7 |

#### 2.3 Tri Wara (3-Day Cycle)

**Concept**: Three-day cycle used for determining Kajeng Kliwon.

**Algorithm:**
```
noTriwara = angkaWuku mod 3
if noTriwara == 0: noTriwara = 3
triWara = TriWara.values[noTriwara - 1]
```

**Values:**
| ID | Name | Urip |
|----|------|------|
| 0 | Pasah | 9 |
| 1 | Beteng | 4 |
| 2 | Kajeng | 7 |

**Special Combination:**
- **Kajeng Kliwon**: TriWara = Kajeng (2) AND PancaWara = Kliwon (4)
- Occurs every 15 days
- Important for spiritual ceremonies

#### 2.4 Catur Wara (4-Day Cycle)

**Concept**: Four-day cycle with special rule "Jaya Tiga".

**Algorithm:**
```
if angkaWuku == 71 OR angkaWuku == 72 OR angkaWuku == 73:
  noCaturwara = 3  // Jaya (Jaya Tiga special case)
else if angkaWuku <= 70:
  noCaturwara = angkaWuku mod 4
else:
  noCaturwara = (angkaWuku + 2) mod 4

if noCaturwara == 0: noCaturwara = 4
caturWara = CaturWara.values[noCaturwara - 1]
```

**Values:**
| ID | Name | Urip |
|----|------|------|
| 0 | Sri | 4 |
| 1 | Laba | 5 |
| 2 | Jaya | 9 |
| 3 | Menala | 7 |

**Special Rule:**
- **Jaya Tiga**: On angkaWuku 71, 72, 73, Catur Wara is always "Jaya"

#### 2.5 Panca Wara (5-Day Cycle)

**Concept**: Five-day market cycle, fundamental for Balinese calendar.

**Algorithm:**
```
noPancawara = (angkaWuku mod 5) + 1
pancaWara = PancaWara.values[noPancawara - 1]
```

**Values:**
| ID | Name | Urip |
|----|------|------|
| 0 | Umanis | 5 |
| 1 | Paing | 9 |
| 2 | Pon | 7 |
| 3 | Wage | 4 |
| 4 | Kliwon | 8 |

**Special Combinations:**
- **Kajeng Kliwon**: TriWara = Kajeng AND PancaWara = Kliwon
- **Anggara Kasih**: SaptaWara = Anggara (Tuesday) AND PancaWara = Kliwon
- **Buda Cemeng**: SaptaWara = Buda (Wednesday) AND PancaWara = Kliwon

#### 2.6 Sad Wara (6-Day Cycle)

**Concept**: Six-day cycle.

**Algorithm:**
```
noSadwara = angkaWuku mod 6
if noSadwara == 0: noSadwara = 6
sadWara = SadWara.values[noSadwara - 1]
```

**Values:**
| ID | Name | Urip |
|----|------|------|
| 0 | Tungleh | 7 |
| 1 | Aryang | 6 |
| 2 | Urukung | 5 |
| 3 | Paniron | 8 |
| 4 | Was | 9 |
| 5 | Maulu | 3 |

#### 2.7 Sapta Wara (7-Day Week)

**Concept**: Seven-day week, same as international week but with Balinese names.

**Algorithm:**
```
saptawaraId = gregorianDate.weekday mod 7  // Sunday = 0
saptaWara = SaptaWara.values[saptawaraId]
```

**Values:**
| ID | Name | English | Urip |
|----|------|---------|------|
| 0 | Redite | Sunday | 5 |
| 1 | Soma | Monday | 4 |
| 2 | Anggara | Tuesday | 3 |
| 3 | Buda | Wednesday | 7 |
| 4 | Wraspati | Thursday | 8 |
| 5 | Sukra | Friday | 6 |
| 6 | Saniscara | Saturday | 9 |

#### 2.8 Asta Wara (8-Day Cycle)

**Concept**: Eight-day cycle with special rule "Kala Tiga".

**Algorithm:**
```
if angkaWuku == 71 OR angkaWuku == 72 OR angkaWuku == 73:
  noAstawara = 7  // Kala (Kala Tiga special case)
else if angkaWuku <= 70:
  noAstawara = angkaWuku mod 8
else:
  noAstawara = (angkaWuku + 6) mod 8

if noAstawara == 0: noAstawara = 8
astaWara = AstaWara.values[noAstawara - 1]
```

**Values:**
| ID | Name | Urip |
|----|------|------|
| 0 | Sri | 6 |
| 1 | Indra | 5 |
| 2 | Guru | 8 |
| 3 | Yama | 9 |
| 4 | Ludra | 3 |
| 5 | Brahma | 7 |
| 6 | Kala | 1 |
| 7 | Uma | 4 |

**Special Rule:**
- **Kala Tiga**: On angkaWuku 71, 72, 73, Asta Wara is always "Kala"

#### 2.9 Sanga Wara (9-Day Cycle)

**Concept**: Nine-day cycle with special rule "Dangu Pat".

**Algorithm:**
```
if angkaWuku <= 4:
  noSangawara = 1  // Dangu (Dangu Pat special case)
else:
  noSangawara = (angkaWuku + 6) mod 9

if noSangawara == 0: noSangawara = 9
sangaWara = SangaWara.values[noSangawara - 1]
```

**Values:**
| ID | Name | Urip |
|----|------|------|
| 0 | Dangu | 9 |
| 1 | Jangur | 8 |
| 2 | Gigis | 6 |
| 3 | Nohan | 7 |
| 4 | Ogan | 4 |
| 5 | Erangan | 5 |
| 6 | Urungan | 7 |
| 7 | Tulus | 3 |
| 8 | Dadi | 4 |

**Special Rule:**
- **Dangu Pat**: On angkaWuku 1-4, Sanga Wara is always "Dangu" (4 consecutive days)

#### 2.10 Dasa Wara (10-Day Cycle)

**Concept**: Ten-day cycle based on urip sum.

**Algorithm:**
```
noDasawara = ((uripPancawara + uripSaptawara) mod 10) + 1
dasaWara = DasaWara.values[noDasawara - 1]
```

**Values:**
| ID | Name | Urip |
|----|------|------|
| 0 | Pandita | 5 |
| 1 | Pati | 7 |
| 2 | Suka | 10 |
| 3 | Duka | 4 |
| 4 | Sri | 6 |
| 5 | Manuh | 2 |
| 6 | Manusa | 3 |
| 7 | Raja | 8 |
| 8 | Dewa | 9 |
| 9 | Raksasa | 1 |

### 3. Saka Calendar (Lunar Calendar)

The Saka calendar is a lunar calendar similar to other Hindu calendars.

**Key Concepts:**
- **Sasih**: Lunar month (12 months normally, 13 in leap years)
- **Penanggal**: Waxing moon phase (days 1-15)
- **Pangelong**: Waning moon phase (days 1-15)
- **Purnama**: Full moon (day 15 of Penanggal)
- **Tilem**: New moon (day 15 of Pangelong)
- **Ngunaratri**: 63-day cycle for leap day adjustments
- **Nampih Sasih**: Leap month (occurs in 19-year cycle)

**Algorithm:**

```
1. Choose pivot date:
   - For dates >= 2000-01-01: Use pivot 2000-01-01
     (Saka 1921, Sasih Kapitu, Pangelong 10)
   - For dates < 2000-01-01: Use pivot 1970-01-01
     (Saka 1891, Sasih Kapitu, Pangelong 8)

2. Calculate day difference:
   dayDiff = targetDate - pivotDate

3. Calculate Ngunaratri adjustments:
   daySkip = ceil(dayDiff / 63)
   dayTotal = pivotSasihDay + dayDiff + daySkip

4. Calculate Sasih (month):
   - Iterate through months from pivot
   - Check for Nampih Sasih based on 19-year cycle
   - Adjust Saka year when crossing Kadasa (month 9)

5. Calculate Sasih day:
   day = (dayTotal mod 30) mod 15
   if day == 0: day = 15
   isPangelong = (dayTotal mod 30) > 15 or == 0

6. Determine special days:
   - Purnama: day 15 of Penanggal
   - Tilem: day 15 of Pangelong
```

**Nampih Sasih (Leap Month) Rules:**

Based on 19-year cycle (Saka year mod 19):

**Outside Saka Kala Period (before 1993 or after 2003):**
| Mod 19 | Nampih Sasih |
|--------|--------------|
| 0, 6, 11 | Destha |
| 3, 8, 14, 16 | Sadha |

**Inside Saka Kala Period (1993-2003):**
| Mod 19 | Nampih Sasih |
|--------|--------------|
| 2, 10 | Destha |
| 4 | Katiga |
| 7 | Kasa |
| 13 | Kadasa |
| 15 | Karo |
| 18 | Sadha |

**Saka Kala Period**: 1993-01-24 to 2003-01-03 (Saka 1914-1924)

**Ngunaratri Cycle:**
- Every 63 days, one day is skipped in the Sasih calculation
- This keeps the lunar calendar aligned with astronomical observations
- Formula: daySkip = ceil(dayDiff / 63)

### 4. Weton (Birth Day Calculation)

Weton is the Balinese concept of a person's birth day in the Pawukon system.

**Key Concepts:**
- **Otonan**: Balinese birthday, occurs every 210 days
- **Neptu/Urip**: Numerical value representing spiritual energy
- **Classification**: Based on total Urip value

**Algorithm:**

```
1. Calculate Pawukon date for birth date
2. Calculate total Urip:
   neptu = wukuUrip + saptawaraUrip + pancawaraUrip + triwaraUrip

3. Determine classification:
   - >= 30: Sangat Baik (Very Good)
   - >= 25: Baik (Good)
   - >= 20: Cukup Baik (Fairly Good)
   - >= 15: Sedang (Average)
   - < 15: Perlu Perhatian Khusus (Needs Special Attention)

4. Calculate next Otonan:
   - Find current Pawukon day
   - Calculate days until same Pawukon day
   - daysUntil = (birthPawukonDay - currentPawukonDay) mod 210
```

## Complete Urip/Neptu Values

### Wuku Urip Values (30 Weeks)

| No | Wuku | Urip | No | Wuku | Urip | No | Wuku | Urip |
|----|------|------|----|------|------|----|------|------|
| 1 | Sinta | 7 | 11 | Dungulan | 4 | 21 | Matal | 5 |
| 2 | Landep | 1 | 12 | Kuningan | 6 | 22 | Uye | 8 |
| 3 | Ukir | 4 | 13 | Langkir | 5 | 23 | Menail | 9 |
| 4 | Kulantir | 6 | 14 | Medangsia | 8 | 24 | Prangbakat | 3 |
| 5 | Tolu | 5 | 15 | Pujut | 9 | 25 | Bala | 7 |
| 6 | Gumbreg | 8 | 16 | Pahang | 3 | 26 | Ugu | 1 |
| 7 | Wariga | 9 | 17 | Krulut | 7 | 27 | Wayang | 4 |
| 8 | Warigadean | 3 | 18 | Merakih | 1 | 28 | Klawu | 6 |
| 9 | Julungwangi | 7 | 19 | Tambir | 4 | 29 | Dukut | 5 |
| 10 | Sungsang | 1 | 20 | Medangkungan | 6 | 30 | Watugunung | 8 |

### All Wewaran Urip Values

| Wewaran | Cycle | Values & Urip |
|---------|-------|---------------|
| Eka Wara | 1-day | (empty): 0, Luang: 1 |
| Dwi Wara | 2-day | Menga: 5, Pepet: 7 |
| Tri Wara | 3-day | Pasah: 9, Beteng: 4, Kajeng: 7 |
| Catur Wara | 4-day | Sri: 4, Laba: 5, Jaya: 9, Menala: 7 |
| Panca Wara | 5-day | Umanis: 5, Paing: 9, Pon: 7, Wage: 4, Kliwon: 8 |
| Sad Wara | 6-day | Tungleh: 7, Aryang: 6, Urukung: 5, Paniron: 8, Was: 9, Maulu: 3 |
| Sapta Wara | 7-day | Redite: 5, Soma: 4, Anggara: 3, Buda: 7, Wraspati: 8, Sukra: 6, Saniscara: 9 |
| Asta Wara | 8-day | Sri: 6, Indra: 5, Guru: 8, Yama: 9, Ludra: 3, Brahma: 7, Kala: 1, Uma: 4 |
| Sanga Wara | 9-day | Dangu: 9, Jangur: 8, Gigis: 6, Nohan: 7, Ogan: 4, Erangan: 5, Urungan: 7, Tulus: 3, Dadi: 4 |
| Dasa Wara | 10-day | Pandita: 5, Pati: 7, Suka: 10, Duka: 4, Sri: 6, Manuh: 2, Manusa: 3, Raja: 8, Dewa: 9, Raksasa: 1 |

## Special Rules Summary

### Jaya Tiga (Catur Wara)
- **When**: angkaWuku = 71, 72, 73
- **Rule**: Catur Wara is always "Jaya" (id: 2)
- **Reason**: Special exception in 4-day cycle calculation

### Kala Tiga (Asta Wara)
- **When**: angkaWuku = 71, 72, 73
- **Rule**: Asta Wara is always "Kala" (id: 6)
- **Reason**: Special exception in 8-day cycle calculation

### Dangu Pat (Sanga Wara)
- **When**: angkaWuku = 1, 2, 3, 4
- **Rule**: Sanga Wara is always "Dangu" (id: 0)
- **Reason**: Dangu occurs 4 consecutive days at cycle start

## Implementation Notes

### Modulo Operation

The implementation uses a custom modulo function that handles negative numbers correctly:

```dart
int mod(int a, int b) {
  return ((a % b) + b) % b;
}
```

This ensures that negative day differences are handled properly.

### Date Normalization

All dates are normalized to midnight (00:00:00) to avoid time zone issues:

```dart
final normalizedDate = DateTime(date.year, date.month, date.day);
```

### Performance Optimization

- Pivot dates are used to minimize calculation distance
- Pre-calculated lookup tables for Urip values
- Efficient modulo operations for cycle calculations
- All calculations are performed locally (offline-first)

## Testing

To verify the implementation:

1. **Test with known pivot dates:**
   - 2000-01-01 should return Saka 1921, Kapitu, Pangelong 10, Wuku Sungsang
   - 1970-01-01 should return Saka 1891, Kapitu, Pangelong 8, Wuku Tolu

2. **Test special day detection:**
   - Kajeng Kliwon should occur every 15 days
   - Purnama and Tilem should occur approximately monthly

3. **Test Otonan calculation:**
   - Next Otonan should be exactly 210 days from last Otonan

4. **Test special rules:**
   - Verify Jaya Tiga on angkaWuku 71-73
   - Verify Kala Tiga on angkaWuku 71-73
   - Verify Dangu Pat on angkaWuku 1-4

5. **Test all Wewaran:**
   - Verify each wewaran calculation
   - Check urip values match reference tables
   - Validate cycle patterns

## References

1. **Ardhana, I.B.S.** (2005). "Pokok-Pokok Wariga". Surabaya: Paramita.
2. **Pendit, Nyoman.** (2001). "Nyepi: kebangkitan, toleransi, dan kerukunan". Jakarta: Gramedia.
3. **Babadbali.com** - Yayasan Bali Galang: http://www.babadbali.com/

## License

This implementation is based on open-source algorithms and is provided for educational and cultural preservation purposes.

---

**Last Updated**: 2025
**Version**: 2.0 (Complete Wewaran Implementation)
