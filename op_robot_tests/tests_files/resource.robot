*** Variables ***
${RESOURCE}      tenders   # possible values: tenders, auctions
${API_HOST_URL}  http://api.devel.prozorro.office.ovirt
${API_VERSION}   2.4
${BROKER}        Quinta
${DS_HOST_URL}   http://ds.devel.prozorro.office.ovirt
${ROLE}          viewer
${EDR_HOST_URL}  https://lb.edr-sandbox.openprocurement.org
${EDR_VERSION}   0

${DASU_RESOURCE}      monitorings
${DASU_API_HOST_URL}  https://audit-api-sandbox.prozorro.gov.ua
${DASU_API_VERSION}   2.4

${DS_REGEXP}        ^https?:\/\/public.docs(?:-sandbox)?\.openprocurement\.org\/get\/([0-9A-Fa-f]{32})
${AUCTION_REGEXP}   ^https?:\/\/auction(?:-sandbox)?\.openprocurement\.org\/tenders\/([0-9A-Fa-f]{32})
