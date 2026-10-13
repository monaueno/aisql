# Example Questions, Queries, and Answers

Compiled from the `responses_*.json` logs written by `db_bot.py`. Each question lists the SQL generated and the answer returned under every prompting strategy it was run with.

## Contents

1. [how many appointments did customer 5 book?](#question-1)
2. [what salon does ben work at?](#question-2)
3. [(accidental input: arrow-key escape codes)](#question-3)
4. [which books were checked out by member 3?](#question-4)
5. [what is the phone number for the location that ana works at?](#question-5)
6. [Which customer booked the most appointments?](#question-6)
7. [What was the price of a Facial at the time of Ana’s appointment on October 10?](#question-7)

<a id="question-1"></a>

## 1. how many appointments did customer 5 book?

### Zero-shot

_Source: `responses_zero_shot_20261013-155703.json`_

**Query**

```sql
SELECT COUNT(*) FROM appointments WHERE customer_id = 5;
```

**Answer**

> Customer 5 booked 3 appointments.

<a id="question-2"></a>

## 2. what salon does ben work at?

### Zero-shot

_Source: `responses_zero_shot_20261013-160607.json`_

**Query**

```sql
SELECT s.name FROM person p JOIN beauty_professional bp ON bp.id = p.id JOIN salon s ON s.salon_id = bp.salon_id WHERE LOWER(p.first_name) = 'ben';
```

**Answer**

> Ben works at Velvet Spa.

<a id="question-3"></a>

## 3. (accidental input: arrow-key escape codes)

### Zero-shot

_Source: `responses_zero_shot_20261013-160607.json`_

**Query**

```sql
SELECT NULL WHERE 0;
```

**Answer**

> The question didn't come through. "[A[A[B[B[B" looks like terminal arrow-key escape codes rather than a real question.
>
> The SQL query `SELECT NULL WHERE 0;` returned no rows, because `WHERE 0` is always false.

<a id="question-4"></a>

## 4. which books were checked out by member 3?

### Cross-domain

_Source: `responses_cross_domain_20261013-160647.json`_

**Query**

```sql
SELECT 'The schema has no books or checkouts tables' AS error;
```

**Answer**

> The database doesn't contain any books or checkouts tables, so I can't determine which books member 3 checked out. The query returned only an error message saying so.

<a id="question-5"></a>

## 5. what is the phone number for the location that ana works at?

### Zero-shot

_Source: `responses_zero_shot_20261013-161638.json`_

**Query**

```sql
SELECT s.phone_number FROM person p JOIN beauty_professional bp ON bp.id = p.id JOIN salon s ON s.salon_id = bp.salon_id WHERE LOWER(p.first_name) = 'ana';
```

**Answer**

> Ana works at the location with phone number 801-555-0101.

### Single-domain

_Source: `responses_single_domain_20261013-161659.json`_

**Query**

```sql
SELECT s.phone_number FROM person p JOIN beauty_professional bp ON bp.id = p.id JOIN salon s ON s.salon_id = bp.salon_id WHERE LOWER(p.first_name) = 'ana';
```

**Answer**

> Ana works at the location with phone number 801-555-0101.

### Cross-domain

_Source: `responses_cross_domain_20261013-160647.json`_

**Query**

```sql
SELECT s.phone_number FROM person p JOIN beauty_professional bp ON bp.id = p.id JOIN salon s ON s.salon_id = bp.salon_id WHERE LOWER(p.first_name) = 'ana';
```

**Answer**

> Ana works at a location with the phone number 801-555-0101.

<a id="question-6"></a>

## 6. Which customer booked the most appointments?

### Zero-shot

_Source: `responses_zero_shot_20261013-161734.json`_

**Query**

```sql
SELECT p.id, p.first_name, p.last_name, COUNT(a.id) AS appointment_count FROM appointments a JOIN customer c ON a.customer_id = c.id JOIN person p ON c.id = p.id GROUP BY p.id, p.first_name, p.last_name ORDER BY appointment_count DESC LIMIT 1;
```

**Answer**

> Emma Wu booked the most appointments, with 3.

### Single-domain

_Source: `responses_single_domain_20261013-161741.json`_

**Query**

```sql
SELECT a.customer_id, p.first_name, p.last_name, COUNT(*) AS appointment_count FROM appointments a JOIN person p ON p.id = a.customer_id GROUP BY a.customer_id, p.first_name, p.last_name ORDER BY appointment_count DESC LIMIT 1;
```

**Answer**

> Emma Wu (customer ID 5) booked the most appointments, with 3.

### Cross-domain

_Source: `responses_cross_domain_20261013-161755.json`_

**Query**

```sql
SELECT p.id, p.first_name, p.last_name, COUNT(a.id) AS appointment_count FROM appointments a JOIN customer c ON c.id = a.customer_id JOIN person p ON p.id = c.id GROUP BY p.id, p.first_name, p.last_name ORDER BY appointment_count DESC LIMIT 1;
```

**Answer**

> Emma Wu booked the most appointments, with 3.

<a id="question-7"></a>

## 7. What was the price of a Facial at the time of Ana’s appointment on October 10?

### Zero-shot

_Source: `responses_zero_shot_20261013-161812.json`_

**Query**

```sql
SELECT pl.price_cents
FROM appointments a
JOIN customer c ON c.id = a.customer_id
JOIN person p ON p.id = c.id
JOIN service s ON s.id = a.service_id
JOIN price_list pl ON pl.beauty_professional_id = a.beauty_professional_id AND pl.service_id = a.service_id
WHERE p.first_name = 'Ana'
  AND s.service = 'Facial'
  AND strftime('%m-%d', a.start_time) = '10-10';
```

**Answer**

> The query returned no results, so I can't determine the price of a Facial for Ana's October 10 appointment from this data. The filters may have matched no appointment, or no price list entry may exist for that professional and service. The year was also not filtered, so the query could have missed a mismatch in the date or a join condition.

### Single-domain

_Source: `responses_single_domain_20261013-161831.json`_

**Query**

```sql
SELECT pl.price_cents FROM appointments a JOIN person p ON p.id = a.customer_id JOIN service s ON s.id = a.service_id JOIN price_list pl ON pl.beauty_professional_id = a.beauty_professional_id AND pl.service_id = a.service_id WHERE p.first_name = 'Ana' AND s.service = 'Facial' AND strftime('%m-%d', a.start_time) = '10-10';
```

**Answer**

> The query returned no results, so the data doesn't show a price for a Facial in Ana's October 10 appointment. Either no matching appointment was found, or no price list entry matched that professional and service.

### Cross-domain

_Source: `responses_cross_domain_20261013-161841.json`_

**Query**

```sql
SELECT pl.price_cents FROM appointments a JOIN person p ON p.id = a.customer_id JOIN service s ON s.id = a.service_id JOIN price_list pl ON pl.beauty_professional_id = a.beauty_professional_id AND pl.service_id = a.service_id WHERE p.first_name = 'Ana' AND s.service = 'Facial' AND strftime('%m-%d', a.start_time) = '10-10' AND pl.updated_at <= a.start_time;
```

**Answer**

> The query found no price for a Facial at Ana's October 10 appointment. It returned no rows, so the data doesn't show a matching appointment, a price list entry effective before that appointment, or both.
