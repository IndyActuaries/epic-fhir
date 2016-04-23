"""
### CODE OWNERS: Shea Parkes

### OBJECTIVE:
  Extraction methods for relevant items.

### DEVELOPER NOTES:
  <none>
"""

import typing
from collections import OrderedDict

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

def extract_patients(
        url_fhir: str,
        search_struct: dict
    ) -> "typing.Generator[OrderedDict]":
    """Generate patient records from a FHIR endpoint."""

    _client = _create_fhir_client(url_fhir)

    #TODO: Search shit
    search_object = fhirpatient.Patient.where(search_struct)
    bundle = search_object.perform(_client.server)

    for patient in bundle.entry:
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

if __name__ == "__main__":
    url = 'https://open-ic.epic.com/FHIR/api/FHIR/DSTU2'
    search_struct = {'family':'Argonaut', 'given':'Jason'}
    extract = extract_patients(url,search_struct)
    for pat in extract:
        print(pat)