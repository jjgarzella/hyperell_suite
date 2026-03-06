# Prompt: Implement `save_case`

Implement a function called `save_case` in your chosen CAS/language.

The purpose of this function is to **write a hyperelliptic curve test case to a JSON test file** following the format described in `FORMAT.md`.

The function should either:

* **create a new file**, or
* **add or update a case inside an existing file**.

---

# Function signature

Implement something like:

```text
save_case(curve, result, filename; id, notes="")
```

Inputs:

* `curve` — a hyperelliptic curve object in the native CAS
* `result` — the computed L-polynomial coefficients in ascending order
* `filename` — path to the JSON test file
* `id` — unique identifier for the test case
* `notes` — optional metadata string

---

# Required behavior

## 1. Validate filename

The function must check that:

```text
filename ends with ".json"
```

If not, raise an error.

---

## 2. Construct the test case object

Convert the curve into the JSON format defined in `FORMAT.md`.

You must extract:

### Field data

From the curve:

* prime `p`
* extension degree `a`
* modulus polynomial if `a > 1`

### Curve model

Write the curve in the form

[
y^2 + h(x)y = f(x)
]

Extract:

* `h_coeffs_asc`
* `f_coeffs_asc`

in **ascending coefficient order**.

Also include the string representation:

```text
pretty
```

which may be obtained from the CAS printing functionality.

---

### Expected result

Store the L-polynomial coefficients as:

```json
"expected": {
  "Lpoly": {
    "coeffs_asc": result
  }
}
```

---

### Final case structure

Construct the JSON object:

```json
{
  "id": id,
  "field": {...},
  "curve": {...},
  "expected": {
    "Lpoly": {
      "coeffs_asc": result
    }
  },
  "notes": notes
}
```

---

# 3. Handle file creation

If the file **does not exist**:

Create a new JSON file with:

```json
{
  "cases": [ case ]
}
```

---

# 4. Handle existing file

If the file **already exists**:

1. Read the JSON file.
2. Extract the `"cases"` array.
3. Search for a case with the same `"id"`.

### If the id already exists

Replace the existing case with the new one.

### If the id does not exist

Append the new case to the `"cases"` list.

---

# 5. Write the updated file

Write the JSON back to disk using **pretty-printed formatting**.

For example:

```text
indentation = 2 or 4 spaces
```

---

# Important rules

* Do not modify other cases in the file.
* Preserve the `"cases"` array structure.
* The output must always remain valid JSON.
* Arrays must use **ascending coefficient order**.

---

# Conceptual implementation

The code should follow logic similar to:

```text
if not filename.endswith(".json"):
    error

case = build_case(curve, result, id, notes)

if file does not exist:
    data = { "cases": [case] }

else:
    data = read_json(filename)

    found = false

    for i, c in enumerate(data["cases"]):
        if c["id"] == id:
            data["cases"][i] = case
            found = true

    if not found:
        data["cases"].append(case)

write_json(filename, data)
```

---

# Final instruction

Write **clean, idiomatic code** for your CAS/language that implements the `save_case` function exactly as described above.

