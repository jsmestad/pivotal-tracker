#!/bin/bash
# curl -u pivotaltracker@silasdavis.net:framhogg -X GET "https://www.pivotaltracker.com/services/v3/tokens/active"
# echo "$TOKEN"
curl -H "X-TrackerToken: 163255c54938bd9b8df169281ee12d61" -X GET "https://www.pivotaltracker.com/services/v3/projects/117325/stories/5371511"
