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
from time import sleep
from pathlib import Path
import prm_fhir.extractors

PATH_DATA = Path(prm_fhir.extractors.__file__).parents[2] / "data"

#==============================================================================
# LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE
#==============================================================================




if __name__ == "__main__":
    ARGS_PATIENTS = [
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
        for args in ARGS_PATIENTS:
            sleep(.1)
            WRITER.writerows(
                prm_fhir.extractors.extract_patients(**args)
                )

    PATH_LABS = PATH_DATA / "labs.csv"
    ARGS_RESULTS = [
        {
            "url_fhir": "https://open-ic.epic.com/FHIR/api/FHIR/DSTU2",
            "name_fhir": "Epic",
            "patient_search_struct": {"family": "Argonaut", "given": "*"},
            "path_csv_labs": PATH_LABS,
        },
        {
            "url_fhir": "https://open-ic.epic.com/FHIR/api/FHIR/DSTU2",
            "name_fhir": "Epic",
            "patient_search_struct": {"family": "Ragsdale", "given": "*"},
            "path_csv_labs": PATH_LABS,
        },
        {
            "url_fhir": "http://134.68.33.32/fhir/",
            "name_fhir": "INPC",
            "patient_search_struct": {"family": "Argonaut"},
            "path_csv_labs": PATH_LABS,
        },
        {
            "url_fhir": "http://134.68.33.32/fhir/",
            "name_fhir": "INPC",
            "patient_search_struct": {"family": "Ragsdale"},
            "path_csv_labs": PATH_LABS,
        },
        ]
    PATH_RESULTS = PATH_DATA / "results.csv"
    with PATH_RESULTS.open("w", newline="") as patients:
        FIELDNAMES = prm_fhir.extractors.extract_results.fieldnames
        WRITER = csv.DictWriter(
            patients,
            fieldnames=FIELDNAMES,
            )
        WRITER.writeheader()
        for args in ARGS_RESULTS:
            WRITER.writerows(
                prm_fhir.extractors.extract_results(**args)
                )
