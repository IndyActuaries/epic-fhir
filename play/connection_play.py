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

reg_settings = {
    'app_id': 'prm_analytics',
    'api_base': 'http://134.68.33.32/fhir/'
}
epic_settings = {
    'app_id': 'prm_analytics',
    'api_base': 'https://open-ic.epic.com/FHIR/api/FHIR/DSTU2'
}

epic = client.FHIRClient(settings=epic_settings)
reg = client.FHIRClient(settings=reg_settings)
import fhirclient.models.patient as p


ragsdales = p.Patient.where(struct={'family':'Ragsdale', 'given':'*'})
argonauts = p.Patient.where(struct={'family':'Argonaut', 'given':'*'})
bundle_ragsdales = ragsdales.perform(epic.server)
bundle_argonauts = argonauts.perform(epic.server)


for patient in bundle_ragsdales.entry:
    for id in patient.resource.identifier:
        print(id.system)
        print(id.use)
        print(id.value)
