Potential tables:

| Name | Key(s) | Contents |
| :--- | :----- | :------- |
| `patients` | `name` | Dimension table of patients. |
| `labs` | `loinc` | Dimension table of lab types. |
| `results` | `name`, `loinc` | Fact table of specific lab results. |
