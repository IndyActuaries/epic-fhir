"""
### CODE OWNERS: Shea Parkes, Steve Gredell

### OBJECTIVE:
  Extraction methods for relevant items.

### DEVELOPER NOTES:
  The lab dimenion table will likely be hand-entered.
"""
import csv
import typing
import traceback
from collections import OrderedDict
from pathlib import Path

from fhirclient.client import FHIRClient
import fhirclient.models.patient as fhirpatient
import fhirclient.models.observation as fhirobs

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
        fhir_client: FHIRClient,
        search_struct: dict
    ) -> "typing.Generator[str]":
    """Generate FHIR IDs from a patient search struct."""

    search_object = fhirpatient.Patient.where(search_struct)
    bundle = search_object.perform(fhir_client.server)

    for patient in bundle.entry:
        yield patient.resource.id


def extract_patients(
        url_fhir: str,
        search_struct: dict
    ) -> "typing.Generator[OrderedDict]":
    """Generate patient records from a FHIR endpoint."""

    _client = _create_fhir_client(url_fhir)

    for patient_fhir_id in _generate_patient_fhir_ids(_client, search_struct):
        patient = fhirpatient.Patient.read(patient_fhir_id, _client.server)
        for name in patient.name:
            patientname = ", ".join([name.family[0], name.given[0]])
        dob = patient.birthDate.isostring
        if patient.address is None:
            address = ""
        else:
            for ad in patient.address:
                address = ad.city

        yield OrderedDict([
            ('name', patientname),
            ('dob', dob),
            ('address', address),
        ])

extract_patients.fieldnames = [
    'name',
    'dob',
    'address',
]


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
            for patient_id in _generate_patient_fhir_ids(_client, patient_search_struct):
                lab_search_struct = {'patient': patient_id, 'code':lab_record['loinc']}
                search_object = fhirobs.Observation.where(lab_search_struct)
                lab_bundle = search_object.perform(_client.server)

                if lab_bundle.entry is None:
                    continue

                for lab in lab_bundle.entry:
                    try:
                        for code in lab.resource.code.coding:
                            if code is None:
                                continue
                            else:
                                loinc = code.code
                    except AttributeError:
                        print("Failed, probably trying to read an Observation as an OperationOutcome.")
                        traceback.print_exc()
                        continue



                    try:
                        value = lab.resource.valueQuantity.value
                        if value is None:
                            continue
                    except AttributeError:
                        print("Failed, probably trying to read an Observation as an OperationOutcome.")
                        traceback.print_exc()
                        continue

                    try:
                        patient_name = _get_patient_name(lab.resource.subject.reference)
                        if patient_name is None:
                            continue
                    except AttributeError:
                        print("Failed, probably trying to read an Observation as an OperationOutcome.")
                        traceback.print_exc()
                        continue

                    try:
                        date = lab.resource.effectiveDateTime.isostring
                        if date is None:
                            continue
                    except AttributeError:
                        print("Failed, probably trying to read an Observation as an OperationOutcome.")
                        traceback.print_exc()
                        continue

                    yield OrderedDict([
                        ('name', patient_name),
                        ('loinc', loinc),
                        ('fhir', name_fhir),
                        ('result', value),
                        ('date', date)
                    ])

extract_results.fieldnames = [
    'name',
    'loinc',
    'fhir',
    'result',
    'date',
    ]

def _get_patient_name(patient_url):
    result = patient_url.split('/')
    url_fhir = "/".join(result[0:7])
    patient_fhir_id = result[-1]
    _client = _create_fhir_client(url_fhir)
    patient = fhirpatient.Patient.read(patient_fhir_id, _client.server)
    for name in patient.name:
        if name is None:
            patientname = ""
        else:
            patientname = ", ".join([name.family[0], name.given[0]])
    return patientname

if __name__ == "__main__":

    url = 'https://open-ic.epic.com/FHIR/api/FHIR/DSTU2'
    #url = 'http://134.68.33.32/fhir/'
    search_struct = {'family':'Argonaut', 'given':'Jason'}
    labs_csv = Path("c:/Users/Steve.Gredell/repos/epic-fhir/data/labs.csv")
    extract = extract_patients(url,search_struct)
    for pat in extract:
        print(pat)

    print("Extracting labs\n\n")
    extract_labs = extract_results(url, "Epic", search_struct, labs_csv)
    for lab in extract_labs:
        print(lab)
