"""
### CODE OWNERS: Shea Parkes

### OBJECTIVE:
  Prove I can connect.

### DEVELOPER NOTES:
  <What future developers need to know.>
"""

from fhirclient import client

# =============================================================================
# LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE
# =============================================================================

settings = {
    'app_id': 'prm_analytics',
    'api_base': 'https://open-ic.epic.com/FHIR/api/FHIR/DSTU2'
}
smart = client.FHIRClient(settings=settings)

import fhirclient.models.patient as p
patient = p.Patient.read('Tbt3KuCY0B5PSrJvCu2j-PlK.aiHsu2xUjUM8bWpetXoB', smart.server)
patient.birthDate.isostring

smart.human_name(patient.name[0])
