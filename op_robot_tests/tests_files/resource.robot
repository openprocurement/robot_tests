*** Variables ***
${RESOURCE}      tenders   # possible values: tenders, auctions
${API_HOST_URL}  https://lb-api-sandbox.prozorro.gov.ua
${API_VERSION}   2.4
${BROKER}        Quinta
${DS_HOST_URL}   https://upload-docs-sandbox.prozorro.gov.ua
${ROLE}          viewer
${EDR_HOST_URL}  https://lb-edr-sandbox.prozorro.gov.ua
${EDR_VERSION}   0

${DASU_RESOURCE}      monitorings
${DASU_API_HOST_URL}  https://audit-api-sandbox.prozorro.gov.ua
${DASU_API_VERSION}   2.4

${DS_REGEXP}        ^https?:\\/\\/public-docs(?:-sandbox)?\\.prozorro\\.gov\\.ua\\/get\\/([0-9A-Fa-f]{32})
${AUCTION_REGEXP}   ^https?:\\/\\/auction(?:-sandbox)?\\.prozorro\\.gov\\.ua\\/tenders\\/([0-9A-Fa-f]{32}) 
