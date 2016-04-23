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
