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
    URLS = [
        "https://open-ic.epic.com/FHIR/api/FHIR/DSTU2",
        #"http://134.68.33.32/fhir/",
        ]
    SEARCH_STRUCTS = [
        {"family": "Argonaut", "given": "*"},
        {"family": "Ragsdale", "given": "*"},
        ]
    PATH_PATIENTS = PATH_DATA / "patients.csv"
    with PATH_PATIENTS.open("w", newline="") as patients:
        fieldnames = prm_fhir.extractors.extract_patients.fieldnames
        writer = csv.DictWriter(
            patients,
            fieldnames=fieldnames,
            )
        writer.writeheader()
        for url in URLS:
            for search_struct in SEARCH_STRUCTS:
                writer.writerows(prm_fhir.extractors.extract_patients(url, search_struct))
