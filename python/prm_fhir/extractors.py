"""
### CODE OWNERS: Shea Parkes

### OBJECTIVE:
  Extraction methods for relevant items.

### DEVELOPER NOTES:
  The lab dimenion table will likely be hand-entered.
"""
import csv
import typing
from collections import OrderedDict
from pathlib import Path

from fhirclient.client import FHIRClient

# =============================================================================
# LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE
# =============================================================================

def _create_fhir_client(
        url_fhir: str,
        *,
        app_id: str='prm_analytics'
    ) -> FHIRClient:
    """Instantiate a FHIRClient"""
    return FHIRClient(settings={
        'app_id': app_id,
        'api_base': url_fhir,
    })


def extract_patients(
        url_fhir: str,
        search_struct: dict,
    ) -> typing.Generator[OrderedDict]:
    """Generate patient records from a FHIR endpoint."""

    _client = _create_fhir_client(url_fhir)

    #TODO: Search shit

    yield OrderedDict([
        ('name', patientname),
        ('dob', isodate),
        ('address', blah),
    ])


def extract_results(
        url_fhir,
        path_csv_labs: Path,
        path_csv_patients: Path,
    ) -> typing.Generator[OrderedDict]:
    """Extract all the results from a FHIR for the provided patient/lab combinations."""

    _client = _create_fhir_client(url_fhir)

    with path_csv_labs.open() as csv_labs, path_csv_patients.open() as csv_patients:
        reader_labs = csv.DictReader(csv_labs)
        reader_patients = csv.DictReader(csv_patients)
        for lab_record in reader_labs:
            for patient_record in reader_patients:
                raise NotImplementedError()

                yield OrderedDict([
                    ('name', patientname),
                    ('loinc', loinc),
                    ('result', result),
                ])
