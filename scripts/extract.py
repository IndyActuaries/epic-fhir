"""
## CODE OWNERS: Kyle Baird, Shea Parkes
### OWNERS ATTEST TO THE FOLLOWING:
  * The `master` branch will meet Milliman QRM standards at all times.
  * Deliveries will only be made from code in the `master` branch.
  * Review/Collaboration notes will be captured in Pull Requests.

### OBJECTIVE:
  Extract data from the EHR to feed the analytics

### DEVELOPER NOTES:
  <none>
"""
import csv
from pathlib import Path
import prm_fhir.extractors

PATH_DATA = Path(prm_fhir.extractors.__file__).parents[2] / "data"

#==============================================================================
# LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE
#==============================================================================




if __name__ == "__main__":
    ARGS = [
        {
            "url_fhir": "https://open-ic.epic.com/FHIR/api/FHIR/DSTU2",
            "search_struct": {"family": "Argonaut", "given": "*"},
        },
        {
            "url_fhir": "https://open-ic.epic.com/FHIR/api/FHIR/DSTU2",
            "search_struct": {"family": "Ragsdale", "given": "*"},
        },
#        {
#            "url_fhir": "http://134.68.33.32/fhir/",
#            "search_struct": {"family": "Argonaut"},
#        },
#        {
#            "url_fhir": "http://134.68.33.32/fhir/",
#            "search_struct": {"family": "Ragsdale"},
#        },
        ]
    PATH_PATIENTS = PATH_DATA / "patients.csv"
    with PATH_PATIENTS.open("w", newline="") as patients:
        FIELDNAMES = prm_fhir.extractors.extract_patients.fieldnames
        WRITER = csv.DictWriter(
            patients,
            fieldnames=FIELDNAMES,
            )
        WRITER.writeheader()
        for args in ARGS:
            WRITER.writerows(
                prm_fhir.extractors.extract_patients(**args)
                )
