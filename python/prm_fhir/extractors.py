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
import fhirclient.models.patient as fhirpatient

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


def _generate_patient_fhir_ids(
        url_fhir: str,
        search_struct: dict
    ) -> "typing.Generator[str]":
    """Generate FHIR IDs from a patient search struct."""

    _client = _create_fhir_client(url_fhir)

    #TODO: Search shit
    search_object = fhirpatient.Patient.where(search_struct)
    bundle = search_object.perform(_client.server)

    for patient in bundle.entry:
        yield patient.resource.id


def extract_patients(
        url_fhir: str,
        search_struct: dict
    ) -> "typing.Generator[OrderedDict]":
    """Generate patient records from a FHIR endpoint."""

    for patient_fhir_id in _generate_patient_fhir_ids(url_fhir, search_struct):
        # TODO: Requery on IDs
        for name in patient.resource.name:
            patientname = ", ".join([name.family[0], name.given[0]])
        dob = patient.resource.birthDate.isostring
        for ad in patient.resource.address:
            address = ad.city

        yield OrderedDict([
            ('name', patientname),
            ('dob', dob),
            ('address', address),
        ])


def extract_results(
        url_fhir: str,
        name_fhir: str,
        patient_search_struct: dict,
        path_csv_labs: Path,
    ) -> "typing.Generator[OrderedDict]":
    """Extract all the results from a FHIR for the provided patient/lab combinations."""

    assert name_fhir in {'Epic', 'INPC'}

    _client = _create_fhir_client(url_fhir)

    with path_csv_labs.open() as csv_labs:
        reader_labs = csv.DictReader(csv_labs)
        for lab_record in reader_labs:
            for patient_id in _generate_patient_fhir_ids(url_fhir, patient_search_struct):
                raise NotImplementedError()

                yield OrderedDict([
                    ('name', patientname),
                    ('loinc', loinc),
                    ('fhir', name_fhir),
                    ('result', result),
                ])


if __name__ == "__main__":
    url = 'https://open-ic.epic.com/FHIR/api/FHIR/DSTU2'
    search_struct = {'family':'Argonaut', 'given':'Jason'}
    extract = extract_patients(url,search_struct)
    for pat in extract:
        print(pat)
